import '../../../core/database/database.dart';
import '../../../shared/utils/envelope_status_calculator.dart';
import '../../../shared/utils/status_calculator.dart' show TaskStatus;

class EnvelopeWithStatus {
  final Envelope envelope;
  final TaskStatus? status; // null = kein Ziel-Budget gesetzt

  const EnvelopeWithStatus({required this.envelope, required this.status});

  factory EnvelopeWithStatus.from(Envelope envelope) {
    return EnvelopeWithStatus(
      envelope: envelope,
      status: calculateEnvelopeStatus(
        balanceCents: envelope.balanceCents,
        targetCents: envelope.targetCents,
      ),
    );
  }
}
