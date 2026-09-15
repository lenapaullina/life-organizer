import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/gamification_providers.dart';

/// Zeigt gesammelte Erfolge (Haushaltsaufgaben erledigt, Routinen
/// komplett abgehakt) als Kuh-Emojis auf einer "Wiese". Rein positive
/// Verstärkung: es gibt kein Verlieren/Zurücksetzen, nur Sammeln.
class CowMeadow extends ConsumerWidget {
  const CowMeadow({super.key});

  static const _maxVisibleCows = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(totalSuccessCountProvider);

    if (count == 0) {
      return const SizedBox.shrink();
    }

    final visibleCows = count.clamp(0, _maxVisibleCows);
    final extra = count - visibleCows;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.statusGreenBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deine Wiese 🐄',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$count ${count == 1 ? "Erfolg" : "Erfolge"} gesammelt',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (var i = 0; i < visibleCows; i++) const Text('🐄', style: TextStyle(fontSize: 22)),
              if (extra > 0)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: Text(
                    '+$extra weitere',
                    style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
