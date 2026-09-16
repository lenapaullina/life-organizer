/// Eine einzelne Kuh auf der Weide. `position` ist der Index im
/// festen Raster (siehe cow_pasture_providers.dart) – so lässt sich
/// ohne Drag-Geste einfach per Tippen/Auswählen mergen, und der
/// begrenzte Platz (feste Rastergröße) ist die eigentliche
/// Spielspannung: mergen schafft wieder Platz.
class Cow {
  final String id;
  final int level;
  final int position;

  const Cow({required this.id, required this.level, required this.position});

  Cow copyWith({int? level, int? position}) {
    return Cow(id: id, level: level ?? this.level, position: position ?? this.position);
  }

  Map<String, dynamic> toJson() => {'id': id, 'level': level, 'position': position};

  factory Cow.fromJson(Map<String, dynamic> json) => Cow(
        id: json['id'] as String,
        level: json['level'] as int,
        position: json['position'] as int,
      );
}

/// Kuh-Emoji je nach Level – ab Level 5 wird's golden/episch, damit
/// hohe Level auch visuell erkennbar besonders bleiben.
String emojiForCowLevel(int level) {
  if (level >= 7) return '🌈🐄';
  if (level >= 5) return '✨🐄';
  if (level >= 3) return '💜🐄';
  return '🐄';
}
