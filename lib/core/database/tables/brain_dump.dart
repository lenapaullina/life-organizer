import 'package:drift/drift.dart';

/// Spontane Gedanken/Erinnerungen, die schnell "aus dem Kopf raus"
/// sollen. Kategorie und Priorität sind optional/haben sinnvolle
/// Defaults – man kann sie beim Eintippen setzen, muss aber nicht,
/// damit "schnell loswerden" der Kern bleibt.
class BrainDumpEntries extends Table {
  TextColumn get id => text()();
  TextColumn get content => text().named('entry_text')();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  TextColumn get category => text().nullable()();
  /// 0 = niedrig, 1 = mittel, 2 = hoch
  IntColumn get priority => integer().withDefault(const Constant(1))();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
