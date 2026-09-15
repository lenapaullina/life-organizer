import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart' show appDatabaseProvider;
import '../data/storage_location_repository.dart';

final storageLocationRepositoryProvider = Provider<StorageLocationRepository>((ref) {
  return StorageLocationRepository(ref.watch(appDatabaseProvider));
});

final storageLocationsProvider = StreamProvider<List<StorageLocation>>((ref) {
  return ref.watch(storageLocationRepositoryProvider).watchAll();
});
