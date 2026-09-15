import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/brain_dump.dart';
import 'tables/budget.dart';
import 'tables/contacts.dart';
import 'tables/health.dart';
import 'tables/household_tasks.dart';
import 'tables/pantry.dart';
import 'tables/routines.dart';
import 'tables/storage_locations.dart';

part 'database.g.dart';

/// Rein lokale SQLite-Datenbank über Drift. Keine Cloud-Anbindung,
/// keine Netzwerk-Calls – die Datei liegt ausschließlich im
/// App-Sandbox-Verzeichnis des Geräts.
@DriftDatabase(
  tables: [
    HouseholdTasks,
    TaskCompletionLogs,
    Routines,
    RoutineItems,
    RoutineCompletions,
    BrainDumpEntries,
    PantryItems,
    Contacts,
    Envelopes,
    EnvelopeTransactions,
    HealthAppointments,
    Medications,
    MedicationIntakeLogs,
    StorageLocations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'life_organizer.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
