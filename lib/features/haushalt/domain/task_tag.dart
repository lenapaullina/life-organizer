/// Optionale Prioritäts-/Stimmungs-Badges für Haushaltsaufgaben, im
/// 2000er-Forum-Badge-Look (siehe MySpaceBadge). Bewusst NICHT als
/// neue Drift-Spalte umgesetzt (bräuchte build_runner), sondern als
/// einfache taskId->Tag-Zuordnung in einer JSON-Datei – dieselbe
/// Architektur-Entscheidung wie bei allen anderen neuen Feldern in
/// dieser App-Runde.
enum TaskTag { urgent, chill }

extension TaskTagX on TaskTag {
  String get emoji => switch (this) {
        TaskTag.urgent => '🔥',
        TaskTag.chill => '☕',
      };

  String get label => switch (this) {
        TaskTag.urgent => 'Dringend',
        TaskTag.chill => 'Entspannt',
      };
}

TaskTag? taskTagFromName(String? name) {
  if (name == null) return null;
  for (final tag in TaskTag.values) {
    if (tag.name == name) return tag;
  }
  return null;
}
