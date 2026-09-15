import 'package:drift/drift.dart';

/// Ein Kontaktprofil. `reminderIntervalDays` ist bewusst nullable –
/// nicht jeder Kontakt braucht eine "melden"-Erinnerung, manche
/// sind einfach nur ein Adressbuch-Eintrag mit Notizen.
class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get birthday => dateTime().nullable()();
  DateTimeColumn get lastContactedAt => dateTime().nullable()();
  IntColumn get reminderIntervalDays => integer().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
