import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';

class PantryRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  PantryRepository(this._db);

  Stream<List<PantryItem>> watchAll() => _db.select(_db.pantryItems).watch();

  Future<void> createItem({
    required String name,
    required DateTime expiryDate,
    String? icon,
    String? category,
    int? daysGoodAfterOpening,
    DateTime? openedAt,
  }) {
    return _db.into(_db.pantryItems).insert(
          PantryItemsCompanion.insert(
            id: _uuid.v4(),
            name: name,
            expiryDate: expiryDate,
            icon: Value(icon),
            category: Value(category),
            daysGoodAfterOpening: Value(daysGoodAfterOpening),
            openedAt: Value(openedAt),
          ),
        );
  }

  /// Ein-Klick-Aktion: Produkt wird jetzt als geöffnet markiert.
  Future<void> markOpened(String id) {
    return (_db.update(_db.pantryItems)..where((i) => i.id.equals(id)))
        .write(PantryItemsCompanion(openedAt: Value(DateTime.now())));
  }

  Future<void> deleteItem(String id) {
    return (_db.delete(_db.pantryItems)..where((i) => i.id.equals(id))).go();
  }
}
