import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Wie IntervalProgressBar, aber ohne Bindung an Intervall-Status –
/// nimmt Fortschritt (0.0–1.0+) und Farbe direkt entgegen. Genutzt
/// für Budgets, wo "Fortschritt" kein Zeitverlauf ist.
class SimpleProgressBar extends StatelessWidget {
  final double progress;
  final Color color;

  const SimpleProgressBar({super.key, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.xs),
      child: Stack(
        children: [
          Container(height: 10, color: AppColors.surfaceMuted),
          FractionallySizedBox(
            widthFactor: clamped,
            child: Container(height: 10, color: color),
          ),
        ],
      ),
    );
  }
}
