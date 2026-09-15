/// Zentrale Statuslogik. Bewusst als reine, ungebundene Funktionen
/// gehalten (kein Widget, keine DB) – so bleibt sie in Modul 1
/// (Haushalt), Modul 4 (Kontakte) und Modul 6 (Gesundheit) 1:1
/// wiederverwendbar, auch wenn dort andere Datenmodelle dahinterstehen.
library status_calculator;

enum TaskStatus { green, yellow, red }

class IntervalStatus {
  final int? daysSinceCompleted; // null = noch nie erledigt
  final int daysOverdue; // negativ = noch nicht fällig
  final TaskStatus status;
  final double progress; // 0.0–1.0+, für die Fortschrittsanzeige

  const IntervalStatus({
    required this.daysSinceCompleted,
    required this.daysOverdue,
    required this.status,
    required this.progress,
  });
}

/// Berechnet den Status einer intervallbasierten Aufgabe.
///
/// [lastCompletedAt] = wann zuletzt erledigt (oder null, wenn noch nie).
/// [intervalDays] = gewünschter Rhythmus in Tagen.
/// [now] = Referenzzeitpunkt (Default: DateTime.now()), als Parameter
/// für Testbarkeit.
IntervalStatus calculateIntervalStatus({
  required DateTime? lastCompletedAt,
  required int intervalDays,
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();

  if (lastCompletedAt == null) {
    // Nie erledigt -> sofort als "fällig" behandeln, aber nicht
    // dramatisieren: gelb statt rot, um keinen Alarm-Ton zu setzen.
    return const IntervalStatus(
      daysSinceCompleted: null,
      daysOverdue: 0,
      status: TaskStatus.yellow,
      progress: 1.0,
    );
  }

  final daysSince = reference.difference(lastCompletedAt).inDays;
  final daysOverdue = daysSince - intervalDays;
  final progress = intervalDays == 0 ? 1.0 : daysSince / intervalDays;

  final TaskStatus status;
  if (progress < 0.8) {
    status = TaskStatus.green;
  } else if (progress < 1.0) {
    status = TaskStatus.yellow;
  } else {
    status = TaskStatus.red;
  }

  return IntervalStatus(
    daysSinceCompleted: daysSince,
    daysOverdue: daysOverdue,
    status: status,
    progress: progress,
  );
}
