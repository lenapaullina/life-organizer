import 'package:drift/drift.dart';

/// Eine wiederkehrende Haushaltsaufgabe mit Intervall-Logik
/// ("alle X Tage"), nicht an feste Wochentage gebunden.
class HouseholdTasks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  IntColumn get intervalDays => integer()();
  DateTimeColumn get lastCompletedAt => dateTime().nullable()();
  TextColumn get category => text().nullable()();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Historie erledigter Aufgaben – optional für den MVP, aber
/// die Grundlage für spätere Statistiken ("wie zuverlässig
/// wird X wirklich gemacht?").
class TaskCompletionLogs extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().references(HouseholdTasks, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
