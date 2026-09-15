import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart'
    show appDatabaseProvider, householdTaskRepositoryProvider;
import '../../routinen/application/routine_providers.dart' show routineRepositoryProvider;

final _allHouseholdCompletionsProvider = StreamProvider<List<TaskCompletionLog>>((ref) {
  return ref.watch(householdTaskRepositoryProvider).watchAllCompletions();
});

final _allRoutineCompletionsProvider = StreamProvider<List<RoutineCompletion>>((ref) {
  return ref.watch(routineRepositoryProvider).watchAllCompletions();
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
