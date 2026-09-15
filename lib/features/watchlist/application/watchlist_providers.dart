import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/json_backed_notifier.dart';
import '../../../core/storage/json_list_store.dart';
import '../watchlist_item.dart';

final watchlistStoreProvider = Provider<JsonListStore>((ref) {
  return JsonListStore('watchlist.json');
});

class WatchlistNotifier extends JsonBackedListNotifier<WatchlistItem> {
  final _uuid = const Uuid();

  WatchlistNotifier(super.store);

  @override
  WatchlistItem fromJson(Map<String, dynamic> json) => WatchlistItem.fromJson(json);

  @override
  Map<String, dynamic> toJson(WatchlistItem item) => item.toJson();

  Future<void> addItem({
    required String title,
    String? whereToStream,
    WatchMood? mood,
    String? note,
  }) {
    return add(
      WatchlistItem(
        id: _uuid.v4(),
        title: title.trim(),
        whereToStream: (whereToStream == null || whereToStream.trim().isEmpty)
            ? null
            : whereToStream.trim(),
        mood: mood,
        note: (note == null || note.trim().isEmpty) ? null : note.trim(),
        addedAt: DateTime.now(),
      ),
    );
  }

  Future<void> toggleWatched(String id) {
    return updateWhere((i) => i.id == id, (i) => i.copyWith(watched: !i.watched));
  }

  Future<void> deleteItem(String id) => removeWhere((i) => i.id == id);
}

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, AsyncValue<List<WatchlistItem>>>((ref) {
  return WatchlistNotifier(ref.watch(watchlistStoreProvider));
});

/// Aktuell gewählter Stimmungs-Filter (null = alle) – so muss man bei
/// Überreizung nicht durch die ganze Liste scrollen/suchen.
final watchlistMoodFilterProvider = StateProvider<WatchMood?>((ref) => null);

/// Ungesehene zuerst (neueste zuerst), gesehene danach ans Ende
/// sortiert, plus optionaler Stimmungs-Filter.
final filteredWatchlistProvider = Provider<AsyncValue<List<WatchlistItem>>>((ref) {
  final itemsAsync = ref.watch(watchlistProvider);
  final filter = ref.watch(watchlistMoodFilterProvider);

  return itemsAsync.whenData((items) {
    final sorted = [...items]
      ..sort((a, b) {
        if (a.watched != b.watched) return a.watched ? 1 : -1;
        return b.addedAt.compareTo(a.addedAt);
      });
    if (filter == null) return sorted;
    return sorted.where((i) => i.mood == filter).toList();
  });
});
