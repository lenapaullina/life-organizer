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
    return createItemReturningId(
      name: name,
      expiryDate: expiryDate,
      icon: icon,
      category: category,
      daysGoodAfterOpening: daysGoodAfterOpening,
      openedAt: openedAt,
    );
  }

  /// Wie [createItem], gibt aber die neu vergebene ID zurück – nötig,
  /// um direkt im Anschluss die Menge/Zyklus-Zusatzdaten im JSON-
  /// Sidecar (siehe pantry_extra_providers.dart) unter derselben ID
  /// abzulegen.
  Future<String> createItemReturningId({
    required String name,
    required DateTime expiryDate,
    String? icon,
    String? category,
    int? daysGoodAfterOpening,
    DateTime? openedAt,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.pantryItems).insert(
          PantryItemsCompanion.insert(
            id: id,
            name: name,
            expiryDate: expiryDate,
            icon: Value(icon),
            category: Value(category),
            daysGoodAfterOpening: Value(daysGoodAfterOpening),
            openedAt: Value(openedAt),
          ),
        );
    return id;
  }

  /// Ein-Klick-Aktion: Produkt wird jetzt als geöffnet markiert.
  Future<void> markOpened(String id) {
    return (_db.update(_db.pantryItems)..where((i) => i.id.equals(id)))
        .write(PantryItemsCompanion(openedAt: Value(DateTime.now())));
  }

  /// Volle Bearbeitung eines bestehenden Eintrags (Name, Kategorie,
  /// MHD, Öffnungs-Haltbarkeit) – alles Felder, die bereits als
  /// Drift-Spalten existieren. Menge/Nachkauf-Zyklus liegen separat
  /// im JSON-Sidecar (siehe pantry_extra_providers.dart) und werden
  /// hier bewusst NICHT mitgeschrieben.
  Future<void> updateItem({
    required String id,
    required String name,
    required DateTime expiryDate,
    String? icon,
    String? category,
    int? daysGoodAfterOpening,
    bool clearDaysGoodAfterOpening = false,
  }) {
    return (_db.update(_db.pantryItems)..where((i) => i.id.equals(id))).write(
      PantryItemsCompanion(
        name: Value(name),
        expiryDate: Value(expiryDate),
        icon: Value(icon),
        category: Value(category),
        daysGoodAfterOpening: clearDaysGoodAfterOpening
            ? const Value(null)
            : (daysGoodAfterOpening != null ? Value(daysGoodAfterOpening) : const Value.absent()),
      ),
    );
  }

  Future<void> deleteItem(String id) {
    return (_db.delete(_db.pantryItems)..where((i) => i.id.equals(id))).go();
  }
}
