import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/json_object_store.dart';
import '../domain/task_tag.dart';

final _taskTagStoreProvider = Provider((ref) => JsonObjectStore('task_tags.json'));

/// taskId -> Tag-Name. Ein einfaches Map-JSON-Objekt statt einer
/// eigenen Liste, weil es pro Aufgabe höchstens einen Tag gibt.
class TaskTagNotifier extends StateNotifier<Map<String, TaskTag>> {
  final JsonObjectStore _store;

  TaskTagNotifier(this._store) : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final raw = await _store.read();
    final parsed = <String, TaskTag>{};
    for (final entry in raw.entries) {
      final tag = taskTagFromName(entry.value as String?);
      if (tag != null) parsed[entry.key] = tag;
    }
    state = parsed;
  }

  Future<void> _persist() async {
    await _store.write({for (final e in state.entries) e.key: e.value.name});
  }

  Future<void> setTag(String taskId, TaskTag? tag) async {
    final next = Map<String, TaskTag>.from(state);
    if (tag == null) {
      next.remove(taskId);
    } else {
      next[taskId] = tag;
    }
    state = next;
    await _persist();
  }
}

final taskTagProvider = StateNotifierProvider<TaskTagNotifier, Map<String, TaskTag>>((ref) {
  return TaskTagNotifier(ref.watch(_taskTagStoreProvider));
});
