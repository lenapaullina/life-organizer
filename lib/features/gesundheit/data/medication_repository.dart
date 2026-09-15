import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class MedicationRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  MedicationRepository(this._db);

  Stream<List<Medication>> watchAll() => _db.select(_db.medications).watch();

  Future<void> createMedication({
    required String name,
    String? dosageNote,
    required int timesPerDay,
  }) {
    return _db.into(_db.medications).insert(
          MedicationsCompanion.insert(
            id: _uuid.v4(),
            name: name,
            dosageNote: Value(dosageNote),
            timesPerDay: Value(timesPerDay),
          ),
        );
  }

  /// Heutiger Einnahme-Zähler, oder null wenn heute noch nichts
  /// eingetragen wurde (=0 genommen).
  Stream<MedicationIntakeLog?> watchTodayIntake(String medicationId) {
    final today = _dateOnly(DateTime.now());
    return (_db.select(_db.medicationIntakeLogs)
          ..where((l) => l.medicationId.equals(medicationId) & l.date.equals(today)))
        .watchSingleOrNull();
  }

  /// Zählt eine Einnahme für heute hoch, angelegt bei Bedarf.
  Future<void> logIntake(String medicationId, {required int maxPerDay}) async {
    final today = _dateOnly(DateTime.now());
    final existing = await (_db.select(_db.medicationIntakeLogs)
          ..where((l) => l.medicationId.equals(medicationId) & l.date.equals(today)))
        .getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.medicationIntakeLogs).insert(
            MedicationIntakeLogsCompanion.insert(
              id: _uuid.v4(),
              medicationId: medicationId,
              date: today,
              takenCount: const Value(1),
            ),
          );
    } else if (existing.takenCount < maxPerDay) {
      await (_db.update(_db.medicationIntakeLogs)..where((l) => l.id.equals(existing.id)))
          .write(MedicationIntakeLogsCompanion(takenCount: Value(existing.takenCount + 1)));
    }
  }

  Future<void> deleteMedication(String id) {
    return (_db.delete(_db.medications)..where((m) => m.id.equals(id))).go();
  }
}
