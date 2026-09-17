import 'cow_character.dart';

/// Eine einzelne Kuh auf der Weide. `position` ist der Index im
/// festen Raster (siehe cow_pasture_providers.dart) – so lässt sich
/// ohne Drag-Geste einfach per Tippen/Auswählen mergen, und der
/// begrenzte Platz (feste Rastergröße) ist die eigentliche
/// Spielspannung: mergen schafft wieder Platz.
class Cow {
  final String id;
  final int level;
  final int position;

  /// Welcher der 6 fertigen Charaktere (siehe cow_character.dart) beim
  /// Öffnen des Profils als große Karte gezeigt wird. Wird beim Spawn
  /// zufällig gewürfelt und danach beibehalten (bleibt beim Mergen auf
  /// der neuen Kuh NICHT automatisch erhalten, da zwei verschiedene
  /// Ursprungskühe verschmelzen – die gemergte Kuh bekommt einen neuen
  /// zufälligen Charakter). `null` bei älteren, vor diesem Feature
  /// gespawnten Kühen -> Fallback über [characterTypeForLevel].
  final String? characterTypeId;

  /// Vom Nutzer editierbarer Anzeigename (Profil-Modal). `null` = noch
  /// nicht umbenannt, es wird der Charakter-Name als Standard gezeigt.
  final String? customName;

  /// Zeitpunkt, zu dem diese Kuh entstanden ist (Spawn oder Merge).
  final DateTime createdAt;

  /// Name der Aufgabe/Routine, die diese Kuh entstehen ließ (bzw. bei
  /// gemergten Kühen ein kurzer "Merge von Level X"-Hinweis) – fürs
  /// Profil-Modal ("Ursprungs-Task"). `null`, falls unbekannt.
  final String? originLabel;

  /// IDs der ausgerüsteten Accessoires (siehe cow_accessory.dart),
  /// z. B. `['sunglasses', 'gold_chain']`.
  final List<String> equippedAccessoryIds;

  /// Pfad zur aufgenommenen Sprachmemo-Datei (siehe
  /// `voice_memo_storage.dart`), `null` = noch keine Aufnahme
  /// vorhanden. Eine neue Aufnahme ersetzt die alte Datei komplett
  /// (siehe `CowPastureNotifier.setVoiceMemoPath`).
  final String? voiceMemoPath;

  const Cow({
    required this.id,
    required this.level,
    required this.position,
    this.characterTypeId,
    this.customName,
    required this.createdAt,
    this.originLabel,
    this.equippedAccessoryIds = const [],
    this.voiceMemoPath,
  });

  CowCharacterType get characterType =>
      characterTypeId != null ? characterTypeById(characterTypeId) : characterTypeForLevel(level);

  String get displayName => customName ?? characterType.displayName;

  Cow copyWith({
    int? level,
    int? position,
    String? characterTypeId,
    String? customName,
    bool clearCustomName = false,
    List<String>? equippedAccessoryIds,
    String? voiceMemoPath,
    bool clearVoiceMemoPath = false,
  }) {
    return Cow(
      id: id,
      level: level ?? this.level,
      position: position ?? this.position,
      characterTypeId: characterTypeId ?? this.characterTypeId,
      customName: clearCustomName ? null : (customName ?? this.customName),
      createdAt: createdAt,
      originLabel: originLabel,
      equippedAccessoryIds: equippedAccessoryIds ?? this.equippedAccessoryIds,
      voiceMemoPath: clearVoiceMemoPath ? null : (voiceMemoPath ?? this.voiceMemoPath),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'position': position,
        'characterTypeId': characterTypeId,
        'customName': customName,
        'createdAt': createdAt.toIso8601String(),
        'originLabel': originLabel,
        'equippedAccessoryIds': equippedAccessoryIds,
        'voiceMemoPath': voiceMemoPath,
      };

  factory Cow.fromJson(Map<String, dynamic> json) => Cow(
        id: json['id'] as String,
        level: json['level'] as int,
        position: json['position'] as int,
        characterTypeId: json['characterTypeId'] as String?,
        customName: json['customName'] as String?,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        originLabel: json['originLabel'] as String?,
        equippedAccessoryIds: (json['equippedAccessoryIds'] as List? ?? []).cast<String>(),
        voiceMemoPath: json['voiceMemoPath'] as String?,
      );
}

/// Kuh-Emoji je nach Level – ab Level 5 wird's golden/episch, damit
/// hohe Level auch visuell erkennbar besonders bleiben. Wird weiterhin
/// als kompakte Darstellung auf der Weiden-Kachel benutzt (die volle
/// Charakterkarte ist zu groß für ein 4x4-Raster) – siehe README für
/// die Scoping-Begründung.
String emojiForCowLevel(int level) {
  if (level >= 7) return '🌈🐄';
  if (level >= 5) return '✨🐄';
  if (level >= 3) return '💜🐄';
  return '🐄';
}
