/// Zusatzfelder zu einem Vorratsartikel, die es (noch) nicht als
/// Drift-Spalte in `PantryItems` gibt: Menge und
/// Nachkauf-Zyklus/Intervall ("alle X Tage nachkaufen").
///
/// Bewusst NICHT als Drift-Migration umgesetzt (die App-DB hat
/// `schemaVersion = 1` ganz ohne `MigrationStrategy` – eine neue
/// Spalte bräuchte also zuerst eine echte Migration, die es in
/// dieser App noch nie gab, plus einen `build_runner`-Lauf). Stattdessen:
/// dieselbe JSON-Sidecar-Architektur wie bei den Haushalts-Tags
/// (siehe `household_tag_providers.dart`) – eine einfache
/// itemId -> Zusatzdaten-Zuordnung in einer JSON-Datei, die Name,
/// Kategorie und MHD (die schon als Drift-Spalten existieren)
/// unangetastet lässt.
class PantryItemExtra {
  final String itemId;

  /// Freitext-Menge, z. B. "2 Stück", "1L", "500g". Bewusst kein
  /// strukturiertes Zahl+Einheit-Feld, weil Vorratsmengen im Alltag
  /// sehr unterschiedlich angegeben werden.
  final String? quantity;

  /// Nachkauf-Zyklus in Tagen, z. B. "alle 14 Tage wieder besorgen".
  /// `null` = kein wiederkehrender Nachkauf hinterlegt.
  final int? cycleDays;

  const PantryItemExtra({
    required this.itemId,
    this.quantity,
    this.cycleDays,
  });

  PantryItemExtra copyWith({
    String? quantity,
    bool clearQuantity = false,
    int? cycleDays,
    bool clearCycleDays = false,
  }) {
    return PantryItemExtra(
      itemId: itemId,
      quantity: clearQuantity ? null : (quantity ?? this.quantity),
      cycleDays: clearCycleDays ? null : (cycleDays ?? this.cycleDays),
    );
  }

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'cycleDays': cycleDays,
      };

  factory PantryItemExtra.fromJson(String itemId, Map<String, dynamic> json) {
    return PantryItemExtra(
      itemId: itemId,
      quantity: json['quantity'] as String?,
      cycleDays: json['cycleDays'] as int?,
    );
  }
}
