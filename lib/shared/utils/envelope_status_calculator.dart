import '../../shared/utils/status_calculator.dart' show TaskStatus;

/// Gibt null zurück, wenn kein Ziel-Budget gesetzt ist – dann zeigt
/// die UI bewusst keine Farbe/Bewertung, nur den nackten Saldo.
/// Das vermeidet, dass ein Umschlag ohne festen Rahmen künstlich
/// als "kritisch" markiert wird.
TaskStatus? calculateEnvelopeStatus({
  required int balanceCents,
  int? targetCents,
}) {
  if (targetCents == null || targetCents <= 0) return null;

  final ratio = balanceCents / targetCents;
  if (ratio > 0.5) return TaskStatus.green;
  if (ratio > 0.15) return TaskStatus.yellow;
  return TaskStatus.red;
}
