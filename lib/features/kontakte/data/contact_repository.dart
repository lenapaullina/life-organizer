import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';
import '../../../core/notifications/notification_service.dart';

class ContactRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  ContactRepository(this._db);

  Stream<List<Contact>> watchAll() => _db.select(_db.contacts).watch();

  Stream<Contact?> watchOne(String id) {
    return (_db.select(_db.contacts)..where((c) => c.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<void> _rescheduleNotification(Contact contact) async {
    if (contact.reminderIntervalDays == null) {
      await NotificationService.cancel(contact.id);
      return;
    }
    final base = contact.lastContactedAt ?? DateTime.now();
    await NotificationService.scheduleDueReminder(
      id: contact.id,
      title: 'Melde dich bei ${contact.name}',
      body: 'Alle ${contact.reminderIntervalDays} Tage – Zeit für ein Lebenszeichen.',
      dueDate: base.add(Duration(days: contact.reminderIntervalDays!)),
    );
  }

  Future<void> createContact({
    required String name,
    String? notes,
    DateTime? birthday,
    int? reminderIntervalDays,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.contacts).insert(
          ContactsCompanion.insert(
            id: id,
            name: name,
            notes: Value(notes),
            birthday: Value(birthday),
            reminderIntervalDays: Value(reminderIntervalDays),
          ),
        );
    if (reminderIntervalDays != null) {
      await NotificationService.scheduleDueReminder(
        id: id,
        title: 'Melde dich bei $name',
        body: 'Alle $reminderIntervalDays Tage – Zeit für ein Lebenszeichen.',
        dueDate: DateTime.now().add(Duration(days: reminderIntervalDays)),
      );
    }
  }

  /// Wie bei den Haushaltsaufgaben: 1 Klick, Timer zurückgesetzt.
  Future<void> markContactedNow(String id) async {
    await (_db.update(_db.contacts)..where((c) => c.id.equals(id)))
        .write(ContactsCompanion(lastContactedAt: Value(DateTime.now())));
    final contact = await (_db.select(_db.contacts)..where((c) => c.id.equals(id))).getSingleOrNull();
    if (contact != null) await _rescheduleNotification(contact);
  }

  Future<void> updateNotes(String id, String notes) {
    return (_db.update(_db.contacts)..where((c) => c.id.equals(id)))
        .write(ContactsCompanion(notes: Value(notes)));
  }

  Future<void> updatePhoto(String id, String? photoPath) {
    return (_db.update(_db.contacts)..where((c) => c.id.equals(id)))
        .write(ContactsCompanion(photoPath: Value(photoPath)));
  }

  Future<void> deleteContact(String id) async {
    await (_db.delete(_db.contacts)..where((c) => c.id.equals(id))).go();
    await NotificationService.cancel(id);
  }
}
