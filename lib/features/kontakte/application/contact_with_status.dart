import '../../../core/database/database.dart';
import '../../../shared/utils/status_calculator.dart';

/// Nutzt calculateIntervalStatus 1:1 wieder – "zuletzt kontaktiert"
/// + Erinnerungsintervall ist strukturell dasselbe Problem wie
/// "zuletzt erledigt" + Putz-Intervall in Modul 1.
class ContactWithStatus {
  final Contact contact;
  final IntervalStatus? intervalStatus; // null = kein Erinnerungsintervall gesetzt

  const ContactWithStatus({required this.contact, required this.intervalStatus});

  factory ContactWithStatus.from(Contact contact, {DateTime? now}) {
    if (contact.reminderIntervalDays == null) {
      return ContactWithStatus(contact: contact, intervalStatus: null);
    }
    return ContactWithStatus(
      contact: contact,
      intervalStatus: calculateIntervalStatus(
        lastCompletedAt: contact.lastContactedAt,
        intervalDays: contact.reminderIntervalDays!,
        now: now,
      ),
    );
  }
}
