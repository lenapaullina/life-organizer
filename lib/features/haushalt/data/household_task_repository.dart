import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';
import '../../../core/notifications/notification_service.dart';

/// Kapselt sämtlichen DB-Zugriff für Modul 1. UI und Provider kennen
/// keine Drift-Details, nur diese Methoden – so bleibt die DB-Wahl
/// austauschbar und die Provider-Schicht testbar (Repository mocken).
class HouseholdTaskRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  HouseholdTaskRepository(this._db);

  /// Reaktiver Stream aller Aufgaben – Riverpod hört direkt darauf,
  /// die UI aktualisiert sich automatisch bei jeder DB-Änderung.
  Stream<List<HouseholdTask>> watchAll() {
    return _db.select(_db.householdTasks).watch();
  }

  Future<void> _rescheduleNotification(HouseholdTask task) async {
    if (!task.notificationsEnabled) {
      await NotificationService.cancel(task.id);
      return;
    }
    final base = task.lastCompletedAt ?? DateTime.now();
    await NotificationService.scheduleDueReminder(
      id: task.id,
      title: 'Fällig: ${task.name}',
      body: 'Zeit für "${task.name}" – alle ${task.intervalDays} Tage.',
      dueDate: base.add(Duration(days: task.intervalDays)),
    );
  }

  Future<void> createTask({
    required String name,
    required int intervalDays,
    String? icon,
    String? category,
    bool notificationsEnabled = true,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.householdTasks).insert(
          HouseholdTasksCompanion.insert(
            id: id,
            name: name,
            intervalDays: intervalDays,
            icon: Value(icon),
            category: Value(category),
            notificationsEnabled: Value(notificationsEnabled),
          ),
        );
    if (notificationsEnabled) {
      await NotificationService.scheduleDueReminder(
        id: id,
        title: 'Fällig: $name',
        body: 'Zeit für "$name" – alle $intervalDays Tage.',
        dueDate: DateTime.now().add(Duration(days: intervalDays)),
      );
    }
  }

  /// Der zentrale "Heute erledigt"-Aufruf: setzt lastCompletedAt auf
  /// jetzt, schreibt einen Log-Eintrag für die Historie und plant die
  /// nächste Fälligkeits-Erinnerung neu.
  Future<void> markCompleted(String taskId) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await (_db.update(_db.householdTasks)
            ..where((t) => t.id.equals(taskId)))
          .write(HouseholdTasksCompanion(lastCompletedAt: Value(now)));

      await _db.into(_db.taskCompletionLogs).insert(
            TaskCompletionLogsCompanion.insert(
              id: _uuid.v4(),
              taskId: taskId,
              completedAt: now,
            ),
          );
    });

    final task = await (_db.select(_db.householdTasks)..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (task != null) await _rescheduleNotification(task);
  }

  /// Rückgängig machen des letzten "Erledigt" – wichtig für Low-Friction:
  /// Nutzer:innen sollen ohne Bestätigungsdialog klicken können, aber
  /// Fehlklicks müssen leicht korrigierbar sein.
  Future<void> undoLastCompletion(String taskId) async {
    final lastLog = await (_db.select(_db.taskCompletionLogs)
          ..where((l) => l.taskId.equals(taskId))
          ..orderBy([(l) => OrderingTerm.desc(l.completedAt)])
          ..limit(1))
        .getSingleOrNull();

    if (lastLog == null) return;

    await _db.transaction(() async {
      await (_db.delete(_db.taskCompletionLogs)
            ..where((l) => l.id.equals(lastLog.id)))
          .go();

      final previousLog = await (_db.select(_db.taskCompletionLogs)
            ..where((l) => l.taskId.equals(taskId))
            ..orderBy([(l) => OrderingTerm.desc(l.completedAt)])
            ..limit(1))
          .getSingleOrNull();

      await (_db.update(_db.householdTasks)
            ..where((t) => t.id.equals(taskId)))
          .write(
        HouseholdTasksCompanion(
          lastCompletedAt: Value(previousLog?.completedAt),
        ),
      );
    });

    final task = await (_db.select(_db.householdTasks)..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (task != null) await _rescheduleNotification(task);
  }

  Future<void> deleteTask(String taskId) async {
    await (_db.delete(_db.householdTasks)..where((t) => t.id.equals(taskId))).go();
    await NotificationService.cancel(taskId);
  }

  Future<void> updateTask({
    required String id,
    required String name,
    required int intervalDays,
  }) async {
    await (_db.update(_db.householdTasks)..where((t) => t.id.equals(id))).write(
      HouseholdTasksCompanion(name: Value(name), intervalDays: Value(intervalDays)),
    );
    final task = await (_db.select(_db.householdTasks)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (task != null) await _rescheduleNotification(task);
  }

  /// Für die Historie-Ansicht: alle Erledigungen, neueste zuerst.
  Stream<List<TaskCompletionLog>> watchAllCompletions() {
    return (_db.select(_db.taskCompletionLogs)
          ..orderBy([(l) => OrderingTerm.desc(l.completedAt)]))
        .watch();
  }
}
