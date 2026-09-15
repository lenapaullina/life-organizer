import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'json_list_store.dart';

/// Gemeinsame Basis für Module, die ihre Liste aus einem
/// [JsonListStore] laden und bei jeder Änderung sofort wieder
/// wegschreiben. Erspart Watchlist und Ausleihe-Tracker (und
/// zukünftigen JSON-basierten Modulen) doppelten Lade-/Speicher-Code.
///
/// Bewusst kein Drift/Stream hier (siehe json_list_store.dart) – dafür
/// hält der Notifier den aktuellen Stand einfach im Speicher und
/// schreibt synchron zur State-Änderung auf Platte.
abstract class JsonBackedListNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  final JsonListStore store;

  JsonBackedListNotifier(this.store) : super(const AsyncValue.loading()) {
    _load();
  }

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);

  Future<void> _load() async {
    try {
      final raw = await store.readAll();
      state = AsyncValue.data(raw.map(fromJson).toList());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _persist(List<T> items) async {
    state = AsyncValue.data(items);
    await store.writeAll(items.map(toJson).toList());
  }

  Future<void> add(T item) async {
    final current = state.valueOrNull ?? const [];
    await _persist([...current, item]);
  }

  /// Ersetzt jeden Eintrag, auf den [test] zutrifft, durch das
  /// Ergebnis von [update].
  Future<void> updateWhere(bool Function(T item) test, T Function(T item) update) async {
    final current = state.valueOrNull ?? const [];
    await _persist([
      for (final item in current) test(item) ? update(item) : item,
    ]);
  }

  Future<void> removeWhere(bool Function(T item) test) async {
    final current = state.valueOrNull ?? const [];
    await _persist(current.where((item) => !test(item)).toList());
  }
}
