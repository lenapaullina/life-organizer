import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';

class EnvelopeRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  EnvelopeRepository(this._db);

  Stream<List<Envelope>> watchAll() => _db.select(_db.envelopes).watch();

  Future<void> createEnvelope({
    required String name,
    String? icon,
    int? targetCents,
  }) {
    return _db.into(_db.envelopes).insert(
          EnvelopesCompanion.insert(
            id: _uuid.v4(),
            name: name,
            icon: Value(icon),
            targetCents: Value(targetCents),
          ),
        );
  }

  /// Bucht einen Betrag (positiv = Einzahlung, negativ = Ausgabe) und
  /// aktualisiert den Saldo in derselben Transaktion, damit beide nie
  /// auseinanderlaufen können.
  Future<void> addTransaction({
    required String envelopeId,
    required int amountCents,
    String? note,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.envelopeTransactions).insert(
            EnvelopeTransactionsCompanion.insert(
              id: _uuid.v4(),
              envelopeId: envelopeId,
              amountCents: amountCents,
              note: Value(note),
            ),
          );

      final envelope = await (_db.select(_db.envelopes)
            ..where((e) => e.id.equals(envelopeId)))
          .getSingle();

      await (_db.update(_db.envelopes)..where((e) => e.id.equals(envelopeId)))
          .write(
        EnvelopesCompanion(
          balanceCents: Value(envelope.balanceCents + amountCents),
        ),
      );
    });
  }

  /// Zeigt bewusst nur die letzten [limit] Buchungen – volle Historie
  /// würde dem "keine komplexen Historien"-Prinzip widersprechen.
  Stream<List<EnvelopeTransaction>> watchRecentTransactions(
    String envelopeId, {
    int limit = 10,
  }) {
    return (_db.select(_db.envelopeTransactions)
          ..where((t) => t.envelopeId.equals(envelopeId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .watch();
  }

  Future<void> deleteEnvelope(String id) {
    return (_db.delete(_db.envelopes)..where((e) => e.id.equals(id))).go();
  }
}
