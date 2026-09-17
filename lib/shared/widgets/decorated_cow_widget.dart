import 'package:flutter/material.dart';

import '../../core/assets/cow_asset_registry.dart';
import '../../features/cow_evolution/domain/cow_accessory.dart';

/// Schichtet die Basis-Kuh-Grafik mit ausgerüsteten Accessoire-PNGs
/// übereinander (Stack-Overlay), so wie in der Anfrage beschrieben:
/// 1. Basis-Kuh (`CowAssetRegistry.baseCowPath`)
/// 2. Accessoire-Overlays an ihrer jeweiligen [AccessoryPlacement]
///
/// Bewusster Scoping-Hinweis (Transparenz wie immer): Es gibt aktuell
/// noch KEIN `assets/images/cows/base_cow.png` – Lena zeichnet die
/// "nackte" Basis-Kuh noch. Bis dahin greift die Fail-Safe-Pipeline aus
/// [SafeAssetImage] (sauberer Platzhalter statt Absturz), und die
/// Accessoire-Positionen unten sind plausible Startwerte für eine
/// aufrecht stehende Kuh – KEINE pixelgenaue Kalibrierung auf ein
/// bestimmtes Artwork (das lässt sich erst mit dem echten Bild sinnvoll
/// tunen). Alle Positionswerte liegen zentral in `cow_accessory.dart`
/// (`AccessoryPlacement`), sodass eine Nachjustierung an einer Stelle reicht.
///
/// Die 6 fertigen Charakterkarten (`cards/cow_card_*.png`) sind NICHT
/// über dieses Widget zusammengesetzt – sie sind bereits vollständige
/// Einzel-Artworks (siehe `CowProfileModal`) und brauchen keine
/// Overlay-Logik.
class DecoratedCowWidget extends StatelessWidget {
  /// Pfad der Basis-Kuh-Grafik. Standard: [CowAssetRegistry.baseCowPath].
  final String baseAssetPath;

  /// IDs der ausgerüsteten Accessoires (siehe `cowAccessories`).
  final List<String> equippedAccessoryIds;

  /// Kantenlänge des quadratischen Anzeigebereichs.
  final double size;

  const DecoratedCowWidget({
    super.key,
    this.baseAssetPath = CowAssetRegistry.baseCowPath,
    this.equippedAccessoryIds = const [],
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    final accessoryWidgets = <Widget>[];
    for (final id in equippedAccessoryIds) {
      final item = cowAccessoryById(id);
      if (item != null) accessoryWidgets.add(_buildAccessory(item));
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: SafeAssetImage(
              assetPath: baseAssetPath,
              fit: BoxFit.contain,
              placeholderIcon: Icons.grass_outlined,
            ),
          ),
          ...accessoryWidgets,
        ],
      ),
    );
  }

  Widget _buildAccessory(CowAccessoryItem item) {
    final p = item.effectivePlacement;
    return Positioned(
      top: p.top * size,
      left: p.left * size,
      width: p.width * size,
      child: SafeAssetImage(
        assetPath: item.assetPath,
        fit: BoxFit.contain,
        placeholderIcon: Icons.star_border,
      ),
    );
  }
}
