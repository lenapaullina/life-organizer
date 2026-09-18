import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/json_backed_notifier.dart';
import '../../../core/storage/json_list_store.dart';
import '../domain/household_task_template.dart';

final _householdTaskTemplateStoreProvider =
    Provider((ref) => JsonListStore('household_task_templates.json'));

class HouseholdTaskTemplateNotifier extends JsonBackedListNotifier<HouseholdTaskTemplate> {
  final _uuid = const Uuid();

  HouseholdTaskTemplateNotifier(super.store);

  @override
  HouseholdTaskTemplate fromJson(Map<String, dynamic> json) =>
      HouseholdTaskTemplate.fromJson(json);

  @override
  Map<String, dynamic> toJson(HouseholdTaskTemplate item) => item.toJson();

  Future<void> saveTemplate({required String name, required int intervalDays}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final current = state.valueOrNull ?? const [];
    final alreadyExists =
        current.any((t) => t.name.toLowerCase() == trimmed.toLowerCase());
    if (alreadyExists) return;

    await add(HouseholdTaskTemplate(id: _uuid.v4(), name: trimmed, intervalDays: intervalDays));
  }

  Future<void> deleteTemplate(String id) => removeWhere((t) => t.id == id);
}

final householdTaskTemplateProvider = StateNotifierProvider<HouseholdTaskTemplateNotifier,
    AsyncValue<List<HouseholdTaskTemplate>>>((ref) {
  return HouseholdTaskTemplateNotifier(ref.watch(_householdTaskTemplateStoreProvider));
});
