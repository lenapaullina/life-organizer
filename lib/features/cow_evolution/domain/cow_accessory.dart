import '../../../core/assets/cow_asset_registry.dart';

/// An welcher Körperstelle ein Accessoire standardmäßig sitzt – daraus
/// leitet [DecoratedCowWidget] eine vernünftige Standard-Position ab,
/// falls das Item keine eigene [AccessoryPlacement] mitbringt.
enum AccessorySlot { head, neck, mouth, hand }

/// Relative Position/Größe eines Accessoires auf der Basis-Kuh, als
/// Bruchteil (0.0-1.0) von deren Breite/Höhe – bewusst NICHT
/// pixelgenau hart codiert. Die Werte hier sind plausible Startwerte
/// für eine aufrecht stehende Kuh; sobald `base_cow.png` existiert,
/// lassen sie sich an EINER Stelle feinjustieren (siehe README-Hinweis
/// in `decorated_cow_widget.dart`).
class AccessoryPlacement {
  final double top;
  final double left;
  final double width;

  const AccessoryPlacement({required this.top, required this.left, required this.width});
}

const _defaultPlacementBySlot = <AccessorySlot, AccessoryPlacement>{
  AccessorySlot.head: AccessoryPlacement(top: -0.10, left: 0.24, width: 0.5),
  AccessorySlot.neck: AccessoryPlacement(top: 0.40, left: 0.30, width: 0.42),
  AccessorySlot.mouth: AccessoryPlacement(top: 0.46, left: 0.50, width: 0.38),
  AccessorySlot.hand: AccessoryPlacement(top: 0.55, left: 0.02, width: 0.28),
};

/// Ein im Milch-Shop kaufbares und an der Kuh ausrüstbares Accessoire.
class CowAccessoryItem {
  final String id;
  final String name;
  final int price;
  final AccessorySlot slot;
  final AccessoryPlacement? placement; // überschreibt den Slot-Standard

  const CowAccessoryItem({
    required this.id,
    required this.name,
    required this.price,
    required this.slot,
    this.placement,
  });

  String get assetPath => CowAssetRegistry.accessoryPath(id);
  AccessoryPlacement get effectivePlacement => placement ?? _defaultPlacementBySlot[slot]!;
}

const cowAccessories = <CowAccessoryItem>[
  CowAccessoryItem(id: 'sunglasses', name: 'Sonnenbrille', price: 40, slot: AccessorySlot.head),
  CowAccessoryItem(id: 'party_hat', name: 'Partyhut', price: 30, slot: AccessorySlot.head),
  CowAccessoryItem(id: 'wizard_hat', name: 'Zauberhut', price: 60, slot: AccessorySlot.head),
  CowAccessoryItem(id: 'mushroom_hat', name: 'Pilz-Hut', price: 60, slot: AccessorySlot.head),
  CowAccessoryItem(id: 'flower_crown', name: 'Blumenkranz', price: 35, slot: AccessorySlot.head),
  CowAccessoryItem(id: 'gold_chain', name: 'Goldkette', price: 90, slot: AccessorySlot.neck),
  CowAccessoryItem(id: 'joint', name: 'Joint', price: 25, slot: AccessorySlot.mouth),
  CowAccessoryItem(id: 'cigarette_pack', name: 'Zigarettenschachtel', price: 20, slot: AccessorySlot.hand),
  CowAccessoryItem(id: 'lighter', name: 'Feuerzeug', price: 15, slot: AccessorySlot.hand),
];

CowAccessoryItem? cowAccessoryById(String? id) {
  if (id == null) return null;
  for (final a in cowAccessories) {
    if (a.id == id) return a;
  }
  return null;
}

/// Ein Deko-Objekt für einen festen Weiden-Slot (siehe
/// `pasture_background_widget.dart`) – KEIN Accessoire an der Kuh.
class CowDecorationItem {
  final String id;
  final String name;
  final int price;

  const CowDecorationItem({required this.id, required this.name, required this.price});

  String get assetPath => CowAssetRegistry.decorationPath(id);
}

const cowDecorations = <CowDecorationItem>[
  CowDecorationItem(id: 'bucket', name: 'Eimer', price: 20),
  CowDecorationItem(id: 'hay_bale', name: 'Strohballen', price: 25),
  CowDecorationItem(id: 'beer_crate', name: 'Bierkasten', price: 40),
  CowDecorationItem(id: 'spraycan', name: 'Spraydose', price: 45),
  CowDecorationItem(id: 'ghettoblaster', name: 'Boombox', price: 80),
  CowDecorationItem(id: 'ufo', name: 'Mini-UFO', price: 150),
];

CowDecorationItem? cowDecorationById(String? id) {
  if (id == null) return null;
  for (final d in cowDecorations) {
    if (d.id == id) return d;
  }
  return null;
}

/// Bodentextur der Weide.
class PastureGroundItem {
  final String id;
  final String name;
  final int price;
  const PastureGroundItem({required this.id, required this.name, required this.price});
  String get assetPath => CowAssetRegistry.pasturePath(id);
}

const pastureGrounds = <PastureGroundItem>[
  PastureGroundItem(id: 'ground_wiese', name: 'Blumenwiese', price: 0), // Standard, ab Start freigeschaltet
  PastureGroundItem(id: 'ground_space', name: 'Neon-Grid (Space)', price: 200),
];

PastureGroundItem groundById(String? id) {
  for (final g in pastureGrounds) {
    if (g.id == id) return g;
  }
  return pastureGrounds.first;
}

/// Zaun-Segment am Rand der Weide.
class PastureFenceItem {
  final String id;
  final String name;
  final int price;
  const PastureFenceItem({required this.id, required this.name, required this.price});
  String get assetPath => CowAssetRegistry.pasturePath(id);
}

const pastureFences = <PastureFenceItem>[
  PastureFenceItem(id: 'fence_wood', name: 'Holzzaun', price: 0), // Standard, ab Start freigeschaltet
];

PastureFenceItem fenceById(String? id) {
  for (final f in pastureFences) {
    if (f.id == id) return f;
  }
  return pastureFences.first;
}

/// Fell-/Farbmuster ("Kuh-Farbe") – aktuell als auswählbares
/// Vorschau-Muster im Shop nutzbar. Ein echtes Einfärben der Kuh-Silhouette
/// braucht eine Maske aus `base_cow.png` (siehe Scoping-Hinweis in
/// `decorated_cow_widget.dart`) und ist bewusst noch nicht verdrahtet.
class CowPatternItem {
  final String id;
  final String name;
  final int price;
  const CowPatternItem({required this.id, required this.name, required this.price});
  String get assetPath => CowAssetRegistry.patternPath(id);
}

const cowPatterns = <CowPatternItem>[
  CowPatternItem(id: 'pattern_milka', name: 'Milka-Lila', price: 120),
  CowPatternItem(id: 'pattern_giraffe', name: 'Giraffen-Gold', price: 180),
  CowPatternItem(id: 'pattern_neon', name: 'Neon-Fleck', price: 280),
];

CowPatternItem? patternById(String? id) {
  if (id == null) return null;
  for (final p in cowPatterns) {
    if (p.id == id) return p;
  }
  return null;
}
