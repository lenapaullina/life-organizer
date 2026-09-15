/// Richtung des Leihvorgangs: [lent] = ich habe etwas verliehen
/// (mir fehlt es gerade bei mir), [borrowed] = ich habe mir etwas
/// geliehen (ich muss es zurückgeben).
enum LoanDirection { lent, borrowed }

extension LoanDirectionLabel on LoanDirection {
  String get label => switch (this) {
        LoanDirection.lent => 'Verliehen',
        LoanDirection.borrowed => 'Geliehen',
      };

  /// Kurzer, personalisierter Satz für die Karte, je nach Richtung.
  String questionFor(String person) => switch (this) {
        LoanDirection.lent => 'bei $person',
        LoanDirection.borrowed => 'von $person',
      };
}

class LoanItem {
  final String id;
  final String itemName;
  final String personName;
  final LoanDirection direction;
  final DateTime date;
  final String? note;
  final bool returned;

  const LoanItem({
    required this.id,
    required this.itemName,
    required this.personName,
    required this.direction,
    required this.date,
    this.note,
    this.returned = false,
  });

  LoanItem copyWith({bool? returned}) {
    return LoanItem(
      id: id,
      itemName: itemName,
      personName: personName,
      direction: direction,
      date: date,
      note: note,
      returned: returned ?? this.returned,
    );
  }

  factory LoanItem.fromJson(Map<String, dynamic> json) {
    return LoanItem(
      id: json['id'] as String,
      itemName: json['itemName'] as String,
      personName: json['personName'] as String,
      direction: LoanDirection.values.byName(json['direction'] as String),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
      returned: json['returned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'personName': personName,
      'direction': direction.name,
      'date': date.toIso8601String(),
      'note': note,
      'returned': returned,
    };
  }
}
