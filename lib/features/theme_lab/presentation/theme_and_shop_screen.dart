import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assets/cow_asset_registry.dart';
import '../../../core/theme/app_spacing.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../../cow_evolution/domain/cow_accessory.dart';
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
              const SizedBox(height: AppSpacing.lg),
              Text('Kuh-Accessoires', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Ausrüsten passiert direkt im Profil einer Kuh (lange auf eine Kuh auf der '
                'Weide drücken) – hier werden Accessoires nur freigeschaltet.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final item in cowAccessories)
                _UnlockOnlyCard(
                  name: item.name,
                  assetPath: item.assetPath,
                  price: item.price,
                  milk: pasture.milk,
                  isUnlocked: pasture.isItemUnlocked(item.id, item.price),
                  onBuy: () async {
                    final ok = await notifier.purchaseItem(item.id, item.price);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Noch nicht genug Kuh-Milch dafür.')),
                      );
                    }
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
              Text('Weiden-Deko', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Platzierung passiert direkt auf der Weide (Deko-Slot unter dem Zaun antippen).',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final item in cowDecorations)
                _UnlockOnlyCard(
                  name: item.name,
                  assetPath: item.assetPath,
                  price: item.price,
                  milk: pasture.milk,
                  isUnlocked: pasture.isItemUnlocked(item.id, item.price),
                  onBuy: () async {
                    final ok = await notifier.purchaseItem(item.id, item.price);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Noch nicht genug Kuh-Milch dafür.')),
                      );
                    }
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
              Text('Weiden-Boden & Zaun', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final ground in pastureGrounds)
                _ActivatableItemCard(
                  name: ground.name,
                  assetPath: ground.assetPath,
                  price: ground.price,
                  milk: pasture.milk,
                  isUnlocked: pasture.isItemUnlocked(ground.id, ground.price),
                  isActive: pasture.activeGroundId == ground.id,
                  onBuy: () => notifier.purchaseItem(ground.id, ground.price),
                  onActivate: () => notifier.setActiveGround(ground.id),
                ),
              for (final fence in pastureFences)
                _ActivatableItemCard(
                  name: fence.name,
                  assetPath: fence.assetPath,
                  price: fence.price,
                  milk: pasture.milk,
                  isUnlocked: pasture.isItemUnlocked(fence.id, fence.price),
                  isActive: pasture.activeFenceId == fence.id,
                  onBuy: () => notifier.purchaseItem(fence.id, fence.price),
                  onActivate: () => notifier.setActiveFence(fence.id),
                ),
              const SizedBox(height: AppSpacing.lg),
              Text('Fell-Muster', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Aktuell als Sammel-/Vorschau-Muster nutzbar – ein echtes Einfärben der '
                'Kuh-Silhouette braucht die Basis-Kuh-Grafik, die noch nicht vorliegt.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final pattern in cowPatterns)
                _UnlockOnlyCard(
                  name: pattern.name,
                  assetPath: pattern.assetPath,
                  price: pattern.price,
                  milk: pasture.milk,
                  isUnlocked: pasture.isItemUnlocked(pattern.id, pattern.price),
                  onBuy: () async {
                    final ok = await notifier.purchaseItem(pattern.id, pattern.price);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Noch nicht genug Kuh-Milch dafür.')),
                      );
                    }
                  },
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
              // Flexible statt direkt in der Row: ElevatedButton fordert
              // per App-Theme (minimumSize: Size.fromHeight(56)) eine
              // unendliche Mindestbreite an, um an anderer Stelle (in
              // Column-Kontexten) volle Breite auszufüllen. In einer Row
              // OHNE Expanded/Flexible gäbe das ein "BoxConstraints forces
              // an infinite width"-Layout-Crash (führte genau hier zum
              // schwarzen Bildschirm im Milch-Shop).
              Flexible(
                child: ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  child: Text('$price 🥛'),
                ),
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

/// Einfache Kauf-Karte für Items, die nur freigeschaltet (nicht direkt
/// hier aktiviert) werden – Accessoires (Ausrüsten im Kuh-Profil) und
/// Deko (Platzieren auf der Weide) folgen diesem Muster.
class _UnlockOnlyCard extends StatelessWidget {
  final String name;
  final String assetPath;
  final int price;
  final int milk;
  final bool isUnlocked;
  final VoidCallback onBuy;

  const _UnlockOnlyCard({
    required this.name,
    required this.assetPath,
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
            SafeAssetImage(assetPath: assetPath, width: 40, height: 40),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
            const SizedBox(width: AppSpacing.sm),
            if (isUnlocked)
              const Icon(Icons.check_circle, color: Colors.green)
            else
              Flexible(
                child: ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  child: Text('$price 🥛'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Kauf- + Aktivierungs-Karte für genau EIN aktives Item pro Kategorie
/// (Weiden-Boden, Zaun) – ähnlich [_StyleCard], aber ohne
/// Special-Style-spezifische Farbvorschau.
class _ActivatableItemCard extends StatelessWidget {
  final String name;
  final String assetPath;
  final int price;
  final int milk;
  final bool isUnlocked;
  final bool isActive;
  final VoidCallback onBuy;
  final VoidCallback onActivate;

  const _ActivatableItemCard({
    required this.name,
    required this.assetPath,
    required this.price,
    required this.milk,
    required this.isUnlocked,
    required this.isActive,
    required this.onBuy,
    required this.onActivate,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SafeAssetImage(assetPath: assetPath, width: 48, height: 40, fit: BoxFit.cover),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
            const SizedBox(width: AppSpacing.sm),
            if (isActive)
              const Icon(Icons.check_circle, color: Colors.green)
            else if (isUnlocked)
              Flexible(
                child: OutlinedButton(onPressed: onActivate, child: const Text('Aktivieren')),
              )
            else
              Flexible(
                child: ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  child: Text('$price 🥛'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
