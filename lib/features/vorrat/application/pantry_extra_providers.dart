import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/json_object_store.dart';
import '../domain/pantry_item_extra.dart';

final _pantryExtraStoreProvider = Provider((ref) => JsonObjectStore('pantry_item_extras.json'));

/// itemId -> Zusatzdaten (Menge/Zyklus), siehe pantry_item_extra.dart.
class PantryExtraNotifier extends StateNotifier<Map<String, PantryItemExtra>> {
  final JsonObjectStore _store;

  PantryExtraNotifier(this._store) : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final raw = await _store.read();
    final parsed = <String, PantryItemExtra>{};
    for (final entry in raw.entries) {
      if (entry.value is Map) {
        parsed[entry.key] =
            PantryItemExtra.fromJson(entry.key, (entry.value as Map).cast<String, dynamic>());
      }
    }
    state = parsed;
  }

  Future<void> _persist() async {
    await _store.write({for (final e in state.entries) e.key: e.value.toJson()});
  }

  PantryItemExtra? extraFor(String itemId) => state[itemId];

  Future<void> setExtra(String itemId, {String? quantity, int? cycleDays}) async {
    final next = Map<String, PantryItemExtra>.from(state);
    final hasAny = (quantity != null && quantity.trim().isNotEmpty) || cycleDays != null;
    if (!hasAny) {
      next.remove(itemId);
    } else {
      next[itemId] = PantryItemExtra(
        itemId: itemId,
        quantity: (quantity != null && quantity.trim().isNotEmpty) ? quantity.trim() : null,
        cycleDays: cycleDays,
      );
    }
    state = next;
    await _persist();
  }

  /// Räumt Zusatzdaten auf, wenn der zugehörige Artikel gelöscht wird
  /// – best-effort, kein Cascade-Delete wie bei Drift.
  Future<void> removeExtra(String itemId) async {
    if (!state.containsKey(itemId)) return;
    final next = Map<String, PantryItemExtra>.from(state)..remove(itemId);
    state = next;
    await _persist();
  }
}

final pantryExtraProvider =
    StateNotifierProvider<PantryExtraNotifier, Map<String, PantryItemExtra>>((ref) {
  return PantryExtraNotifier(ref.watch(_pantryExtraStoreProvider));
});
