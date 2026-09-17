import 'package:flutter/material.dart';

/// Zentrale Verwaltung aller Bild-Pfade für das Kuh-/Weiden-Grafiksystem
/// (Charakterkarten, Accessoires, Deko, Weiden-Themes, Fell-Muster).
///
/// Bewusste Architektur-Entscheidung: Ein einziger Ort für alle Pfade,
/// damit eine Item-ID (z. B. `sunglasses`, `fence_wood`) überall (Shop,
/// Profil, Weide) dieselbe Datei referenziert, ohne dass der Pfad an
/// mehreren Stellen im Code dupliziert wird. Kommt später ein neues
/// Asset dazu, reicht ein Eintrag in der jeweiligen Item-Liste (siehe
/// `cow_character.dart` / `cow_accessory.dart`) – die Pfad-Bildung hier
/// bleibt unverändert.
class CowAssetRegistry {
  CowAssetRegistry._();

  static const cardsDir = 'assets/images/cards';
  static const accessoriesDir = 'assets/images/accessories';
  static const decorationsDir = 'assets/images/decorations';
  static const pastureDir = 'assets/images/pasture';
  static const patternsDir = 'assets/images/cow_patterns';
  static const cowsDir = 'assets/images/cows';

  /// Noch NICHT vorhanden (Lena zeichnet die "nackte" Basis-Kuh erst
  /// noch) – bewusst schon verdrahtet, damit die Fail-Safe-Pipeline
  /// (siehe [SafeAssetImage]) von Anfang an getestet ist: Bis die
  /// Datei existiert, zeigt jede Stelle, die [baseCowPath] lädt,
  /// sauber einen Platzhalter statt abzustürzen.
  static const baseCowPath = '$cowsDir/base_cow.png';

  static String cardPath(String characterTypeId) => '$cardsDir/cow_card_$characterTypeId.png';
  static String accessoryPath(String id) => '$accessoriesDir/$id.png';
  static String decorationPath(String id) => '$decorationsDir/$id.png';
  static String pasturePath(String id) => '$pastureDir/$id.png';
  static String patternPath(String id) => '$patternsDir/$id.png';
}

/// Lädt ein Bild-Asset, zeigt aber bei fehlendem oder kaputtem Pfad
/// einen sauberen Platzhalter statt die App abstürzen zu lassen.
///
/// Das ist die in Punkt 3/4 der Anfrage geforderte Fail-Safe-Pipeline:
/// Egal ob ein Accessoire-PNG noch nicht existiert (z. B. `base_cow.png`
/// aktuell) oder ein Pfad sich mal vertippt – die App bleibt benutzbar
/// und zeigt statt eines harten Fehlers ein erkennbares "Bild fehlt"-Icon.
class SafeAssetImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData placeholderIcon;

  const SafeAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.placeholderIcon = Icons.image_not_supported_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        final size = width ?? height ?? 40;
        return Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(placeholderIcon, size: size * 0.5, color: Colors.black45),
        );
      },
    );
  }
}
