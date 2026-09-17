import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/json_object_store.dart';
import '../../../shared/utils/voice_memo_storage.dart';
import '../domain/cow.dart';
import '../domain/cow_character.dart';

/// Feste Rastergröße der Weide (4x4) – der begrenzte Platz ist bewusst
/// so gewählt: er zwingt zum Mergen statt endlos neue Level-1-Kühe
/// anzuhäufen, und bleibt auf einem Handy-Bildschirm ohne Scrollen
/// komplett sichtbar.
const cowPastureGridSize = 16;

/// Anzahl der festen Deko-Slots auf der Weide (siehe
/// `pasture_background_widget.dart`) – bewusst ein Slot-System statt
/// freiem Canvas-Dragging, um den Aufwand schlank zu halten.
const cowDecorationSlotCount = 6;

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

/// Milch pro Level und Stunde – auch als eigenständige Konstante
/// exportiert, damit UI-Screens die aktuelle Produktionsrate anzeigen
/// können, ohne die interne Berechnung zu duplizieren.
double passiveMilkPerMinute(List<Cow> cows) {
  final levelSum = cows.fold<int>(0, (sum, c) => sum + c.level);
  return levelSum * _passiveMilkPerLevelPerHour / 60.0;
}

/// IDs der im Milch-Shop kaufbaren Upgrades (keine Special-Styles,
/// sondern Funktions-Freischaltungen).
const autoMergeUpgradeId = 'auto_merge';
const autoMergeUpgradePrice = 300;

final _random = Random();

/// Ergebnis von [CowPastureNotifier.awardSuccess] – die UI zeigt bei
/// [pastureFull] einen Hinweis ("Weide voll! Merge deine Kühe!"),
/// statt die neue Kuh stillschweigend verschwinden zu lassen.
enum CowSpawnResult { spawned, pastureFull }

class CowPastureState {
  final List<Cow> cows;
  final int milk;
  final List<String> unlockedStyleIds;
  final List<String> unlockedUpgradeIds;
  final String? activeStyleId;
  final DateTime lastCollectedAt;

  /// Generischer Freischalt-Topf für Accessoires/Deko/Muster/Weiden-
  /// Themes (siehe cow_accessory.dart) – ein Item mit Preis 0 (z. B.
  /// die Standard-Weide) gilt immer als freigeschaltet, ohne hier
  /// aufgeführt sein zu müssen (siehe `isItemUnlocked`).
  final List<String> unlockedItemIds;
  final String activeGroundId;
  final String activeFenceId;

  /// IDs der Deko-Objekte je festem Weiden-Slot (siehe
  /// `cowDecorationSlotCount`); `null` = Slot ist leer.
  final List<String?> decorationSlots;

  const CowPastureState({
    required this.cows,
    required this.milk,
    required this.unlockedStyleIds,
    required this.unlockedUpgradeIds,
    required this.activeStyleId,
    required this.lastCollectedAt,
    this.unlockedItemIds = const [],
    this.activeGroundId = 'ground_wiese',
    this.activeFenceId = 'fence_wood',
    this.decorationSlots = const [null, null, null, null, null, null],
  });

  bool get hasAutoMerge => unlockedUpgradeIds.contains(autoMergeUpgradeId);

  bool isItemUnlocked(String id, int price) => price <= 0 || unlockedItemIds.contains(id);

  factory CowPastureState.initial() => CowPastureState(
        cows: const [],
        milk: 0,
        unlockedStyleIds: const [],
        unlockedUpgradeIds: const [],
        activeStyleId: null,
        lastCollectedAt: DateTime.now(),
      );

  CowPastureState copyWith({
    List<Cow>? cows,
    int? milk,
    List<String>? unlockedStyleIds,
    List<String>? unlockedUpgradeIds,
    String? activeStyleId,
    bool clearActiveStyle = false,
    DateTime? lastCollectedAt,
    List<String>? unlockedItemIds,
    String? activeGroundId,
    String? activeFenceId,
    List<String?>? decorationSlots,
  }) {
    return CowPastureState(
      cows: cows ?? this.cows,
      milk: milk ?? this.milk,
      unlockedStyleIds: unlockedStyleIds ?? this.unlockedStyleIds,
      unlockedUpgradeIds: unlockedUpgradeIds ?? this.unlockedUpgradeIds,
      activeStyleId: clearActiveStyle ? null : (activeStyleId ?? this.activeStyleId),
      lastCollectedAt: lastCollectedAt ?? this.lastCollectedAt,
      unlockedItemIds: unlockedItemIds ?? this.unlockedItemIds,
      activeGroundId: activeGroundId ?? this.activeGroundId,
      activeFenceId: activeFenceId ?? this.activeFenceId,
      decorationSlots: decorationSlots ?? this.decorationSlots,
    );
  }

  Map<String, dynamic> toJson() => {
        'cows': cows.map((c) => c.toJson()).toList(),
        'milk': milk,
        'unlockedStyleIds': unlockedStyleIds,
        'unlockedUpgradeIds': unlockedUpgradeIds,
        'activeStyleId': activeStyleId,
        'lastCollectedAt': lastCollectedAt.toIso8601String(),
        'unlockedItemIds': unlockedItemIds,
        'activeGroundId': activeGroundId,
        'activeFenceId': activeFenceId,
        'decorationSlots': decorationSlots,
      };

  factory CowPastureState.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return CowPastureState.initial();
    try {
      final rawSlots = (json['decorationSlots'] as List?)
              ?.map((e) => e as String?)
              .toList() ??
          List<String?>.filled(cowDecorationSlotCount, null);
      // Auf feste Länge bringen, falls sich cowDecorationSlotCount mal ändert.
      final slots = List<String?>.filled(cowDecorationSlotCount, null);
      for (var i = 0; i < rawSlots.length && i < slots.length; i++) {
        slots[i] = rawSlots[i];
      }

      return CowPastureState(
        cows: (json['cows'] as List? ?? [])
            .map((c) => Cow.fromJson(c as Map<String, dynamic>))
            .toList(),
        milk: json['milk'] as int? ?? 0,
        unlockedStyleIds: (json['unlockedStyleIds'] as List? ?? []).cast<String>(),
        unlockedUpgradeIds: (json['unlockedUpgradeIds'] as List? ?? []).cast<String>(),
        activeStyleId: json['activeStyleId'] as String?,
        lastCollectedAt:
            DateTime.tryParse(json['lastCollectedAt'] as String? ?? '') ?? DateTime.now(),
        unlockedItemIds: (json['unlockedItemIds'] as List? ?? []).cast<String>(),
        activeGroundId: json['activeGroundId'] as String? ?? 'ground_wiese',
        activeFenceId: json['activeFenceId'] as String? ?? 'fence_wood',
        decorationSlots: slots,
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

  CowCharacterType _randomCharacterType() =>
      cowCharacterTypes[_random.nextInt(cowCharacterTypes.length)];

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
  /// direkt + neue Level-1-Kuh (mit zufälligem Charakter), falls noch
  /// Platz auf der Weide ist. Ist die Weide voll, gibt's trotzdem die
  /// Milch, nur keine neue Kuh (Anreiz zum Mergen, nicht Bestrafung
  /// fürs Erledigen) – die UI bekommt das über den Rückgabewert mit,
  /// um z. B. "Weide voll! Merge deine Kühe!" anzuzeigen.
  ///
  /// [originLabel] ist der Name der Aufgabe/Routine, die den Spawn
  /// ausgelöst hat – landet im Kuh-Profil als "Ursprungs-Task".
  Future<CowSpawnResult> awardSuccess({required int milk, String? originLabel}) async {
    final current = state.valueOrNull;
    if (current == null) return CowSpawnResult.pastureFull;

    var cows = current.cows;
    final freePos = _firstFreePosition(cows);
    final result = freePos == null ? CowSpawnResult.pastureFull : CowSpawnResult.spawned;
    if (freePos != null) {
      cows = [
        ...cows,
        Cow(
          id: _newId(),
          level: 1,
          position: freePos,
          characterTypeId: _randomCharacterType().id,
          createdAt: DateTime.now(),
          originLabel: originLabel,
        ),
      ];
    }

    await _persist(current.copyWith(cows: cows, milk: current.milk + milk));
    return result;
  }

  static int _idCounter = 0;
  String _newId() => 'cow_${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';

  /// Zwei gleich-levelige Kühe verschmelzen zu einer Kuh mit Level+1,
  /// an der Position der zuerst ausgewählten Kuh (die andere Position
  /// wird frei). Bringt zusätzlich einen Level-abhängigen Milch-Bonus.
  /// Die gemergte Kuh bekommt einen neu gewürfelten Charakter (die
  /// beiden Ursprungskühe hatten ggf. unterschiedliche) und verliert
  /// ihre bisherigen Accessoires (neue "Identität").
  Future<bool> mergeCows(String idA, String idB) async {
    final current = state.valueOrNull;
    if (current == null || idA == idB) return false;

    final cowA = current.cows.where((c) => c.id == idA).firstOrNull;
    final cowB = current.cows.where((c) => c.id == idB).firstOrNull;
    if (cowA == null || cowB == null || cowA.level != cowB.level) return false;

    final newLevel = cowA.level + 1;
    final bonus = newLevel * 10;
    final merged = Cow(
      id: _newId(),
      level: newLevel,
      position: cowA.position,
      characterTypeId: _randomCharacterType().id,
      createdAt: DateTime.now(),
      originLabel: 'Gemergt aus zwei Level-$newLevel-1-Kühen',
    );

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

  /// Kauft ein Funktions-Upgrade (aktuell nur "Auto-Merge", siehe
  /// [autoMergeUpgradeId]) – technisch identisch zu [purchaseStyle],
  /// aber in einer eigenen Liste, damit Styles und Upgrades im Shop
  /// getrennt dargestellt werden können.
  Future<bool> purchaseUpgrade(String upgradeId, int price) async {
    final current = state.valueOrNull;
    if (current == null) return false;
    if (current.unlockedUpgradeIds.contains(upgradeId)) return true;
    if (current.milk < price) return false;

    await _persist(current.copyWith(
      milk: current.milk - price,
      unlockedUpgradeIds: [...current.unlockedUpgradeIds, upgradeId],
    ));
    return true;
  }

  /// Generischer Freischalt-Kauf für Accessoires/Deko/Muster/Weiden-
  /// Themes (siehe cow_accessory.dart) – ein Item mit Preis 0 ist
  /// automatisch freigeschaltet und braucht diesen Aufruf nicht.
  Future<bool> purchaseItem(String id, int price) async {
    final current = state.valueOrNull;
    if (current == null) return false;
    if (current.isItemUnlocked(id, price)) return true;
    if (current.milk < price) return false;

    await _persist(current.copyWith(
      milk: current.milk - price,
      unlockedItemIds: [...current.unlockedItemIds, id],
    ));
    return true;
  }

  Future<void> setActiveGround(String groundId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await _persist(current.copyWith(activeGroundId: groundId));
  }

  Future<void> setActiveFence(String fenceId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await _persist(current.copyWith(activeFenceId: fenceId));
  }

  /// Legt ein Deko-Objekt in einen festen Weiden-Slot (siehe
  /// [cowDecorationSlotCount]) oder leert ihn (`decorationId = null`).
  Future<void> placeDecoration(int slotIndex, String? decorationId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (slotIndex < 0 || slotIndex >= current.decorationSlots.length) return;
    final slots = List<String?>.from(current.decorationSlots);
    slots[slotIndex] = decorationId;
    await _persist(current.copyWith(decorationSlots: slots));
  }

  /// Rüstet ein Accessoire an einer bestimmten Kuh aus/ab (Toggle).
  /// Mehrere Accessoires im selben Slot sind bewusst erlaubt (keine
  /// Slot-Exklusivität) – einfacher zu verstehen als eine Regel wie
  /// "nur ein Hut gleichzeitig", und optisch verzeihend, weil die
  /// Positionierung ohnehin nur eine Annäherung ist (siehe
  /// `decorated_cow_widget.dart`).
  Future<void> toggleAccessory(String cowId, String accessoryId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final cows = current.cows.map((c) {
      if (c.id != cowId) return c;
      final equipped = List<String>.from(c.equippedAccessoryIds);
      if (equipped.contains(accessoryId)) {
        equipped.remove(accessoryId);
      } else {
        equipped.add(accessoryId);
      }
      return c.copyWith(equippedAccessoryIds: equipped);
    }).toList();
    await _persist(current.copyWith(cows: cows));
  }

  /// Speichert den Pfad einer neuen Sprachmemo-Aufnahme (bzw. löscht
  /// sie mit `path = null`). Eine bereits vorhandene alte Aufnahme
  /// dieser Kuh wird von der Festplatte entfernt, damit sich nicht
  /// unbegrenzt verwaiste Audio-Dateien ansammeln.
  Future<void> setVoiceMemoPath(String cowId, String? path) async {
    final current = state.valueOrNull;
    if (current == null) return;
    Cow? target;
    final cows = current.cows.map((c) {
      if (c.id != cowId) return c;
      target = c;
      return c.copyWith(voiceMemoPath: path, clearVoiceMemoPath: path == null);
    }).toList();
    if (target == null) return;
    final oldPath = target!.voiceMemoPath;
    if (oldPath != null && oldPath != path) {
      await deleteVoiceMemo(oldPath);
    }
    await _persist(current.copyWith(cows: cows));
  }

  /// Benennt eine Kuh um (`name = null` -> zurück zum Charakter-Namen).
  Future<void> renameCow(String cowId, String? name) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final trimmed = name?.trim();
    final cows = current.cows.map((c) {
      if (c.id != cowId) return c;
      return c.copyWith(
        customName: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
        clearCustomName: trimmed == null || trimmed.isEmpty,
      );
    }).toList();
    await _persist(current.copyWith(cows: cows));
  }

  /// "Sortieren & Mergen": merged automatisch so lange gleich-levelige
  /// Kuh-Paare, bis keine mehr übrig sind. Läuft in einem Rutsch
  /// (eine einzige Persistierung am Ende), damit die Weide nicht
  /// zwischendurch sichtbar flackert. Gibt zurück, wie viele Merges
  /// stattgefunden haben (für eine kurze Erfolgsmeldung in der UI).
  Future<int> autoMergeAll() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasAutoMerge) return 0;

    var cows = List<Cow>.from(current.cows);
    var milk = current.milk;
    var mergeCount = 0;

    var mergedSomething = true;
    while (mergedSomething) {
      mergedSomething = false;
      // Nach Level gruppieren und pro Level Paare mergen.
      final byLevel = <int, List<Cow>>{};
      for (final cow in cows) {
        byLevel.putIfAbsent(cow.level, () => []).add(cow);
      }
      for (final levelCows in byLevel.values) {
        if (levelCows.length < 2) continue;
        final a = levelCows[0];
        final b = levelCows[1];
        final newLevel = a.level + 1;
        final merged = Cow(
          id: _newId(),
          level: newLevel,
          position: a.position,
          characterTypeId: _randomCharacterType().id,
          createdAt: DateTime.now(),
          originLabel: 'Auto-Merge (Level $newLevel)',
        );
        cows = [
          for (final c in cows)
            if (c.id != a.id && c.id != b.id) c,
          merged,
        ];
        milk += newLevel * 10;
        mergeCount += 1;
        mergedSomething = true;
        break; // Neu gruppieren, da sich die Liste geändert hat.
      }
    }

    if (mergeCount > 0) {
      await _persist(current.copyWith(cows: cows, milk: milk));
    }
    return mergeCount;
  }
}

final cowPastureProvider =
    StateNotifierProvider<CowPastureNotifier, AsyncValue<CowPastureState>>((ref) {
  return CowPastureNotifier(ref.watch(_cowPastureStoreProvider));
});

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
