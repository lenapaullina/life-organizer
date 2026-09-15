import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../brain_dump/presentation/brain_dump_widget.dart';
import '../../gamification/presentation/cow_meadow.dart';
import '../../notfall/presentation/notfall_screen.dart';
import '../../suche/presentation/search_screen.dart';

/// Landing-Screen der App. Bewusst die zwei "Zusatz-Features" oben,
/// nicht irgendwo versteckt in Menüs – Brain Dump und Notfall-Button
/// sind genau dann wichtig, wenn Suchen/Navigieren am schwersten fällt.
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const CowMeadow(),
            const SizedBox(height: AppSpacing.lg),
            const BrainDumpCapture(),
            const BrainDumpList(),
          ],
        ),
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
