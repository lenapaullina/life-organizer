import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/myspace_badge.dart';
import '../../../shared/widgets/myspace_button.dart';
import '../../../shared/widgets/myspace_card.dart';

/// Zeigt beispielhaft, wie MySpaceCard/-Button/-Badge zu einem Screen
/// zusammengesetzt werden – als Vorlage für den Rest der App, nicht
/// als eigenständiges Feature. Bewusst im Profilseiten-Stil (Über
/// mich / Stimmung / Aufgaben-Übersicht) angelehnt an klassische
/// MySpace-Profile.
class StyleShowcaseScreen extends StatelessWidget {
  const StyleShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Style-Vorschau')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          MySpaceCard(
            title: 'Über mich',
            icon: Icons.person_outline,
            child: const Text(
              'Lena · lebt in Bonn · baut gerade an "Vergissmeinnicht" 🌸\n'
              'Mood: verträumt-motiviert · Listening to: Lo-Fi Beats',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MySpaceCard(
            title: 'Stimmungs-Tags',
            headerColor: AppColors.accentCyan,
            icon: Icons.mood_outlined,
            child: const Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                MySpaceBadge(label: 'Comfort Show', color: AppColors.accentCyan),
                MySpaceBadge(label: 'Seichte Unterhaltung', color: AppColors.accentPink),
                MySpaceBadge(label: 'Hohe Aufmerksamkeit', color: AppColors.statusYellow),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MySpaceCard(
            title: 'Top Aufgaben',
            icon: Icons.checklist_rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ExampleTaskRow(name: 'Küche aufräumen', status: TaskBadgeStatus.red),
                const SizedBox(height: AppSpacing.sm),
                _ExampleTaskRow(name: 'Wäsche aufhängen', status: TaskBadgeStatus.yellow),
                const SizedBox(height: AppSpacing.sm),
                _ExampleTaskRow(name: 'Bad geputzt', status: TaskBadgeStatus.green),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          MySpaceButton(
            label: 'Neue Notiz',
            icon: Icons.edit_outlined,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

enum TaskBadgeStatus { green, yellow, red }

class _ExampleTaskRow extends StatelessWidget {
  final String name;
  final TaskBadgeStatus status;

  const _ExampleTaskRow({required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      TaskBadgeStatus.green => (AppColors.statusGreen, 'Im Plan'),
      TaskBadgeStatus.yellow => (AppColors.statusYellow, 'Bald fällig'),
      TaskBadgeStatus.red => (AppColors.statusRed, 'Überfällig'),
    };

    return Row(
      children: [
        Expanded(
          child: Text(name, style: const TextStyle(color: AppColors.textPrimary)),
        ),
        MySpaceBadge(label: label, color: color),
      ],
    );
  }
}
