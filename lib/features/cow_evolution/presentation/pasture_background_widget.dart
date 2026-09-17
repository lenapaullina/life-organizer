import 'package:flutter/material.dart';

import '../../../core/assets/cow_asset_registry.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/cow_accessory.dart';

/// Weiden-Hintergrund: wechselbare Bodentextur + Zaun-Streifen +
/// feste Deko-Slots (siehe Anfrage Punkt 2/3 – bewusst KEIN freies
/// Canvas-Dragging, sondern ein einfaches Slot-System: gekaufte
/// Deko-Objekte werden einem der [decorationSlots] zugewiesen und
/// dort als PNG gerendert).
class PastureBackgroundWidget extends StatelessWidget {
  final String groundId;
  final String fenceId;
  final List<String?> decorationSlots;
  final ValueChanged<int> onSlotTap;

  /// Der eigentliche Weiden-Inhalt (z. B. das Kuh-Raster), der über
  /// dem Bodenbild liegt.
  final Widget child;

  const PastureBackgroundWidget({
    super.key,
    required this.groundId,
    required this.fenceId,
    required this.decorationSlots,
    required this.onSlotTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ground = groundById(groundId);
    final fence = fenceById(fenceId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                child: SafeAssetImage(
                  assetPath: ground.assetPath,
                  fit: BoxFit.cover,
                  placeholderIcon: Icons.grass_outlined,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: child,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Zaun-Streifen: rein dekorativ, keine eigene Interaktion.
        //
        // Bewusst NICHT BoxFit.cover auf das ganze (sehr viel breitere
        // als hohe) Zaun-Bild: cover skaliert dabei so stark hoch, dass
        // am Ende nur ein winziger, riesig wirkender Ausschnitt sichtbar
        // ist ("Zäune viel zu groß"). Stattdessen wird das Bild auf die
        // Streifenhöhe herunterskaliert (fitHeight, Seitenverhältnis
        // bleibt erhalten) und dann mehrfach nebeneinander wiederholt
        // (repeatX) – so bleiben die einzelnen Zaunpfosten klein und
        // erkennbar, wie ein echter durchlaufender Zaun.
        SizedBox(
          height: 36,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              color: Colors.black12, // sichtbar, falls das Bild mal fehlschlägt
              image: DecorationImage(
                image: AssetImage(fence.assetPath),
                fit: BoxFit.fitHeight,
                repeat: ImageRepeat.repeatX,
                // Fail-Safe: schlägt das Bild fehl, wird der Fehler nur
                // geloggt statt die App abstürzen zu lassen (DecorationImage
                // hat kein `errorBuilder` wie Image.asset, siehe
                // SafeAssetImage in cow_asset_registry.dart für die
                // Image.asset-Variante der Fail-Safe-Pipeline).
                onError: (error, stackTrace) {
                  debugPrint('Zaun-Bild konnte nicht geladen werden: $error');
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: decorationSlots.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final decoId = decorationSlots[index];
              final deco = cowDecorationById(decoId);
              return _DecoSlot(
                deco: deco,
                onTap: () => onSlotTap(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DecoSlot extends StatelessWidget {
  final CowDecorationItem? deco;
  final VoidCallback onTap;
  const _DecoSlot({required this.deco, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      child: Container(
        width: 64,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          color: Colors.black.withOpacity(0.05),
        ),
        alignment: Alignment.center,
        child: deco == null
            ? const Icon(Icons.add, color: Colors.black38)
            : SafeAssetImage(assetPath: deco!.assetPath, width: 48, height: 48),
      ),
    );
  }
}
