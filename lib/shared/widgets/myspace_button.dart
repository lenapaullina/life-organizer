import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Prägnanter Retro-Button mit dickem Kontrast-Rand und Neon-Glow
/// statt eines weichen Material-Schattens. Nutzt bewusst dieselben
/// Farb-Token wie der Rest der App (AppColors), damit sich Button und
/// z.B. MySpaceCard/MySpaceBadge immer zueinander passend anfühlen.
class MySpaceButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color glowColor;

  const MySpaceButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.accent,
    this.glowColor = AppColors.accentCyan,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        boxShadow: [
          BoxShadow(color: glowColor.withOpacity(0.5), blurRadius: 12),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          side: BorderSide(color: glowColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
