import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart' show appDatabaseProvider;
import '../data/envelope_repository.dart';
import 'envelope_with_status.dart';

final envelopeRepositoryProvider = Provider<EnvelopeRepository>((ref) {
  return EnvelopeRepository(ref.watch(appDatabaseProvider));
});

final _envelopesStreamProvider = StreamProvider<List<Envelope>>((ref) {
  return ref.watch(envelopeRepositoryProvider).watchAll();
});

final envelopesWithStatusProvider = Provider<AsyncValue<List<EnvelopeWithStatus>>>((ref) {
  final async = ref.watch(_envelopesStreamProvider);
  return async.whenData((list) => list.map((e) => EnvelopeWithStatus.from(e)).toList());
});

final envelopeTransactionsProvider =
    StreamProvider.family<List<EnvelopeTransaction>, String>((ref, envelopeId) {
  return ref.watch(envelopeRepositoryProvider).watchRecentTransactions(envelopeId);
});
