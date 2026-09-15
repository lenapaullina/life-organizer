import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/status_calculator.dart';
import '../../../shared/widgets/interval_progress_bar.dart';
import '../../../shared/widgets/quick_action_button.dart';
import '../../../shared/widgets/status_pill.dart';
import '../application/household_task_providers.dart';
import '../application/household_task_with_status.dart';
import 'add_household_task_sheet.dart';
import 'edit_household_task_dialog.dart';
import 'household_history_screen.dart';

/// Kleine positive Verstärkung nach dem Erledigen – rotiert zufällig,
/// damit es sich nicht wie eine leere Floskel abnutzt.
String _cheerFor(String taskName) {
  const cheers = ['✨', '🎉', '💜', '👏', '🌸'];
  return cheers[taskName.hashCode.abs() % cheers.length];
}

class HouseholdScreen extends ConsumerWidget {
  const HouseholdScreen({super.key});

  String _statusLabel(TaskStatus status) => switch (status) {
        TaskStatus.green => 'Im Plan',
        TaskStatus.yellow => 'Bald fällig',
        TaskStatus.red => 'Überfällig',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(sortedHouseholdTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Haushalt'),
        actions: [
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
        data: (tasks) {
          if (tasks.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => _TaskCard(entry: tasks[index]),
          );
        },
      ),
      // Öffnet die Preset-Schnellauswahl statt direkt einen Freitext-Dialog.
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddHouseholdTaskSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final HouseholdTaskWithStatus entry;

  const _TaskCard({required this.entry});

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
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => showEditHouseholdTaskDialog(context, ref, task),
                  visualDensity: VisualDensity.compact,
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
                onPressed: () async {
                  final repo = ref.read(householdTaskRepositoryProvider);
                  await repo.markCompleted(task.id);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('"${task.name}" erledigt ${_cheerFor(task.name)}'),
                          duration: const Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'Rückgängig',
                            onPressed: () => repo.undoLastCompletion(task.id),
                          ),
                        ),
                      );
                  }
                },
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
