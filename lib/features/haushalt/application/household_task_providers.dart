import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../data/household_task_repository.dart';
import 'household_task_with_status.dart';

/// Eine einzige, app-weite DB-Instanz. Kein Neuöffnen pro Screen,
/// keine parallelen Connections zur selben Datei.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final householdTaskRepositoryProvider = Provider<HouseholdTaskRepository>((ref) {
  return HouseholdTaskRepository(ref.watch(appDatabaseProvider));
});

/// Roh-Stream aus der DB.
final _householdTasksStreamProvider = StreamProvider<List<HouseholdTask>>((ref) {
  return ref.watch(householdTaskRepositoryProvider).watchAll();
});

/// Das, was der UI-Screen tatsächlich konsumiert: fertig angereichert
/// mit Status UND schon nach Dringlichkeit sortiert (rot zuerst).
/// So muss kein Widget selbst sortieren oder Status berechnen.
final sortedHouseholdTasksProvider = Provider<AsyncValue<List<HouseholdTaskWithStatus>>>((ref) {
  final tasksAsync = ref.watch(_householdTasksStreamProvider);

  return tasksAsync.whenData((tasks) {
    final withStatus = tasks.map((t) => HouseholdTaskWithStatus.from(t)).toList();

    // Absteigend nach progress: am weitesten überfällig zuerst.
    withStatus.sort(
      (a, b) => b.intervalStatus.progress.compareTo(a.intervalStatus.progress),
    );
    return withStatus;
  });
});

final _taskCompletionLogsStreamProvider = StreamProvider<List<TaskCompletionLog>>((ref) {
  return ref.watch(householdTaskRepositoryProvider).watchAllCompletions();
});

class HistoryEntry {
  final String taskName;
  final DateTime completedAt;
  const HistoryEntry({required this.taskName, required this.completedAt});
}

/// Kombiniert die Logs mit den aktuellen Task-Namen (Logs speichern
/// nur die ID). Dank Cascade-Delete existieren Logs nie ohne
/// zugehörigen Task.
final householdHistoryProvider = Provider<AsyncValue<List<HistoryEntry>>>((ref) {
  final logsAsync = ref.watch(_taskCompletionLogsStreamProvider);
  final tasks = ref.watch(_householdTasksStreamProvider).valueOrNull ?? [];
  final nameById = {for (final t in tasks) t.id: t.name};

  return logsAsync.whenData(
    (logs) => logs
        .map((l) => HistoryEntry(
              taskName: nameById[l.taskId] ?? '(gelöschte Aufgabe)',
              completedAt: l.completedAt,
            ))
        .toList(),
  );
});
