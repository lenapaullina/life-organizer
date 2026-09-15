import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';

class BrainDumpRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  BrainDumpRepository(this._db);

  /// Angeheftete zuerst, danach nach Priorität (hoch zuerst), danach neueste.
  Stream<List<BrainDumpEntry>> watchOpen() {
    return (_db.select(_db.brainDumpEntries)
          ..where((e) => e.done.equals(false))
          ..orderBy([
            (e) => OrderingTerm.desc(e.pinned),
            (e) => OrderingTerm.desc(e.priority),
            (e) => OrderingTerm.desc(e.createdAt),
          ]))
        .watch();
  }

  Future<void> add(String text, {String? category, int priority = 1}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return Future.value();
    return _db.into(_db.brainDumpEntries).insert(
          BrainDumpEntriesCompanion.insert(
            id: _uuid.v4(),
            content: trimmed,
            category: Value(category),
            priority: Value(priority),
          ),
        );
  }

  Future<void> setPinned(String id, bool pinned) {
    return (_db.update(_db.brainDumpEntries)..where((e) => e.id.equals(id)))
        .write(BrainDumpEntriesCompanion(pinned: Value(pinned)));
  }

  Future<void> markDone(String id) {
    return (_db.update(_db.brainDumpEntries)..where((e) => e.id.equals(id)))
        .write(const BrainDumpEntriesCompanion(done: Value(true)));
  }

  Future<void> delete(String id) {
    return (_db.delete(_db.brainDumpEntries)..where((e) => e.id.equals(id))).go();
  }
}
