import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/status_calculator.dart';
import '../../../shared/widgets/flying_reward_overlay.dart';
import '../../../shared/widgets/interval_progress_bar.dart';
import '../../../shared/widgets/quick_action_button.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../../settings/application/app_settings_providers.dart';
import '../application/household_tag_assignment_providers.dart';
import '../application/household_tag_providers.dart';
import '../application/household_task_providers.dart';
import '../application/household_task_with_status.dart';
import '../domain/household_tag.dart';
import 'add_household_task_sheet.dart';
import 'edit_household_task_dialog.dart';
import 'household_history_screen.dart';
import 'micro_task_splitter_sheet.dart';
import 'random_task_screen.dart';

/// Kleine positive Verstärkung nach dem Erledigen – rotiert zufällig,
/// damit es sich nicht wie eine leere Floskel abnutzt.
String _cheerFor(String taskName) {
  const cheers = ['✨', '🎉', '💜', '👏', '🌸'];
  return cheers[taskName.hashCode.abs() % cheers.length];
}

/// Wie lange nach dem Löschen einer Aufgabe noch "Rückgängig"
/// funktioniert, bevor der DB-Eintrag (inkl. Historie, wegen
/// Cascade-Delete) wirklich entfernt wird.
const _undoDeleteWindow = Duration(seconds: 4);

class HouseholdScreen extends ConsumerStatefulWidget {
  const HouseholdScreen({super.key});

  @override
  ConsumerState<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends ConsumerState<HouseholdScreen> {
  // Löschen ist bewusst "optimistisch": die Aufgabe verschwindet
  // sofort aus der Liste, der eigentliche DB-Delete (der wegen
  // Cascade-Delete auch die Erledigungs-Historie mitlöscht) passiert
  // erst nach Ablauf von _undoDeleteWindow – "Rückgängig" bricht das
  // einfach ab, ohne dass irgendwas wiederhergestellt werden müsste.
  final Set<String> _pendingDeleteIds = {};
  final Map<String, Timer> _pendingDeleteTimers = {};

  @override
  void dispose() {
    for (final timer in _pendingDeleteTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _deleteWithUndo(String taskId, String taskName) {
    setState(() => _pendingDeleteIds.add(taskId));

    _pendingDeleteTimers[taskId]?.cancel();
    _pendingDeleteTimers[taskId] = Timer(_undoDeleteWindow, () {
      _pendingDeleteTimers.remove(taskId);
      if (_pendingDeleteIds.contains(taskId)) {
        ref.read(householdTaskRepositoryProvider).deleteTask(taskId);
        ref.read(taskTagAssignmentProvider.notifier).clearTask(taskId);
      }
    });

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('"$taskName" gelöscht'),
          duration: _undoDeleteWindow,
          action: SnackBarAction(
            label: 'Rückgängig',
            onPressed: () {
              _pendingDeleteTimers[taskId]?.cancel();
              _pendingDeleteTimers.remove(taskId);
              if (mounted) setState(() => _pendingDeleteIds.remove(taskId));
            },
          ),
        ),
      );
  }

  Future<void> _openTagFilterSheet() async {
    final allTags = ref.read(householdTagProvider).valueOrNull ?? const [];
    if (allTags.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(
          content: Text('Noch keine Tags angelegt – erst über das Menü an einer Aufgabe erstellen.'),
        ));
      return;
    }

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
      ),
      builder: (sheetContext) => Consumer(
        builder: (sheetContext, sheetRef, _) {
          final active = sheetRef.watch(activeTagFilterProvider);
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nach Tags filtern', style: Theme.of(sheetContext).textTheme.headlineMedium),
                    if (active.isNotEmpty)
                      TextButton(
                        onPressed: () =>
                            sheetRef.read(activeTagFilterProvider.notifier).state = {},
                        child: const Text('Filter zurücksetzen'),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final tag in allTags)
                      FilterChip(
                        avatar: Text(tag.emoji),
                        label: Text(tag.name),
                        selected: active.contains(tag.id),
                        onSelected: (selected) {
                          final next = Set<String>.from(active);
                          if (selected) {
                            next.add(tag.id);
                          } else {
                            next.remove(tag.id);
                          }
                          sheetRef.read(activeTagFilterProvider.notifier).state = next;
                        },
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(sortedHouseholdTasksProvider);
    final assignments = ref.watch(taskTagAssignmentProvider);
    final activeFilter = ref.watch(activeTagFilterProvider);
    final tagById = ref.watch(householdTagByIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Haushalt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino_outlined),
            tooltip: 'Zufällige Aufgabe',
            onPressed: () => showRandomTaskScreen(context),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historie',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HouseholdHistoryScreen()),
            ),
          ),
          PopupMenuButton<String>(
            icon: Badge(
              isLabelVisible: activeFilter.isNotEmpty,
              label: Text('${activeFilter.length}'),
              child: const Icon(Icons.more_vert),
            ),
            onSelected: (value) {
              if (value == 'filter_tags') _openTagFilterSheet();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'filter_tags',
                child: Row(
                  children: [
                    const Icon(Icons.filter_alt_outlined, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Text(activeFilter.isEmpty
                        ? 'Nach Tags filtern'
                        : 'Nach Tags filtern (${activeFilter.length} aktiv)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (allTasks) {
          // Gerade zum Löschen vorgemerkte Aufgaben werden sofort
          // ausgeblendet, unabhängig davon, wann der DB-Delete
          // tatsächlich feuert (siehe _deleteWithUndo). Danach greift,
          // sofern aktiv, der Tag-Filter (UND-Verknüpfung ist hier zu
          // streng für den Alltag – schon EIN passender Tag reicht).
          final tasks = allTasks.where((t) {
            if (_pendingDeleteIds.contains(t.task.id)) return false;
            if (activeFilter.isEmpty) return true;
            final taskTags = assignments[t.task.id] ?? const <String>{};
            return taskTags.any(activeFilter.contains);
          }).toList();

          if (tasks.isEmpty) {
            return _EmptyState(filtered: activeFilter.isNotEmpty);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final entry = tasks[index];
              final taskTagIds = assignments[entry.task.id] ?? const <String>{};
              final taskTags = [
                for (final id in taskTagIds)
                  if (tagById[id] != null) tagById[id]!
              ];
              return Dismissible(
                key: ValueKey(entry.task.id),
                direction: DismissDirection.horizontal,
                background: const _DismissBackground(
                  alignment: Alignment.centerLeft,
                  color: AppColors.statusGreen,
                  bgColor: AppColors.statusGreenBg,
                  icon: Icons.check_circle_outline,
                ),
                secondaryBackground: const _DismissBackground(
                  alignment: Alignment.centerRight,
                  color: AppColors.statusRed,
                  bgColor: AppColors.statusRedBg,
                  icon: Icons.delete_outline,
                ),
                // Nach rechts wischen = erledigt (Aufgabe bleibt in der
                // Liste, daher confirmDismiss=false), nach links wischen
                // = löschen (confirmDismiss=true, onDismissed übernimmt).
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    await _TaskCard.markCompletedWithUndo(
                      context,
                      ref,
                      taskId: entry.task.id,
                      taskName: entry.task.name,
                    );
                    return false;
                  }
                  return true;
                },
                onDismissed: (_) => _deleteWithUndo(entry.task.id, entry.task.name),
                child: _TaskCard(
                  entry: entry,
                  tags: taskTags,
                  onDelete: () => _deleteWithUndo(entry.task.id, entry.task.name),
                ),
              );
            },
          );
        },
      ),
      // Öffnet die Preset-Schnellauswahl statt direkt einen Freitext-Dialog.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await showAddHouseholdTaskSheet(context, ref);
          if (created == true && context.mounted) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Aufgabe hinzugefügt ✨'),
                  duration: Duration(seconds: 2),
                ),
              );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Hintergrund, der beim Wischen sichtbar wird – grün+Haken beim
/// Wischen nach rechts (erledigen), rot+Papierkorb nach links (löschen).
class _DismissBackground extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _DismissBackground({
    required this.alignment,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: color, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      alignment: alignment,
      child: Icon(icon, color: color),
    );
  }
}

/// Dialog zum Verwalten der Tags EINER Aufgabe: bestehende Tags
/// an-/abhaken, oder direkt einen neuen (Name + Emoji) anlegen und
/// zuweisen. Ersetzt die alte, fest verdrahtete Dringend/Entspannt-
/// Auswahl im PopupMenuButton.
Future<void> _showManageTagsDialog(BuildContext context, WidgetRef ref, String taskId) async {
  final nameController = TextEditingController();
  final emojiController = TextEditingController(text: '🏷️');

  await showDialog(
    context: context,
    builder: (dialogContext) => Consumer(
      builder: (dialogContext, dialogRef, _) {
        final allTags = dialogRef.watch(householdTagProvider).valueOrNull ?? const [];
        final assigned = dialogRef.watch(taskTagAssignmentProvider)[taskId] ?? const <String>{};

        return AlertDialog(
          title: const Text('Tags verwalten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (allTags.isEmpty)
                  const Text('Noch keine Tags angelegt.')
                else
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final tag in allTags)
                        FilterChip(
                          avatar: Text(tag.emoji),
                          label: Text(tag.name),
                          selected: assigned.contains(tag.id),
                          onSelected: (_) => dialogRef
                              .read(taskTagAssignmentProvider.notifier)
                              .toggleTag(taskId, tag.id),
                        ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.md),
                const Divider(),
                const SizedBox(height: AppSpacing.sm),
                const Text('Neuen Tag anlegen', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: TextField(
                        controller: emojiController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(labelText: 'Emoji'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'z. B. Putzen, Einkauf, Schnell'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () async {
                      final newTag = await dialogRef.read(householdTagProvider.notifier).createTag(
                            name: nameController.text,
                            emoji: emojiController.text,
                          );
                      if (newTag != null) {
                        await dialogRef
                            .read(taskTagAssignmentProvider.notifier)
                            .toggleTag(taskId, newTag.id);
                        nameController.clear();
                        emojiController.text = '🏷️';
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tag erstellen & zuweisen'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Fertig'),
            ),
          ],
        );
      },
    ),
  );
}

class _TaskCard extends ConsumerWidget {
  final HouseholdTaskWithStatus entry;
  final List<HouseholdTag> tags;
  final VoidCallback onDelete;

  const _TaskCard({required this.entry, required this.tags, required this.onDelete});

  /// Statisch aufrufbar, damit sowohl der "Heute erledigt"-Button als
  /// auch das Swipe-nach-rechts-Gesture (im übergeordneten
  /// HouseholdScreen, das keinen direkten Zugriff auf den lokalen
  /// BuildContext der Karte hat) dieselbe Logik nutzen.
  static Future<void> markCompletedWithUndo(
    BuildContext context,
    WidgetRef ref, {
    required String taskId,
    required String taskName,
    Offset? flyFrom,
  }) async {
    final repo = ref.read(householdTaskRepositoryProvider);
    await repo.markCompleted(taskId);

    // Kuh-Evolution: jede erledigte Aufgabe bringt direkt Milch und,
    // falls noch Platz auf der Weide ist, eine neue Level-1-Kuh.
    final spawnResult = await ref
        .read(cowPastureProvider.notifier)
        .awardSuccess(milk: milkPerHouseholdTask, originLabel: taskName);

    hapticTaskComplete();
    final soundEnabled = ref.read(appSettingsProvider).soundEnabled;
    maybePlaySound(soundEnabled, SoundEvent.taskComplete);

    if (context.mounted) {
      final start = flyFrom ?? globalCenterOf(context);
      if (start != null) {
        FlyingRewardOverlay.play(context, startGlobalPosition: start, emoji: '🥛');
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              spawnResult == CowSpawnResult.pastureFull
                  ? 'Weide voll! Merge deine Kühe! 🐄'
                  : '"$taskName" erledigt ${_cheerFor(taskName)}',
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Rückgängig',
              onPressed: () => repo.undoLastCompletion(taskId),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = entry.task;
    final status = entry.intervalStatus;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.auto_awesome_outlined, size: 20),
                  tooltip: 'In Schritte zerlegen',
                  onPressed: () async {
                    final markDone = await showMicroTaskSplitterSheet(context, task.name);
                    if (markDone == true && context.mounted) {
                      await _TaskCard.markCompletedWithUndo(
                        context,
                        ref,
                        taskId: task.id,
                        taskName: task.name,
                      );
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                // Bearbeiten/Löschen/Tags gebündelt in einem Menü – für
                // alle, die die Wisch-Gesten nicht entdecken oder lieber
                // gezielt tippen.
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    if (value == 'edit') {
                      showEditHouseholdTaskDialog(context, ref, task);
                    } else if (value == 'delete') {
                      onDelete();
                    } else if (value == 'manage_tags') {
                      _showManageTagsDialog(context, ref, task.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: AppSpacing.xs),
                          Text('Bearbeiten'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'manage_tags',
                      child: Row(
                        children: [
                          Icon(Icons.local_offer_outlined, size: 18),
                          SizedBox(width: AppSpacing.xs),
                          Text('Tags verwalten'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: AppColors.statusRed),
                          SizedBox(width: AppSpacing.xs),
                          Text('Löschen'),
                        ],
                      ),
                    ),
                  ],
                ),
                StatusPill(
                  status: status.status,
                  label: switch (status.status) {
                    TaskStatus.green => 'Im Plan',
                    TaskStatus.yellow => 'Bald fällig',
                    TaskStatus.red => 'Überfällig',
                  },
                ),
              ],
            ),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [for (final tag in tags) _TagBadge(tag: tag)],
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            IntervalProgressBar(intervalStatus: status),
            const SizedBox(height: AppSpacing.xs),
            Text(
              status.daysSinceCompleted == null
                  ? 'Noch nie erledigt · alle ${task.intervalDays} Tage'
                  : 'Alle ${task.intervalDays} Tage · zuletzt vor ${status.daysSinceCompleted} Tagen',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: Builder(
                builder: (buttonContext) => QuickActionButton(
                  label: 'Heute erledigt',
                  icon: Icons.check_circle_outline,
                  onPressed: () => _TaskCard.markCompletedWithUndo(
                    buttonContext,
                    ref,
                    taskId: task.id,
                    taskName: task.name,
                    flyFrom: globalCenterOf(buttonContext),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kleines 2000er-Forum-Badge für einen frei angelegten Tag.
class _TagBadge extends StatelessWidget {
  final HouseholdTag tag;
  const _TagBadge({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
        border: Border.all(color: AppColors.accentCyan, width: 1.2),
      ),
      child: Text(
        '${tag.emoji} ${tag.name}',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool filtered;
  const _EmptyState({this.filtered = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          filtered
              ? 'Keine Aufgaben mit den aktiven Tag-Filtern.\nFilter oben rechts anpassen.'
              : 'Noch keine Aufgaben angelegt.\nTippe auf + um loszulegen.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
