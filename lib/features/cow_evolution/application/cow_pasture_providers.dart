import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/json_object_store.dart';
import '../domain/cow.dart';

/// Feste Rastergröße der Weide (4x4) – der begrenzte Platz ist
/// bewusst so gewählt: er zwingt zum Mergen statt endlos neue
/// Level-1-Kühe anzuhäufen, und bleibt auf einem Handy-Bildschirm
/// ohne Scrollen komplett sichtbar.
const cowPastureGridSize = 16;

/// Wie viel Milch eine fertig abgeschlossene Routine bzw. eine
/// erledigte Haushaltsaufgabe direkt bringt (zusätzlich zum
/// Level-1-Kuh-Spawn, falls noch Platz ist).
const milkPerHouseholdTask = 5;
const milkPerFullRoutine = 12;

/// Passive Milch-Erzeugung: jede Kuh bringt pro Stunde `level * 2`
/// Milch, offline gedeckelt auf 8 Stunden – reine Offline-Farmerei
/// über Tage hinweg soll nicht der Hauptweg zu den teuren Styles sein.
const _passiveMilkPerLevelPerHour = 2;
const _maxOfflineHours = 8;

class CowPastureState {
  final List<Cow> cows;
  final int milk;
  final List<String> unlockedStyleIds;
  final String? activeStyleId;
  final DateTime lastCollectedAt;

  const CowPastureState({
    required this.cows,
    required this.milk,
    required this.unlockedStyleIds,
    required this.activeStyleId,
    required this.lastCollectedAt,
  });

  factory CowPastureState.initial() => CowPastureState(
        cows: const [],
        milk: 0,
        unlockedStyleIds: const [],
        activeStyleId: null,
        lastCollectedAt: DateTime.now(),
      );

  CowPastureState copyWith({
    List<Cow>? cows,
    int? milk,
    List<String>? unlockedStyleIds,
    String? activeStyleId,
    bool clearActiveStyle = false,
    DateTime? lastCollectedAt,
  }) {
    return CowPastureState(
      cows: cows ?? this.cows,
      milk: milk ?? this.milk,
      unlockedStyleIds: unlockedStyleIds ?? this.unlockedStyleIds,
      activeStyleId: clearActiveStyle ? null : (activeStyleId ?? this.activeStyleId),
      lastCollectedAt: lastCollectedAt ?? this.lastCollectedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'cows': cows.map((c) => c.toJson()).toList(),
        'milk': milk,
        'unlockedStyleIds': unlockedStyleIds,
        'activeStyleId': activeStyleId,
        'lastCollectedAt': lastCollectedAt.toIso8601String(),
      };

  factory CowPastureState.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return CowPastureState.initial();
    try {
      return CowPastureState(
        cows: (json['cows'] as List? ?? [])
            .map((c) => Cow.fromJson(c as Map<String, dynamic>))
            .toList(),
        milk: json['milk'] as int? ?? 0,
        unlockedStyleIds: (json['unlockedStyleIds'] as List? ?? []).cast<String>(),
        activeStyleId: json['activeStyleId'] as String?,
        lastCollectedAt:
            DateTime.tryParse(json['lastCollectedAt'] as String? ?? '') ?? DateTime.now(),
      );
    } catch (_) {
      return CowPastureState.initial();
    }
  }
}

final _cowPastureStoreProvider = Provider((ref) => JsonObjectStore('cow_pasture.json'));

class CowPastureNotifier extends StateNotifier<AsyncValue<CowPastureState>> {
  final JsonObjectStore _store;

  CowPastureNotifier(this._store) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = await _store.read();
      var loaded = CowPastureState.fromJson(raw);
      loaded = _collectPassiveMilk(loaded);
      state = AsyncValue.data(loaded);
      await _persist(loaded);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _persist(CowPastureState value) async {
    state = AsyncValue.data(value);
    await _store.write(value.toJson());
  }

  CowPastureState _collectPassiveMilk(CowPastureState s) {
    final elapsed = DateTime.now().difference(s.lastCollectedAt);
    final cappedHours = elapsed.inMinutes / 60.0;
    final hours = cappedHours.clamp(0, _maxOfflineHours);
    if (hours <= 0 || s.cows.isEmpty) {
      return s.copyWith(lastCollectedAt: DateTime.now());
    }
    final levelSum = s.cows.fold<int>(0, (sum, c) => sum + c.level);
    final earned = (levelSum * _passiveMilkPerLevelPerHour * hours).floor();
    return s.copyWith(milk: s.milk + earned, lastCollectedAt: DateTime.now());
  }

  /// Wird beim Öffnen der Weide aufgerufen, damit die passive Milch
  /// (seit dem letzten Besuch) tatsächlich gutgeschrieben wird.
  Future<void> collectPassiveIncome() async {
    final current = state.valueOrNull;
    if (current == null) return;
    await _persist(_collectPassiveMilk(current));
  }

  int? _firstFreePosition(List<Cow> cows) {
    final occupied = cows.map((c) => c.position).toSet();
    for (var i = 0; i < cowPastureGridSize; i++) {
      if (!occupied.contains(i)) return i;
    }
    return null;
  }

  /// Erfolg (Haushaltsaufgabe erledigt / Routine komplett) -> Milch
  /// direkt + neue Level-1-Kuh, falls noch Platz auf der Weide ist.
  /// Ist die Weide voll, gibt's trotzdem die Milch, nur keine neue Kuh
  /// (Anreiz zum Mergen, nicht Bestrafung fürs Erledigen).
  Future<void> awardSuccess({required int milk}) async {
    final current = state.valueOrNull;
    if (current == null) return;

    var cows = current.cows;
    final freePos = _firstFreePosition(cows);
    if (freePos != null) {
      cows = [
        ...cows,
        Cow(id: _newId(), level: 1, position: freePos),
      ];
    }

    await _persist(current.copyWith(cows: cows, milk: current.milk + milk));
  }

  static int _idCounter = 0;
  String _newId() => 'cow_${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';

  /// Zwei gleich-levelige Kühe verschmelzen zu einer Kuh mit Level+1,
  /// an der Position der zuerst ausgewählten Kuh (die andere Position
  /// wird frei). Bringt zusätzlich einen Level-abhängigen Milch-Bonus.
  Future<bool> mergeCows(String idA, String idB) async {
    final current = state.valueOrNull;
    if (current == null || idA == idB) return false;

    final cowA = current.cows.where((c) => c.id == idA).firstOrNull;
    final cowB = current.cows.where((c) => c.id == idB).firstOrNull;
    if (cowA == null || cowB == null || cowA.level != cowB.level) return false;

    final newLevel = cowA.level + 1;
    final bonus = newLevel * 10;
    final merged = Cow(id: _newId(), level: newLevel, position: cowA.position);

    final remaining = current.cows.where((c) => c.id != idA && c.id != idB).toList()
      ..add(merged);

    await _persist(current.copyWith(cows: remaining, milk: current.milk + bonus));
    return true;
  }

  /// Kauft einen Special-Style (siehe special_style.dart), falls genug
  /// Milch vorhanden ist und er noch nicht freigeschaltet wurde.
  Future<bool> purchaseStyle(String styleId, int price) async {
    final current = state.valueOrNull;
    if (current == null) return false;
    if (current.unlockedStyleIds.contains(styleId)) return true;
    if (current.milk < price) return false;

    await _persist(current.copyWith(
      milk: current.milk - price,
      unlockedStyleIds: [...current.unlockedStyleIds, styleId],
    ));
    return true;
  }

  /// Aktiviert einen bereits freigeschalteten Style (überschreibt die
  /// freie Farb-Administration) oder deaktiviert ihn wieder (`null`
  /// = zurück zur freien Farbwahl).
  Future<void> setActiveStyle(String? styleId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (styleId != null && !current.unlockedStyleIds.contains(styleId)) return;
    await _persist(current.copyWith(
      activeStyleId: styleId,
      clearActiveStyle: styleId == null,
    ));
  }
}

final cowPastureProvider =
    StateNotifierProvider<CowPastureNotifier, AsyncValue<CowPastureState>>((ref) {
  return CowPastureNotifier(ref.watch(_cowPastureStoreProvider));
});

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
