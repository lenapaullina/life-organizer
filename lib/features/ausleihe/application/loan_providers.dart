import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/json_backed_notifier.dart';
import '../../../core/storage/json_list_store.dart';
import '../loan_item.dart';

final loanStoreProvider = Provider<JsonListStore>((ref) {
  return JsonListStore('loans.json');
});

class LoanNotifier extends JsonBackedListNotifier<LoanItem> {
  final _uuid = const Uuid();

  LoanNotifier(super.store);

  @override
  LoanItem fromJson(Map<String, dynamic> json) => LoanItem.fromJson(json);

  @override
  Map<String, dynamic> toJson(LoanItem item) => item.toJson();

  Future<void> addLoan({
    required String itemName,
    required String personName,
    required LoanDirection direction,
    String? note,
  }) {
    return add(
      LoanItem(
        id: _uuid.v4(),
        itemName: itemName.trim(),
        personName: personName.trim(),
        direction: direction,
        date: DateTime.now(),
        note: (note == null || note.trim().isEmpty) ? null : note.trim(),
      ),
    );
  }

  Future<void> toggleReturned(String id) {
    return updateWhere((i) => i.id == id, (i) => i.copyWith(returned: !i.returned));
  }

  Future<void> deleteLoan(String id) => removeWhere((i) => i.id == id);
}

final loanProvider = StateNotifierProvider<LoanNotifier, AsyncValue<List<LoanItem>>>((ref) {
  return LoanNotifier(ref.watch(loanStoreProvider));
});

/// null = alle, sonst nur eine Richtung – hilft, schnell "was habe
/// ich verliehen?" von "was schulde ich noch zurück?" zu trennen.
final loanDirectionFilterProvider = StateProvider<LoanDirection?>((ref) => null);

/// Offene (nicht zurückgegebene) zuerst, neueste zuerst; erledigte
/// ans Ende. Plus optionaler Richtungs-Filter.
final filteredLoansProvider = Provider<AsyncValue<List<LoanItem>>>((ref) {
  final itemsAsync = ref.watch(loanProvider);
  final filter = ref.watch(loanDirectionFilterProvider);

  return itemsAsync.whenData((items) {
    final sorted = [...items]
      ..sort((a, b) {
        if (a.returned != b.returned) return a.returned ? 1 : -1;
        return b.date.compareTo(a.date);
      });
    if (filter == null) return sorted;
    return sorted.where((i) => i.direction == filter).toList();
  });
});
