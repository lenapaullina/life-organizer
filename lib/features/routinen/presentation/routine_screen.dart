import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/flying_reward_overlay.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../../settings/application/app_settings_providers.dart';
import '../application/routine_providers.dart';

class RoutineScreen extends ConsumerWidget {
  final Routine routine;

  const RoutineScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(routineItemsProvider(routine.id));
    final completionAsync = ref.watch(todayCompletionProvider(routine.id));
    final streakAsync = ref.watch(streakProvider(routine.id));

    return Scaffold(
      appBar: AppBar(title: Text(routine.name)),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (items) {
          final completedIds = completionAsync.maybeWhen(
            data: (c) => c == null
                ? <String>{}
                : (jsonDecode(c.completedItemIds) as List).cast<String>().toSet(),
            orElse: () => <String>{},
          );

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (routine.streakEnabled)
                _StreakBadge(
                  streak: streakAsync.maybeWhen(data: (s) => s, orElse: () => 0),
                ),
              const SizedBox(height: AppSpacing.md),
              ...items.map(
                (item) => Builder(
                  builder: (itemContext) => _RoutineItemTile(
                    item: item,
                    checked: completedIds.contains(item.id),
                    onToggle: () async {
                      final fullyCompleted = await ref
                          .read(routineRepositoryProvider)
                          .toggleItemForToday(
                            routineId: routine.id,
                            itemId: item.id,
                            totalItemCount: items.length,
                          );
                      ref.invalidate(streakProvider(routine.id));
                      hapticTaskComplete();
                      // Kuh-Evolution: Milch-Bonus genau in dem Moment,
                      // in dem die Routine komplett abgehakt wird.
                      if (fullyCompleted) {
                        final spawnResult = await ref
                            .read(cowPastureProvider.notifier)
                            .awardSuccess(milk: milkPerFullRoutine);

                        final soundEnabled = ref.read(appSettingsProvider).soundEnabled;
                        maybePlaySound(soundEnabled, SoundEvent.taskComplete);

                        if (itemContext.mounted) {
                          final start = globalCenterOf(itemContext);
                          if (start != null) {
                            FlyingRewardOverlay.play(
                              itemContext,
                              startGlobalPosition: start,
                              emoji: '🥛',
                            );
                          }
                          ScaffoldMessenger.of(itemContext)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                  spawnResult == CowSpawnResult.pastureFull
                                      ? 'Weide voll! Merge deine Kühe! 🐄'
                                      : 'Routine komplett geschafft! 🌞',
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RoutineItemTile extends StatelessWidget {
  final RoutineItem item;
  final bool checked;
  final VoidCallback onToggle;

  const _RoutineItemTile({
    required this.item,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: onToggle, // ganze Karte klickbar -> Low Friction
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                checked ? Icons.check_circle : Icons.circle_outlined,
                color: checked ? AppColors.statusGreen : AppColors.border,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 16,
                    decoration: checked ? TextDecoration.lineThrough : null,
                    color: checked ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;

  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    if (streak <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentBg,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, color: AppColors.accent, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$streak Tage in Folge',
            style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
