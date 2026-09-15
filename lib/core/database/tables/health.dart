import 'package:drift/drift.dart';

/// Intervall-basierte Vorsorge-/Arzttermine – strukturell identisch
/// zu HouseholdTasks (Intervall + "zuletzt erledigt"), zusätzlich
/// mit einem Notizfeld für "was muss ich fragen/sagen".
class HealthAppointments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get intervalDays => integer()();
  DateTimeColumn get lastCompletedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get institution => text().nullable()();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Ein Medikament mit fester Einnahmehäufigkeit pro Tag.
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get dosageNote => text().nullable()(); // z.B. "1 Tablette"
  IntColumn get timesPerDay => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Ein Tages-Zähler, wie viele der geplanten Einnahmen bereits
/// erfolgt sind. Ein Eintrag pro Medikament pro Tag – setzt sich
/// dadurch automatisch jeden Tag zurück, ohne Cronjob nötig zu sein.
class MedicationIntakeLogs extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()(); // nur der Tag, ohne Uhrzeit
  IntColumn get takenCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
