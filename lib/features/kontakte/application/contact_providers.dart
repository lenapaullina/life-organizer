import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart' show appDatabaseProvider;
import '../data/contact_repository.dart';
import 'contact_with_status.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository(ref.watch(appDatabaseProvider));
});

final _contactsStreamProvider = StreamProvider<List<Contact>>((ref) {
  return ref.watch(contactRepositoryProvider).watchAll();
});

/// Kontakte MIT Erinnerungsintervall zuerst (dringlichste oben),
/// Kontakte OHNE Intervall danach, alphabetisch – die sind reines
/// Nachschlagewerk und sollen die "melden"-Liste nicht zumüllen.
final sortedContactsProvider = Provider<AsyncValue<List<ContactWithStatus>>>((ref) {
  final contactsAsync = ref.watch(_contactsStreamProvider);

  return contactsAsync.whenData((contacts) {
    final withStatus = contacts.map((c) => ContactWithStatus.from(c)).toList();

    withStatus.sort((a, b) {
      if (a.intervalStatus == null && b.intervalStatus == null) {
        return a.contact.name.compareTo(b.contact.name);
      }
      if (a.intervalStatus == null) return 1;
      if (b.intervalStatus == null) return -1;
      return b.intervalStatus!.progress.compareTo(a.intervalStatus!.progress);
    });

    return withStatus;
  });
});

final contactDetailProvider = StreamProvider.family<Contact?, String>((ref, id) {
  return ref.watch(contactRepositoryProvider).watchOne(id);
});
