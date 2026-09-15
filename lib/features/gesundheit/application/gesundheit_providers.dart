import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../haushalt/application/household_task_providers.dart' show appDatabaseProvider;
import '../data/appointment_repository.dart';
import '../data/medication_repository.dart';
import 'appointment_with_status.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(ref.watch(appDatabaseProvider));
});

final _appointmentsStreamProvider = StreamProvider<List<HealthAppointment>>((ref) {
  return ref.watch(appointmentRepositoryProvider).watchAll();
});

final sortedAppointmentsProvider = Provider<AsyncValue<List<AppointmentWithStatus>>>((ref) {
  final async = ref.watch(_appointmentsStreamProvider);
  return async.whenData((list) {
    final withStatus = list.map((a) => AppointmentWithStatus.from(a)).toList();
    withStatus.sort((a, b) => b.intervalStatus.progress.compareTo(a.intervalStatus.progress));
    return withStatus;
  });
});

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepository(ref.watch(appDatabaseProvider));
});

final medicationsProvider = StreamProvider<List<Medication>>((ref) {
  return ref.watch(medicationRepositoryProvider).watchAll();
});

final todayIntakeProvider =
    StreamProvider.family<MedicationIntakeLog?, String>((ref, medicationId) {
  return ref.watch(medicationRepositoryProvider).watchTodayIntake(medicationId);
});
