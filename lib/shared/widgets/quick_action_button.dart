import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// Große, eindeutige Ein-Klick-Aktion. Kein Untermenü, kein
/// Bestätigungsdialog standardmäßig – Low Friction hat Vorrang
/// vor Fehlervermeidung, solange die Aktion leicht rückgängig
/// zu machen ist (z.B. "Erledigt" -> Undo-Snackbar statt Dialog).
class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
    );
  }
}
