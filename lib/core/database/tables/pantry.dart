import 'package:drift/drift.dart';

/// Ein Vorratsartikel. `openedAt` und `daysGoodAfterOpening` sind
/// beide optional – viele Produkte (Konserven, ungeöffnet) kennen
/// dieses Konzept nicht und laufen einfach nach `expiryDate` ab.
class PantryItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get category => text().nullable()();
  DateTimeColumn get expiryDate => dateTime()(); // MHD
  DateTimeColumn get openedAt => dateTime().nullable()();
  IntColumn get daysGoodAfterOpening => integer().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
