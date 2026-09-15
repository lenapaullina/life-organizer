import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Tag im Stil alter Forum-Badges/"Blinkies": kleine Pille mit
/// farbigem Rand und dezentem Glow. Für Kategorien, Stimmungs-Tags
/// o.ä. – bewusst kompakter und "lauter" als der normale Material-Chip.
class MySpaceBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const MySpaceBadge({
    super.key,
    required this.label,
    this.color = AppColors.accentCyan,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.4), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
