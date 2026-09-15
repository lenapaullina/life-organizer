import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart' show appDatabaseProvider;
import '../data/routine_repository.dart';

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(ref.watch(appDatabaseProvider));
});

final routinesProvider = StreamProvider<List<Routine>>((ref) {
  return ref.watch(routineRepositoryProvider).watchRoutines();
});

final routineItemsProvider =
    StreamProvider.family<List<RoutineItem>, String>((ref, routineId) {
  return ref.watch(routineRepositoryProvider).watchItems(routineId);
});

final todayCompletionProvider =
    StreamProvider.family<RoutineCompletion?, String>((ref, routineId) {
  return ref.watch(routineRepositoryProvider).watchTodayCompletion(routineId);
});

/// Streak wird nicht reaktiv gestreamt (kein Drift-Join nötig),
/// sondern per FutureProvider nachgeladen und nach jedem Toggle
/// über ref.invalidate() aus der UI neu berechnet.
final streakProvider =
    FutureProvider.family<int, String>((ref, routineId) {
  return ref.watch(routineRepositoryProvider).calculateStreak(routineId);
});
