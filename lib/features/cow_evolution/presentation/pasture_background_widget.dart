import 'package:flutter/material.dart';

import '../../../core/assets/cow_asset_registry.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/cow_accessory.dart';

/// Weiden-Hintergrund: wechselbare Bodentextur, die als echter
/// Hintergrund hinter dem gesamten Kuh-Raster liegt, ein Zaun als
/// Rahmen drumherum, sowie feste Deko-Slots (siehe Anfrage Punkt 2/3
/// – bewusst KEIN freies Canvas-Dragging, sondern ein einfaches
/// Slot-System: gekaufte Deko-Objekte werden einem der
/// [decorationSlots] zugewiesen und dort als PNG gerendert).
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
          // Der Zaun ist jetzt ein echter RAHMEN um die ganze Weide statt
          // eines separaten, lose wirkenden Streifens darunter: die
          // äußere Box zeigt das (klein gekachelte) Zaun-Bild als
          // Hintergrund, die Innen-Box mit der Bodentextur sitzt mit
          // etwas Abstand darin – der sichtbare Rand dazwischen IST der
          // Zaun. `ResizeImage` skaliert das Zaun-PNG vorab auf eine
          // kleine Kachelgröße, bevor `repeat` es mehrfach nebeneinander
          // zeichnet (dieselbe "klein und erkennbar statt riesig
          // wirkend"-Überlegung wie zuvor, nur jetzt als Fläche statt
          // als einzelner Streifen).
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              color: Colors.black12, // sichtbar, falls das Bild mal fehlschlägt
              image: DecorationImage(
                image: ResizeImage(AssetImage(fence.assetPath), width: 96),
                repeat: ImageRepeat.repeat,
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
            padding: const EdgeInsets.all(14),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius - 4),
                color: Colors.black12,
                // Die Bodentextur füllt jetzt wirklich die komplette
                // Fläche hinter dem Kuh-Raster (nicht nur eine einzelne,
                // isoliert wirkende Bild-Kachel irgendwo am Rand).
                image: DecorationImage(
                  image: AssetImage(ground.assetPath),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    debugPrint('Boden-Bild konnte nicht geladen werden: $error');
                  },
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: child,
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
