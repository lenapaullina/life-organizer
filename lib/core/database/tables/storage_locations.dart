import 'package:drift/drift.dart';

/// Simple Zuordnung: Gegenstand -> wo er liegt. Bewusst ohne
/// Kategorien oder Räume-Struktur – das wäre selbst wieder eine
/// Einordnungsaufgabe, die die Nutzung bremst.
class StorageLocations extends Table {
  TextColumn get id => text()();
  TextColumn get itemName => text()();
  TextColumn get location => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
