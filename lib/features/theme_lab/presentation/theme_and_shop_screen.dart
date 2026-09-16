import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../domain/special_style.dart';

/// Milch-Shop: NUR das Freischalten der vier großen Special-Styles
/// und Funktions-Upgrades (aktuell "Auto-Merge") gegen Kuh-Milch. Die
/// freie Farb-Administration ist ausgelagert in die Einstellungen
/// (Zahnrad-Symbol, siehe settings/presentation/settings_screen.dart)
/// – dort ist sie für jede Nutzerin sofort nutzbar, ohne dass etwas
/// freigeschaltet werden muss.
class ThemeAndShopScreen extends ConsumerWidget {
  const ThemeAndShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastureAsync = ref.watch(cowPastureProvider);
    final notifier = ref.read(cowPastureProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Milch-Shop')),
      body: pastureAsync.when(
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
              Text('Upgrades', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              _UpgradeCard(
                title: 'Auto-Merge',
                description:
                    '"Sortieren & Mergen"-Knopf auf der Kuh-Weide, der auf Klick automatisch alle gleich-levligen Kühe zusammenführt.',
                icon: Icons.auto_fix_high,
                price: autoMergeUpgradePrice,
                milk: pasture.milk,
                isUnlocked: pasture.hasAutoMerge,
                onBuy: () async {
                  final ok = await notifier.purchaseUpgrade(
                    autoMergeUpgradeId,
                    autoMergeUpgradePrice,
                  );
                  if (!ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Noch nicht genug Kuh-Milch dafür.')),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Special-Styles', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
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
      ),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int price;
  final int milk;
  final bool isUnlocked;
  final VoidCallback onBuy;

  const _UpgradeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.price,
    required this.milk,
    required this.isUnlocked,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = milk >= price;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(description, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (isUnlocked)
              const Icon(Icons.check_circle, color: Colors.green)
            else
              ElevatedButton(
                onPressed: canAfford ? onBuy : null,
                child: Text('$price 🥛'),
              ),
          ],
        ),
      ),
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
