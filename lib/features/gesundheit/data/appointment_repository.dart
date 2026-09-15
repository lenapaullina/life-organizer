import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart';
import '../../../core/notifications/notification_service.dart';

class AppointmentRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  AppointmentRepository(this._db);

  Stream<List<HealthAppointment>> watchAll() =>
      _db.select(_db.healthAppointments).watch();

  Future<void> _rescheduleNotification(HealthAppointment appointment) async {
    final base = appointment.lastCompletedAt ?? DateTime.now();
    await NotificationService.scheduleDueReminder(
      id: appointment.id,
      title: 'Termin fällig: ${appointment.name}',
      body: 'Alle ${appointment.intervalDays} Tage.',
      dueDate: base.add(Duration(days: appointment.intervalDays)),
    );
  }

  Future<void> createAppointment({
    required String name,
    required int intervalDays,
    String? notes,
    String? institution,
    String? address,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.healthAppointments).insert(
          HealthAppointmentsCompanion.insert(
            id: id,
            name: name,
            intervalDays: intervalDays,
            notes: Value(notes),
            institution: Value(institution),
            address: Value(address),
          ),
        );
    await NotificationService.scheduleDueReminder(
      id: id,
      title: 'Termin fällig: $name',
      body: 'Alle $intervalDays Tage.',
      dueDate: DateTime.now().add(Duration(days: intervalDays)),
    );
  }

  Future<void> updateInstitutionAndAddress(String id, {String? institution, String? address}) {
    return (_db.update(_db.healthAppointments)..where((a) => a.id.equals(id))).write(
      HealthAppointmentsCompanion(institution: Value(institution), address: Value(address)),
    );
  }

  Future<void> markCompletedNow(String id) async {
    await (_db.update(_db.healthAppointments)..where((a) => a.id.equals(id)))
        .write(HealthAppointmentsCompanion(lastCompletedAt: Value(DateTime.now())));
    final appointment = await (_db.select(_db.healthAppointments)..where((a) => a.id.equals(id)))
        .getSingleOrNull();
    if (appointment != null) await _rescheduleNotification(appointment);
  }

  Future<void> updateNotes(String id, String notes) {
    return (_db.update(_db.healthAppointments)..where((a) => a.id.equals(id)))
        .write(HealthAppointmentsCompanion(notes: Value(notes)));
  }

  Future<void> deleteAppointment(String id) async {
    await (_db.delete(_db.healthAppointments)..where((a) => a.id.equals(id))).go();
    await NotificationService.cancel(id);
  }
}
