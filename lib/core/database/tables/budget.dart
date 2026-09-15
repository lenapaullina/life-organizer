import 'package:drift/drift.dart';

/// Beträge werden als Integer-Cents gespeichert, nicht als
/// Fließkommazahl – das vermeidet klassische Rundungsfehler
/// (0.1 + 0.2 != 0.3) bei Geldbeträgen.
class Envelopes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  IntColumn get balanceCents => integer().withDefault(const Constant(0))();
  /// Optionales Ziel-Budget pro Periode, nur für die Statusfarbe.
  /// Ohne target keine Farbe/Fortschrittsbalken – reines "wie viel
  /// ist noch da" ohne Bewertung.
  IntColumn get targetCents => integer().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Eine einzelne Buchung: positiv = Einzahlung (Gehalt verteilt),
/// negativ = Ausgabe. Dient als Log, die UI zeigt aber standardmäßig
/// nur den aktuellen Saldo, nicht die volle Historie.
class EnvelopeTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get envelopeId =>
      text().references(Envelopes, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountCents => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
