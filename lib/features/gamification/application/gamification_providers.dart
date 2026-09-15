import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart'
    show appDatabaseProvider, householdTaskRepositoryProvider;
import '../../routinen/application/routine_providers.dart'
    show routineRepositoryProvider, routinesProvider;

final _allHouseholdCompletionsProvider = StreamProvider<List<TaskCompletionLog>>((ref) {
  return ref.watch(householdTaskRepositoryProvider).watchAllCompletions();
});

final _allRoutineCompletionsProvider = StreamProvider<List<RoutineCompletion>>((ref) {
  return ref.watch(routineRepositoryProvider).watchAllCompletions();
});

/// Für die Namen im Logbook (Completions speichern nur die Task-ID).
final _allHouseholdTasksProvider = StreamProvider<List<HouseholdTask>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.householdTasks).watch();
});

/// Zählt jede "Heute erledigt"-Aktion (Haushalt) und jede vollständig
/// abgeschlossene Routine als 1 Erfolg. Bewusst kumulativ statt
/// Tages-Streak – jeder Erfolg bleibt sichtbar, nichts "verfällt".
final totalSuccessCountProvider = Provider<int>((ref) {
  final household = ref.watch(_allHouseholdCompletionsProvider).valueOrNull ?? [];
  final routines = ref.watch(_allRoutineCompletionsProvider).valueOrNull ?? [];
  final fullyCompletedRoutines = routines.where((r) => r.fullyCompleted).length;
  return household.length + fullyCompletedRoutines;
});

/// Ein einzelner Eintrag im Erfolgs-Logbook ("Dopamin-Speicher"):
/// egal ob Haushaltsaufgabe oder komplett abgehakte Routine, beides
/// zählt hier gleichwertig als Erfolg.
class LogbookEntry {
  final String title;
  final DateTime completedAt;
  final String emoji;

  const LogbookEntry({required this.title, required this.completedAt, required this.emoji});
}

/// Alle Erfolge (Haushalt + Routinen) zusammengeführt, neueste zuerst.
/// Wird nirgends eigens gespeichert – die einzelnen DB-Tabellen bleiben
/// die "Quelle der Wahrheit", das hier ist nur eine kombinierte Sicht.
/// Bewusst tolerant bei Fehlern einzelner Quellen (zeigt dann einfach
/// weniger an), statt den ganzen Screen abstürzen zu lassen.
final allLogbookEntriesProvider = Provider<AsyncValue<List<LogbookEntry>>>((ref) {
  final completionsAsync = ref.watch(_allHouseholdCompletionsProvider);
  final tasksAsync = ref.watch(_allHouseholdTasksProvider);
  final routineCompletionsAsync = ref.watch(_allRoutineCompletionsProvider);
  final routinesAsync = ref.watch(routinesProvider);

  final stillLoading = completionsAsync.isLoading ||
      tasksAsync.isLoading ||
      routineCompletionsAsync.isLoading ||
      routinesAsync.isLoading;
  if (stillLoading) {
    return const AsyncValue.loading();
  }

  final tasks = tasksAsync.valueOrNull ?? const <HouseholdTask>[];
  final taskNameById = {for (final t in tasks) t.id: t.name};
  final completions = completionsAsync.valueOrNull ?? const <TaskCompletionLog>[];

  final routines = routinesAsync.valueOrNull ?? const <Routine>[];
  final routineNameById = {for (final r in routines) r.id: r.name};
  final routineCompletions =
      (routineCompletionsAsync.valueOrNull ?? const <RoutineCompletion>[])
          .where((c) => c.fullyCompleted);

  final entries = <LogbookEntry>[
    for (final c in completions)
      LogbookEntry(
        title: taskNameById[c.taskId] ?? '(gelöschte Aufgabe)',
        completedAt: c.completedAt,
        emoji: '🧹',
      ),
    for (final c in routineCompletions)
      LogbookEntry(
        title: '${routineNameById[c.routineId] ?? '(gelöschte Routine)'} · komplett geschafft',
        completedAt: c.date,
        emoji: '🌞',
      ),
  ];

  entries.sort((a, b) => b.completedAt.compareTo(a.completedAt));
  return AsyncValue.data(entries);
});

const _monthNames = [
  'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
  'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
];

String _monthLabel(DateTime d) => '${_monthNames[d.month - 1]} ${d.year}';

class MonthlyLogbook {
  final String label;
  final List<LogbookEntry> entries;

  const MonthlyLogbook({required this.label, required this.entries});
}

/// Nach Monat gruppiert (neuester Monat zuerst), für das
/// Erfolgs-Logbook: "Das hast du diesen Monat alles gerockt!"
final monthlyLogbookProvider = Provider<AsyncValue<List<MonthlyLogbook>>>((ref) {
  final entriesAsync = ref.watch(allLogbookEntriesProvider);

  return entriesAsync.whenData((entries) {
    final groups = <String, List<LogbookEntry>>{};
    for (final entry in entries) {
      final key =
          '${entry.completedAt.year}-${entry.completedAt.month.toString().padLeft(2, '0')}';
      groups.putIfAbsent(key, () => []).add(entry);
    }

    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final key in sortedKeys)
        MonthlyLogbook(
          label: _monthLabel(groups[key]!.first.completedAt),
          entries: groups[key]!,
        ),
    ];
  });
});
