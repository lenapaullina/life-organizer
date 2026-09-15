import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../utils/status_calculator.dart';

/// Kompakte, farbcodierte Statusanzeige. Ersetzt Text-in-Tabellen
/// durch ein sofort erfassbares visuelles Signal – das ist der
/// Kern des "kein Überforderungs-Druck"-Prinzips.
class StatusPill extends StatelessWidget {
  final TaskStatus status;
  final String label;

  const StatusPill({
    super.key,
    required this.status,
    required this.label,
  });

  _StatusColors get _colors {
    switch (status) {
      case TaskStatus.green:
        return const _StatusColors(AppColors.statusGreen, AppColors.statusGreenBg);
      case TaskStatus.yellow:
        return const _StatusColors(AppColors.statusYellow, AppColors.statusYellowBg);
      case TaskStatus.red:
        return const _StatusColors(AppColors.statusRed, AppColors.statusRedBg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colors.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              color: colors.foreground,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusColors {
  final Color foreground;
  final Color background;
  const _StatusColors(this.foreground, this.background);
}
