import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart' show appDatabaseProvider;
import '../data/brain_dump_repository.dart';

final brainDumpRepositoryProvider = Provider<BrainDumpRepository>((ref) {
  return BrainDumpRepository(ref.watch(appDatabaseProvider));
});

final openBrainDumpEntriesProvider = StreamProvider<List<BrainDumpEntry>>((ref) {
  return ref.watch(brainDumpRepositoryProvider).watchOpen();
});
