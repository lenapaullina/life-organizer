/// Stimmungs-Tag statt Genre: bei Überreizung zählt nicht "Drama vs.
/// Komödie", sondern "wie viel Kopf brauche ich gerade dafür".
enum WatchMood { comfort, seicht, hoheAufmerksamkeit }

extension WatchMoodLabel on WatchMood {
  String get label => switch (this) {
        WatchMood.comfort => 'Comfort Show',
        WatchMood.seicht => 'Seichte Unterhaltung',
        WatchMood.hoheAufmerksamkeit => 'Hohe Aufmerksamkeit',
      };
}

class WatchlistItem {
  final String id;
  final String title;
  final String? whereToStream;
  final WatchMood? mood;
  final String? note;
  final bool watched;
  final DateTime addedAt;

  const WatchlistItem({
    required this.id,
    required this.title,
    this.whereToStream,
    this.mood,
    this.note,
    this.watched = false,
    required this.addedAt,
  });

  WatchlistItem copyWith({
    String? title,
    String? whereToStream,
    WatchMood? mood,
    String? note,
    bool? watched,
  }) {
    return WatchlistItem(
      id: id,
      title: title ?? this.title,
      whereToStream: whereToStream ?? this.whereToStream,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      watched: watched ?? this.watched,
      addedAt: addedAt,
    );
  }

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      id: json['id'] as String,
      title: json['title'] as String,
      whereToStream: json['whereToStream'] as String?,
      mood: json['mood'] == null
          ? null
          : WatchMood.values.byName(json['mood'] as String),
      note: json['note'] as String?,
      watched: json['watched'] as bool? ?? false,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'whereToStream': whereToStream,
      'mood': mood?.name,
      'note': note,
      'watched': watched,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
