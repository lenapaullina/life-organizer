import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';

class StorageLocationRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  StorageLocationRepository(this._db);

  Stream<List<StorageLocation>> watchAll() =>
      _db.select(_db.storageLocations).watch();

  Future<void> create({
    required String itemName,
    required String location,
    String? notes,
    String? photoPath,
  }) {
    return _db.into(_db.storageLocations).insert(
          StorageLocationsCompanion.insert(
            id: _uuid.v4(),
            itemName: itemName,
            location: location,
            notes: Value(notes),
            photoPath: Value(photoPath),
          ),
        );
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.storageLocations)..where((s) => s.id.equals(id))).go();
  }
}
