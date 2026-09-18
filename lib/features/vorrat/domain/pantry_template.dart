/// Eine von der Nutzerin selbst gespeicherte Vorrats-Vorlage
/// ("Vorlage speichern" beim Anlegen eines eigenen Produkts) – wird
/// danach zusätzlich zu den fest einprogrammierten Presets in der
/// Autovervollständigung beim Anlegen neuer Artikel angeboten.
class PantryTemplate {
  final String id;
  final String name;
  final int? daysGoodAfterOpening;
  final int? cycleDays;
  final String? category;

  const PantryTemplate({
    required this.id,
    required this.name,
    this.daysGoodAfterOpening,
    this.cycleDays,
    this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'daysGoodAfterOpening': daysGoodAfterOpening,
        'cycleDays': cycleDays,
        'category': category,
      };

  factory PantryTemplate.fromJson(Map<String, dynamic> json) => PantryTemplate(
        id: json['id'] as String,
        name: json['name'] as String,
        daysGoodAfterOpening: json['daysGoodAfterOpening'] as int?,
        cycleDays: json['cycleDays'] as int?,
        category: json['category'] as String?,
      );
}
