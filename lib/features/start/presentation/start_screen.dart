import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../brain_dump/presentation/brain_dump_widget.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../../gamification/application/gamification_providers.dart';
import '../../gamification/presentation/cow_meadow.dart';
import '../../notfall/presentation/notfall_screen.dart';
import '../../suche/presentation/search_screen.dart';

/// Landing-Screen der App. Bewusst die zwei "Zusatz-Features" oben,
/// nicht irgendwo versteckt in Menüs – Brain Dump und Notfall-Button
/// sind genau dann wichtig, wenn Suchen/Navigieren am schwersten fällt.
class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hey du 🌸'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotfallButton(),
            const SizedBox(height: AppSpacing.lg),
            const _DailyGoalBar(),
            const SizedBox(height: AppSpacing.lg),
            const CowMeadow(),
            const _PassiveMilkRate(),
            const SizedBox(height: AppSpacing.lg),
            const BrainDumpCapture(),
            const BrainDumpList(),
          ],
        ),
      ),
    );
  }
}

/// Tagesziel-Fortschritt ("3/5 Tasks heute erledigt") – reine
/// Lese-Anzeige, keine eigene Interaktion.
class _DailyGoalBar extends ConsumerWidget {
  const _DailyGoalBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (done, goal) = ref.watch(dailyGoalProgressProvider);
    final progress = goal == 0 ? 0.0 : (done / goal).clamp(0.0, 1.0);
    final reached = done >= goal;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reached ? 'Tagesziel geschafft! 🎉' : 'Tagesziel',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation(
                reached ? AppColors.statusGreen : AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('$done/$goal Tasks heute erledigt', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

/// "Deine Kühe produzieren +X Milch/Min" – nur sichtbar, sobald es
/// überhaupt Kühe gibt, sonst wäre die 0 nur Rauschen.
class _PassiveMilkRate extends ConsumerWidget {
  const _PassiveMilkRate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cows = ref.watch(cowPastureProvider).valueOrNull?.cows ?? const [];
    final rate = passiveMilkPerMinute(cows);
    if (rate <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Text(
        '🥛 Deine Kühe produzieren +${rate.toStringAsFixed(1)} Milch / Min',
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }
}

class _NotfallButton extends StatelessWidget {
  const _NotfallButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => showNotfallScreen(context),
        icon: const Icon(Icons.spa_outlined, color: AppColors.statusRed),
        label: const Text('ALARRRM'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.statusRed,
          side: const BorderSide(color: AppColors.statusRed),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
      ),
    );
  }
}
