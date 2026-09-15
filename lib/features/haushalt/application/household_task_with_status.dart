import '../../../core/database/database.dart';
import '../../../shared/utils/status_calculator.dart';

/// Kombiniert die rohe DB-Zeile mit dem berechneten Status.
/// Wird nirgends gespeichert, sondern in der Provider-Schicht
/// bei jedem DB-Update neu berechnet – so bleiben Schwellenwerte
/// zentral in status_calculator.dart änderbar.
class HouseholdTaskWithStatus {
  final HouseholdTask task;
  final IntervalStatus intervalStatus;

  const HouseholdTaskWithStatus({
    required this.task,
    required this.intervalStatus,
  });

  factory HouseholdTaskWithStatus.from(HouseholdTask task, {DateTime? now}) {
    return HouseholdTaskWithStatus(
      task: task,
      intervalStatus: calculateIntervalStatus(
        lastCompletedAt: task.lastCompletedAt,
        intervalDays: task.intervalDays,
        now: now,
      ),
    );
  }
}
