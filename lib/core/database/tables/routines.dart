import 'package:drift/drift.dart';

/// Typ der Routine – "custom" erlaubt später beliebig viele
/// eigene Routinen über Morgen/Abend hinaus.
class RoutineTypes {
  static const morning = 'morning';
  static const evening = 'evening';
  static const custom = 'custom';
}

class Routines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // siehe RoutineTypes
  BoolColumn get streakEnabled =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Ein einzelner Checklisten-Punkt einer Routine, z.B. "Zähne putzen".
class RoutineItems extends Table {
  TextColumn get id => text()();
  TextColumn get routineId =>
      text().references(Routines, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text().named('item_text')();
  IntColumn get sortOrder => integer()();
  TextColumn get icon => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Ein Tages-"Snapshot": welche Items wurden an diesem Tag abgehakt.
/// Ein Eintrag pro Routine pro Tag.
class RoutineCompletions extends Table {
  TextColumn get id => text()();
  TextColumn get routineId =>
      text().references(Routines, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()(); // nur der Tag, ohne Uhrzeit
  TextColumn get completedItemIds =>
      text()(); // JSON-kodierte Liste von RoutineItem-IDs
  BoolColumn get fullyCompleted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
