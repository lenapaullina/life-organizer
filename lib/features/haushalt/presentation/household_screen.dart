import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../../../shared/utils/status_calculator.dart';
import '../../../shared/widgets/interval_progress_bar.dart';
import '../../../shared/widgets/quick_action_button.dart';
import '../../../shared/widgets/status_pill.dart';
import '../application/household_task_providers.dart';
import '../application/household_task_with_status.dart';
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

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(sortedHouseholdTasksProvider);

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
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (allTasks) {
          // Gerade zum Löschen vorgemerkte Aufgaben werden sofort
          // ausgeblendet, unabhängig davon, wann der DB-Delete
          // tatsächlich feuert (siehe _deleteWithUndo).
          final tasks =
              allTasks.where((t) => !_pendingDeleteIds.contains(t.task.id)).toList();

          if (tasks.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final entry = tasks[index];
              return Dismissible(
                key: ValueKey(entry.task.id),
                direction: DismissDirection.horizontal,
                background: _DismissBackground(alignment: Alignment.centerLeft),
                secondaryBackground: _DismissBackground(alignment: Alignment.centerRight),
                onDismissed: (_) => _deleteWithUndo(entry.task.id, entry.task.name),
                child: _TaskCard(
                  entry: entry,
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

/// Roter Hintergrund mit Papierkorb-Icon, der beim Wischen sichtbar
/// wird – je nach Wischrichtung links oder rechts ausgerichtet.
class _DismissBackground extends StatelessWidget {
  final Alignment alignment;
  const _DismissBackground({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.statusRedBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.statusRed, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      alignment: alignment,
      child: const Icon(Icons.delete_outline, color: AppColors.statusRed),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final HouseholdTaskWithStatus entry;
  final VoidCallback onDelete;

  const _TaskCard({required this.entry, required this.onDelete});

  Future<void> _markCompletedWithUndo(BuildContext context, WidgetRef ref, {
    required String taskId,
    required String taskName,
  }) async {
    final repo = ref.read(householdTaskRepositoryProvider);
    await repo.markCompleted(taskId);
    // Kuh-Evolution: jede erledigte Aufgabe bringt direkt Milch und,
    // falls noch Platz auf der Weide ist, eine neue Level-1-Kuh.
    unawaited(ref.read(cowPastureProvider.notifier).awardSuccess(milk: milkPerHouseholdTask));

    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('"$taskName" erledigt ${_cheerFor(taskName)}'),
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
                      await _markCompletedWithUndo(context, ref, taskId: task.id, taskName: task.name);
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                // Bearbeiten + Löschen gebündelt in einem Menü – für
                // alle, die die Swipe-zum-Löschen-Geste nicht entdecken
                // oder lieber gezielt tippen, statt für jede Aktion
                // einen eigenen Icon-Button in der ohnehin schon vollen
                // Kopfzeile zu brauchen.
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    if (value == 'edit') {
                      showEditHouseholdTaskDialog(context, ref, task);
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: AppSpacing.xs),
                          Text('Bearbeiten'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
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
              child: QuickActionButton(
                label: 'Heute erledigt',
                icon: Icons.check_circle_outline,
                onPressed: () => _markCompletedWithUndo(
                  context,
                  ref,
                  taskId: task.id,
                  taskName: task.name,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'Noch keine Aufgaben angelegt.\nTippe auf + um loszulegen.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
