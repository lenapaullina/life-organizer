import '../../../core/database/database.dart';
import '../../../shared/utils/status_calculator.dart';

class AppointmentWithStatus {
  final HealthAppointment appointment;
  final IntervalStatus intervalStatus;

  const AppointmentWithStatus({required this.appointment, required this.intervalStatus});

  factory AppointmentWithStatus.from(HealthAppointment appointment, {DateTime? now}) {
    return AppointmentWithStatus(
      appointment: appointment,
      intervalStatus: calculateIntervalStatus(
        lastCompletedAt: appointment.lastCompletedAt,
        intervalDays: appointment.intervalDays,
        now: now,
      ),
    );
  }
}
