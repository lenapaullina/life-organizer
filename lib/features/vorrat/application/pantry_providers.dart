import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart' show appDatabaseProvider;
import '../data/pantry_repository.dart';
import 'pantry_item_with_status.dart';

final pantryRepositoryProvider = Provider<PantryRepository>((ref) {
  return PantryRepository(ref.watch(appDatabaseProvider));
});

final _pantryItemsStreamProvider = StreamProvider<List<PantryItem>>((ref) {
  return ref.watch(pantryRepositoryProvider).watchAll();
});

/// Sortiert nach verbleibenden Tagen aufsteigend – das kritischste
/// Produkt (am wenigsten Zeit übrig) steht ganz oben.
final sortedPantryItemsProvider = Provider<AsyncValue<List<PantryItemWithStatus>>>((ref) {
  final itemsAsync = ref.watch(_pantryItemsStreamProvider);

  return itemsAsync.whenData((items) {
    final withStatus = items.map((i) => PantryItemWithStatus.from(i)).toList();
    withStatus.sort(
      (a, b) => a.status.daysRemaining.compareTo(b.status.daysRemaining),
    );
    return withStatus;
  });
});
