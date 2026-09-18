import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/json_backed_notifier.dart';
import '../../../core/storage/json_list_store.dart';
import '../domain/pantry_template.dart';

final _pantryTemplateStoreProvider = Provider((ref) => JsonListStore('pantry_templates.json'));

class PantryTemplateNotifier extends JsonBackedListNotifier<PantryTemplate> {
  final _uuid = const Uuid();

  PantryTemplateNotifier(super.store);

  @override
  PantryTemplate fromJson(Map<String, dynamic> json) => PantryTemplate.fromJson(json);

  @override
  Map<String, dynamic> toJson(PantryTemplate item) => item.toJson();

  /// Legt eine neue Vorlage an, sofern noch keine mit demselben Namen
  /// existiert (Groß-/Kleinschreibung wird ignoriert) – so sammeln
  /// sich beim wiederholten Speichern keine Duplikate an.
  Future<void> saveTemplate({
    required String name,
    int? daysGoodAfterOpening,
    int? cycleDays,
    String? category,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final current = state.valueOrNull ?? const [];
    final alreadyExists =
        current.any((t) => t.name.toLowerCase() == trimmed.toLowerCase());
    if (alreadyExists) return;

    await add(PantryTemplate(
      id: _uuid.v4(),
      name: trimmed,
      daysGoodAfterOpening: daysGoodAfterOpening,
      cycleDays: cycleDays,
      category: category,
    ));
  }

  Future<void> deleteTemplate(String id) => removeWhere((t) => t.id == id);
}

final pantryTemplateProvider =
    StateNotifierProvider<PantryTemplateNotifier, AsyncValue<List<PantryTemplate>>>((ref) {
  return PantryTemplateNotifier(ref.watch(_pantryTemplateStoreProvider));
});
