import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';

/// Ein Tag ohne Uhrzeit, als Schlüssel für RoutineCompletions –
/// verhindert, dass zwei Einträge am selben Kalendertag entstehen.
DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class RoutineRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  RoutineRepository(this._db);

  Stream<List<Routine>> watchRoutines() => _db.select(_db.routines).watch();

  /// Für die Erfolge-Wiese: vollständige Completions über ALLE
  /// Routinen hinweg, nicht nur eine einzelne.
  Stream<List<RoutineCompletion>> watchAllCompletions() {
    return _db.select(_db.routineCompletions).watch();
  }

  /// Legt eine Routine mit ihren Checklisten-Items in einer Transaktion an.
  Future<void> createRoutine({
    required String name,
    required String type,
    required List<String> itemTexts,
    bool streakEnabled = true,
  }) async {
    final routineId = _uuid.v4();
    await _db.transaction(() async {
      await _db.into(_db.routines).insert(
            RoutinesCompanion.insert(
              id: routineId,
              name: name,
              type: type,
              streakEnabled: Value(streakEnabled),
            ),
          );

      for (var i = 0; i < itemTexts.length; i++) {
        await _db.into(_db.routineItems).insert(
              RoutineItemsCompanion.insert(
                id: _uuid.v4(),
                routineId: routineId,
                label: itemTexts[i],
                sortOrder: i,
              ),
            );
      }
    });
  }

  Stream<List<RoutineItem>> watchItems(String routineId) {
    return (_db.select(_db.routineItems)
          ..where((i) => i.routineId.equals(routineId))
          ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
        .watch();
  }

  /// Der heutige Completion-Eintrag einer Routine, falls schon vorhanden.
  Stream<RoutineCompletion?> watchTodayCompletion(String routineId) {
    final today = _dateOnly(DateTime.now());
    return (_db.select(_db.routineCompletions)
          ..where((c) => c.routineId.equals(routineId) & c.date.equals(today)))
        .watchSingleOrNull();
  }

  /// Hakt ein Item für heute ab oder wieder aus (Toggle).
  /// Legt bei Bedarf den heutigen Completion-Eintrag neu an.
  Future<void> toggleItemForToday({
    required String routineId,
    required String itemId,
    required int totalItemCount,
  }) async {
    final today = _dateOnly(DateTime.now());

    final existing = await (_db.select(_db.routineCompletions)
          ..where((c) => c.routineId.equals(routineId) & c.date.equals(today)))
        .getSingleOrNull();

    final currentIds = existing == null
        ? <String>[]
        : (jsonDecode(existing.completedItemIds) as List).cast<String>();

    final updatedIds = List<String>.from(currentIds);
    if (updatedIds.contains(itemId)) {
      updatedIds.remove(itemId);
    } else {
      updatedIds.add(itemId);
    }

    final fullyCompleted = updatedIds.length >= totalItemCount && totalItemCount > 0;

    if (existing == null) {
      await _db.into(_db.routineCompletions).insert(
            RoutineCompletionsCompanion.insert(
              id: _uuid.v4(),
              routineId: routineId,
              date: today,
              completedItemIds: jsonEncode(updatedIds),
              fullyCompleted: Value(fullyCompleted),
            ),
          );
    } else {
      await (_db.update(_db.routineCompletions)
            ..where((c) => c.id.equals(existing.id)))
          .write(
        RoutineCompletionsCompanion(
          completedItemIds: Value(jsonEncode(updatedIds)),
          fullyCompleted: Value(fullyCompleted),
        ),
      );
    }
  }

  /// Anzahl aufeinanderfolgender Tage rückwärts ab heute (bzw. gestern,
  /// falls heute noch nicht abgeschlossen), an denen die Routine
  /// vollständig erledigt wurde.
  Future<int> calculateStreak(String routineId) async {
    final completions = await (_db.select(_db.routineCompletions)
          ..where((c) => c.routineId.equals(routineId) & c.fullyCompleted.equals(true))
          ..orderBy([(c) => OrderingTerm.desc(c.date)]))
        .get();

    if (completions.isEmpty) return 0;

    final completedDates = completions.map((c) => _dateOnly(c.date)).toSet();
    var cursor = _dateOnly(DateTime.now());

    // Falls heute noch nicht erledigt ist, zählt der Streak trotzdem
    // ab gestern weiter -> keine Bestrafung, solange der Tag nicht
    // vorbei ist.
    if (!completedDates.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }

    var streak = 0;
    while (completedDates.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
