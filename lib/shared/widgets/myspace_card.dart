import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Klassisches MySpace-Profilmodul: farbiger Header-Balken mit Titel,
/// darunter der eigentliche Inhalt auf dunklem Untergrund, umrahmt
/// von einem dicken, farbigen Rand mit leichtem Neon-Schlagschatten
/// statt eines weichen Material-Schattens.
class MySpaceCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color headerColor;
  final IconData? icon;

  const MySpaceCard({
    super.key,
    required this.title,
    required this.child,
    this.headerColor = AppColors.accent,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: headerColor, width: 2),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: headerColor.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            color: headerColor,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ],
      ),
    );
  }
}
