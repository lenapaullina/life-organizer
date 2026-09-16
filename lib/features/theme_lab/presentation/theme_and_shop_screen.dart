import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../application/theme_settings_providers.dart';
import '../domain/custom_color_settings.dart';
import '../domain/special_style.dart';
import 'hsv_color_picker.dart';

/// Zwei Tabs: freie Farb-Administration (für alle) + Milch-Shop
/// (Special Styles, mit Kuh-Milch freischaltbar).
class ThemeAndShopScreen extends StatelessWidget {
  const ThemeAndShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Farben & Shop'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Farben', icon: Icon(Icons.palette_outlined)),
              Tab(text: 'Milch-Shop', icon: Icon(Icons.storefront_outlined)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_ColorAdminTab(), _MilkShopTab()],
        ),
      ),
    );
  }
}

class _ColorAdminTab extends ConsumerWidget {
  const _ColorAdminTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(themeSettingsProvider);
    final notifier = ref.read(themeSettingsProvider.notifier);
    final pasture = ref.watch(cowPastureProvider).valueOrNull;
    final activeStyleOverride = pasture?.activeStyleId != null;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        if (activeStyleOverride)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withOpacity(0.25),
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Gerade ist ein Special-Style aus dem Shop aktiv – er überschreibt diese Farben, bis du ihn im Shop-Tab wieder deaktivierst.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
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
          label: 'Zweiter Akzent (Links, Icons, Ränder-Highlights)',
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
          'oben. Aus technischen Gründen wirkt der Verlauf aktuell nur in der Vorschau, '
          'nicht app-weit auf jeder Kopfzeile/jedem Button (die sind einfarbig aufgebaut).',
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
                    ElevatedButton(onPressed: () {}, child: const Text('Knopf')),
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

class _MilkShopTab extends ConsumerWidget {
  const _MilkShopTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastureAsync = ref.watch(cowPastureProvider);
    final notifier = ref.read(cowPastureProvider.notifier);

    return pastureAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Fehler: $err')),
      data: (pasture) {
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Row(
                children: [
                  const Text('🥛', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${pasture.milk} Kuh-Milch',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (pasture.activeStyleId != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: OutlinedButton.icon(
                  onPressed: () => notifier.setActiveStyle(null),
                  icon: const Icon(Icons.undo),
                  label: const Text('Zurück zur freien Farbwahl'),
                ),
              ),
            for (final style in specialStyles)
              _StyleCard(
                style: style,
                milk: pasture.milk,
                isUnlocked: pasture.unlockedStyleIds.contains(style.id),
                isActive: pasture.activeStyleId == style.id,
                onBuy: () async {
                  final ok = await notifier.purchaseStyle(style.id, style.price);
                  if (!ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Noch nicht genug Kuh-Milch dafür.')),
                    );
                  }
                },
                onActivate: () => notifier.setActiveStyle(style.id),
                onDeactivate: () => notifier.setActiveStyle(null),
              ),
          ],
        );
      },
    );
  }
}

class _StyleCard extends StatelessWidget {
  final SpecialStyleItem style;
  final int milk;
  final bool isUnlocked;
  final bool isActive;
  final VoidCallback onBuy;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;

  const _StyleCard({
    required this.style,
    required this.milk,
    required this.isUnlocked,
    required this.isActive,
    required this.onBuy,
    required this.onActivate,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = milk >= style.price;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [style.accentColor, style.secondaryColor]),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(style.name, style: Theme.of(context).textTheme.titleMedium),
                ),
                if (isActive)
                  const Icon(Icons.check_circle, color: Colors.green)
                else if (!isUnlocked)
                  const Icon(Icons.lock_outline, size: 18),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(style.description, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: isUnlocked
                  ? (isActive
                      ? OutlinedButton(onPressed: onDeactivate, child: const Text('Deaktivieren'))
                      : ElevatedButton(onPressed: onActivate, child: const Text('Aktivieren')))
                  : ElevatedButton(
                      onPressed: canAfford ? onBuy : null,
                      child: Text('${style.price} 🥛 freischalten'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
