import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../utils/status_calculator.dart';

/// Zeigt den Intervall-Fortschritt als Balken statt als reine Zahl.
/// Läuft bewusst über 100% hinaus sichtbar rot weiter, damit
/// "überfällig" sofort erkennbar ist, ohne Text lesen zu müssen.
class IntervalProgressBar extends StatelessWidget {
  final IntervalStatus intervalStatus;

  const IntervalProgressBar({super.key, required this.intervalStatus});

  Color get _color {
    switch (intervalStatus.status) {
      case TaskStatus.green:
        return AppColors.statusGreen;
      case TaskStatus.yellow:
        return AppColors.statusYellow;
      case TaskStatus.red:
        return AppColors.statusRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final clampedProgress = intervalStatus.progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.xs),
      child: Stack(
        children: [
          Container(
            height: 10,
            color: AppColors.surfaceMuted,
          ),
          FractionallySizedBox(
            widthFactor: clampedProgress,
            child: Container(
              height: 10,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
