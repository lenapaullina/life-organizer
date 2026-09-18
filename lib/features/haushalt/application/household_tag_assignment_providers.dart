import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/json_object_store.dart';
import '../domain/household_tag.dart';
import 'household_tag_providers.dart';

final _taskTagAssignmentStoreProvider =
    Provider((ref) => JsonObjectStore('household_task_tag_assignments.json'));

/// taskId -> Set<tagId>. Anders als der alte `TaskTagNotifier`
/// (höchstens 1 Tag pro Aufgabe) erlaubt das neue System beliebig
/// viele Tags pro Aufgabe.
class TaskTagAssignmentNotifier extends StateNotifier<Map<String, Set<String>>> {
  final JsonObjectStore _store;

  TaskTagAssignmentNotifier(this._store) : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final raw = await _store.read();
    final parsed = <String, Set<String>>{};
    for (final entry in raw.entries) {
      if (entry.value is List) {
        parsed[entry.key] = (entry.value as List).cast<String>().toSet();
      }
    }
    state = parsed;
  }

  Future<void> _persist() async {
    await _store.write({
      for (final e in state.entries)
        if (e.value.isNotEmpty) e.key: e.value.toList(),
    });
  }

  Set<String> tagsFor(String taskId) => state[taskId] ?? const {};

  Future<void> toggleTag(String taskId, String tagId) async {
    final next = Map<String, Set<String>>.from(state);
    final current = Set<String>.from(next[taskId] ?? const {});
    if (current.contains(tagId)) {
      current.remove(tagId);
    } else {
      current.add(tagId);
    }
    if (current.isEmpty) {
      next.remove(taskId);
    } else {
      next[taskId] = current;
    }
    state = next;
    await _persist();
  }

  /// Entfernt eine gelöschte Aufgabe komplett aus der Zuordnung.
  Future<void> clearTask(String taskId) async {
    if (!state.containsKey(taskId)) return;
    final next = Map<String, Set<String>>.from(state)..remove(taskId);
    state = next;
    await _persist();
  }
}

final taskTagAssignmentProvider =
    StateNotifierProvider<TaskTagAssignmentNotifier, Map<String, Set<String>>>((ref) {
  return TaskTagAssignmentNotifier(ref.watch(_taskTagAssignmentStoreProvider));
});

/// Aktuell aktive Filter-Tags in der Haushalts-Liste (leer = kein
/// Filter, alle Aufgaben werden gezeigt).
final activeTagFilterProvider = StateProvider<Set<String>>((ref) => const {});

/// Bequemer Lookup: tagId -> HouseholdTag, für die Anzeige der
/// zugewiesenen Tags an einer Aufgabe.
final householdTagByIdProvider = Provider<Map<String, HouseholdTag>>((ref) {
  final tags = ref.watch(householdTagProvider).valueOrNull ?? const [];
  return {for (final t in tags) t.id: t};
});
