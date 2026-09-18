/// Frei von der Nutzerin angelegter Tag für Haushaltsaufgaben, z. B.
/// "🧹 Putzen", "🛒 Einkauf", "⏱️ Schnell". Ersetzt den alten, fest
/// verdrahteten `TaskTag`-Enum (nur `urgent`/`chill`) durch ein
/// echtes, beliebig erweiterbares Tag-System.
///
/// Bewusst NICHT als Drift-Spalte umgesetzt (bräuchte build_runner
/// + eine Migration, siehe pantry_item_extra.dart) – stattdessen
/// dieselbe JSON-Sidecar-Architektur wie beim Rest dieser App-Runde:
/// eine Liste selbst angelegter Tags (household_tags.json) plus eine
/// taskId -> Set<tagId>-Zuordnung (household_task_tag_assignments.json,
/// siehe household_tag_assignment_providers.dart).
class HouseholdTag {
  final String id;
  final String name;
  final String emoji;

  const HouseholdTag({
    required this.id,
    required this.name,
    required this.emoji,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
      };

  factory HouseholdTag.fromJson(Map<String, dynamic> json) => HouseholdTag(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: json['emoji'] as String? ?? '🏷️',
      );
}
