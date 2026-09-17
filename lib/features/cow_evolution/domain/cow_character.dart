import '../../../core/assets/cow_asset_registry.dart';

/// Die 6 fertig gezeichneten Kuh-Charaktere (Underground-Comic-Stil).
/// Jede Karte ist ein fertiges Artwork inkl. eigenem Namensschild –
/// hier wird NUR die ID auf Anzeigename + Karten-Pfad gemappt.
class CowCharacterType {
  final String id;
  final String displayName;
  const CowCharacterType(this.id, this.displayName);

  String get cardAssetPath => CowAssetRegistry.cardPath(id);
}

/// Reihenfolge ist bewusst fest (nicht alphabetisch): sie bestimmt den
/// Fallback über `characterTypeForCow` für ältere, vor diesem Update
/// gespawnte Kühe ohne gespeicherte `characterTypeId` (siehe cow.dart).
const cowCharacterTypes = <CowCharacterType>[
  CowCharacterType('chiller', 'Couch-Berta'),
  CowCharacterType('raver', 'Neon-Vanda'),
  CowCharacterType('street', 'Ghetto-Gabi'),
  CowCharacterType('diva', 'Prinzessin Lotte'),
  CowCharacterType('hippie', 'Sunshine-Moni'),
  CowCharacterType('boss', 'Big Boss Bruno'),
];

CowCharacterType characterTypeById(String? id) {
  if (id != null) {
    for (final c in cowCharacterTypes) {
      if (c.id == id) return c;
    }
  }
  return cowCharacterTypes.first;
}

/// Deterministischer Fallback für Kühe ohne gespeicherte
/// `characterTypeId` (z. B. vor diesem Feature gespawnt): leitet den
/// Charakter aus dem Level ab, statt bei jedem Rebuild neu zu würfeln.
CowCharacterType characterTypeForLevel(int level) =>
    cowCharacterTypes[(level - 1) % cowCharacterTypes.length];
