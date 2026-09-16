import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../application/theme_settings_providers.dart';
import '../domain/custom_color_settings.dart';
import 'hsv_color_picker.dart';

/// Die freie Farb-Administration – jetzt ein eigenständiger Bereich
/// (in den Einstellungen hinter dem Zahnrad-Symbol), getrennt vom
/// Milch-Shop. Der Shop dient nur noch dem Freischalten der vier
/// großen Special-Styles + Upgrades, die Farbwahl hier ist für jede
/// Nutzerin sofort und ohne Freischaltung nutzbar.
class ColorAdminSection extends ConsumerWidget {
  /// Optionale Widgets, die VOR der Farb-Administration in derselben
  /// Liste erscheinen (z. B. der Sound-Schalter im Einstellungen-
  /// Screen) – vermeidet eine verschachtelte zweite ListView mit
  /// fester Höhe, wenn dieser Bereich in einen anderen Screen
  /// eingebettet wird.
  final List<Widget> leading;

  const ColorAdminSection({super.key, this.leading = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(themeSettingsProvider);
    final notifier = ref.read(themeSettingsProvider.notifier);
    final pasture = ref.watch(cowPastureProvider).valueOrNull;
    final activeStyleOverride = pasture?.activeStyleId != null;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        ...leading,
        if (activeStyleOverride)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withOpacity(0.25),
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
            child: const Text(
              'Gerade ist ein Special-Style aus dem Milch-Shop aktiv – er überschreibt diese Farben, bis du ihn im Shop wieder deaktivierst.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        Text('Vorschau', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _PreviewCard(settings: settings),
        const SizedBox(height: AppSpacing.lg),
        Text('Presets', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final preset in colorPresets)
              ActionChip(
                avatar: CircleAvatar(backgroundColor: preset.settings.accentColor, radius: 8),
                label: Text(preset.name),
                onPressed: () => notifier.applyPreset(preset),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Akzentfarbe', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        HsvColorPicker(
          initialColor: settings.accentColor,
          onChanged: notifier.setAccentColor,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Hintergrund', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final mode in BackgroundMode.values)
              ChoiceChip(
                label: Text(mode.label),
                selected: settings.backgroundMode == mode,
                onSelected: (_) => notifier.setBackgroundMode(mode),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _ColorField(
          label: 'Karten-/Container-Farbe',
          color: settings.cardColor,
          fallback: settings.backgroundMode.surface,
          onChanged: notifier.setCardColor,
          onReset: () => notifier.setCardColor(null),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ColorField(
          label: 'Zweiter Akzent / Rand (z. B. Magenta, Lila, Icons)',
          color: settings.secondaryColorValue == null ? null : settings.secondaryColor,
          fallback: settings.secondaryColor,
          onChanged: notifier.setSecondaryColor,
          onReset: () => notifier.setSecondaryColor(null),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ColorField(
          label: 'Textfarbe (Überschriften)',
          color: settings.textPrimaryColorValue == null ? null : settings.textPrimaryColor,
          fallback: settings.textPrimaryColor,
          onChanged: notifier.setTextPrimaryColor,
          onReset: () => notifier.setTextPrimaryColor(null),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ColorField(
          label: 'Textfarbe (Nebentext)',
          color: settings.textSecondaryColorValue == null ? null : settings.textSecondaryColor,
          fallback: settings.textSecondaryColor,
          onChanged: notifier.setTextSecondaryColor,
          onReset: () => notifier.setTextSecondaryColor(null),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ColorField(
          label: 'Rahmenfarbe (Karten-/Trennlinien-Rand)',
          color: settings.borderColorValue == null ? null : settings.borderColor,
          fallback: settings.borderColor,
          onChanged: notifier.setBorderColor,
          onReset: () => notifier.setBorderColor(null),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Verlauf (optional)', style: Theme.of(context).textTheme.titleMedium),
            if (settings.hasGradient)
              TextButton(
                onPressed: () => notifier.setGradientEndColor(null),
                child: const Text('Kein Verlauf'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Zweite Farbe für einen Verlauf ab der Akzentfarbe – sichtbar in der Vorschau '
          'oben. Wirkt aktuell nur in der Vorschau, nicht app-weit auf jeder Kopfzeile/'
          'jedem Button (die sind technisch einfarbig aufgebaut).',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (!settings.hasGradient)
          OutlinedButton.icon(
            onPressed: () => notifier.setGradientEndColor(settings.secondaryColor),
            icon: const Icon(Icons.gradient),
            label: const Text('Verlauf hinzufügen'),
          )
        else
          HsvColorPicker(
            initialColor: settings.gradientEndColor!,
            onChanged: notifier.setGradientEndColor,
          ),
      ],
    );
  }
}

/// Eine Farbzeile mit Label, HSV-Picker und optionalem
/// "Automatisch"-Reset-Button für alle nullable Farbfelder von
/// [CustomColorSettings].
class _ColorField extends StatelessWidget {
  final String label;
  final Color? color;
  final Color fallback;
  final ValueChanged<Color?> onChanged;
  final VoidCallback onReset;

  const _ColorField({
    required this.label,
    required this.color,
    required this.fallback,
    required this.onChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
            if (color != null)
              TextButton(onPressed: onReset, child: const Text('Automatisch')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        HsvColorPicker(initialColor: color ?? fallback, onChanged: onChanged),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final CustomColorSettings settings;
  const _PreviewCard({required this.settings});

  @override
  Widget build(BuildContext context) {
    final theme = buildDynamicTheme(custom: settings);
    final gradient = accentGradient(settings);

    return Theme(
      data: theme,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: gradient == null ? settings.accentColor : null,
                gradient: gradient,
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
              child: Text(
                'So sieht deine Kopfzeile aus',
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('So sehen Karten aus', style: theme.textTheme.titleMedium),
                    ),
                    // Flexible statt direkt in der Row: siehe Kommentar in
                    // theme_and_shop_screen.dart bei _UpgradeCard – ohne das
                    // gäbe die unendliche Mindestbreite aus dem Button-Theme
                    // hier einen Layout-Crash (Ursache für den leeren
                    // Einstellungen-Screen).
                    Flexible(
                      child: ElevatedButton(onPressed: () {}, child: const Text('Knopf')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
