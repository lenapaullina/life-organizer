/// Eine von der Nutzerin selbst gespeicherte Haushaltsaufgaben-Vorlage
/// (analog zu `PantryTemplate`), zusätzlich zu den fest
/// einprogrammierten Presets in `add_household_task_sheet.dart`.
class HouseholdTaskTemplate {
  final String id;
  final String name;
  final int intervalDays;

  const HouseholdTaskTemplate({
    required this.id,
    required this.name,
    required this.intervalDays,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'intervalDays': intervalDays,
      };

  factory HouseholdTaskTemplate.fromJson(Map<String, dynamic> json) => HouseholdTaskTemplate(
        id: json['id'] as String,
        name: json['name'] as String,
        intervalDays: json['intervalDays'] as int? ?? 7,
      );
}
