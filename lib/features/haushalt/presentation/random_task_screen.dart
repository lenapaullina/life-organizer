import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/status_calculator.dart';
import '../../../shared/widgets/status_pill.dart';
import '../application/household_task_providers.dart';
import '../application/household_task_with_status.dart';

/// "Random Task Generator" / Würfel-Button: gegen Executive
/// Dysfunction vor einer vollen To-Do-Liste. Zeigt GENAU eine Aufgabe
/// und blendet den Rest komplett aus – die Entscheidung "womit fange
/// ich an?" wird der App überlassen, nicht der Person.
void showRandomTaskScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const RandomTaskScreen(),
    ),
  );
}

class RandomTaskScreen extends ConsumerStatefulWidget {
  const RandomTaskScreen({super.key});

  @override
  ConsumerState<RandomTaskScreen> createState() => _RandomTaskScreenState();
}

class _RandomTaskScreenState extends ConsumerState<RandomTaskScreen> {
  HouseholdTaskWithStatus? _picked;
  bool _pickedOnce = false;

  /// Bevorzugt fällige/bald fällige Aufgaben (gelb/rot) – wer würfelt,
  /// will meist wissen "was ist wirklich dran", nicht irgendwas.
  /// Nur wenn gar nichts fällig ist, zählt jede Aufgabe.
  HouseholdTaskWithStatus? _pickFrom(List<HouseholdTaskWithStatus> tasks) {
    if (tasks.isEmpty) return null;
    final due = tasks.where((t) => t.intervalStatus.status != TaskStatus.green).toList();
    final pool = due.isNotEmpty ? due : tasks;
    return pool[Random().nextInt(pool.length)];
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(sortedHouseholdTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: tasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Fehler: $err')),
          data: (tasks) {
            if (!_pickedOnce) {
              _picked = _pickFrom(tasks);
              _pickedOnce = true;
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    ),
                  ),
                  const Spacer(),
                  if (_picked == null) ...[
                    const Text(
                      'Noch keine Aufgaben angelegt –\nda gibt es nichts zu würfeln.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                  ] else ...[
                    const Text(
                      '🎲 Genau diese eine:',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      _picked!.task.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    StatusPill(
                      status: _picked!.intervalStatus.status,
                      label: switch (_picked!.intervalStatus.status) {
                        TaskStatus.green => 'Im Plan',
                        TaskStatus.yellow => 'Bald fällig',
                        TaskStatus.red => 'Überfällig',
                      },
                    ),
                  ],
                  const Spacer(),
                  if (_picked != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Heute erledigt'),
                        onPressed: () async {
                          final repo = ref.read(householdTaskRepositoryProvider);
                          await repo.markCompleted(_picked!.task.id);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => setState(() => _picked = _pickFrom(tasks)),
                      child: const Text('Andere Aufgabe würfeln'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
