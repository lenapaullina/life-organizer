import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/json_backed_notifier.dart';
import '../../../core/storage/json_list_store.dart';
import '../domain/household_tag.dart';

final _householdTagStoreProvider = Provider((ref) => JsonListStore('household_tags.json'));

/// Verwaltet die Liste der von der Nutzerin selbst angelegten Tags
/// (nicht die Zuordnung zu einzelnen Aufgaben – die liegt in
/// `household_tag_assignment_providers.dart`).
class HouseholdTagNotifier extends JsonBackedListNotifier<HouseholdTag> {
  final _uuid = const Uuid();

  HouseholdTagNotifier(super.store);

  @override
  HouseholdTag fromJson(Map<String, dynamic> json) => HouseholdTag.fromJson(json);

  @override
  Map<String, dynamic> toJson(HouseholdTag item) => item.toJson();

  Future<HouseholdTag?> createTag({required String name, required String emoji}) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return null;
    final current = state.valueOrNull ?? const [];
    final existing = current.where((t) => t.name.toLowerCase() == trimmedName.toLowerCase());
    if (existing.isNotEmpty) return existing.first;

    final tag = HouseholdTag(
      id: _uuid.v4(),
      name: trimmedName,
      emoji: emoji.trim().isEmpty ? '🏷️' : emoji.trim(),
    );
    await add(tag);
    return tag;
  }

  Future<void> deleteTag(String id) => removeWhere((t) => t.id == id);
}

final householdTagProvider =
    StateNotifierProvider<HouseholdTagNotifier, AsyncValue<List<HouseholdTag>>>((ref) {
  return HouseholdTagNotifier(ref.watch(_householdTagStoreProvider));
});
