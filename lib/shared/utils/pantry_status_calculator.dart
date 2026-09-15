import '../../shared/utils/status_calculator.dart' show TaskStatus;

/// Ergebnis der Vorrats-Statusberechnung. Nutzt bewusst denselben
/// TaskStatus-Enum wie status_calculator.dart, damit StatusPill
/// & Co. unverändert wiederverwendbar bleiben.
class PantryStatus {
  final DateTime effectiveExpiryDate;
  final int daysRemaining; // negativ = bereits abgelaufen
  final TaskStatus status;
  final bool expiresDueToOpening; // true = Öffnungsfrist ist der Flaschenhals

  const PantryStatus({
    required this.effectiveExpiryDate,
    required this.daysRemaining,
    required this.status,
    required this.expiresDueToOpening,
  });
}

/// Berechnet, welches Datum tatsächlich zählt: das MHD oder –
/// falls das Produkt geöffnet wurde und eine Öffnungsfrist hat –
/// "geöffnet am + X Tage", je nachdem was früher eintritt.
PantryStatus calculatePantryStatus({
  required DateTime expiryDate,
  DateTime? openedAt,
  int? daysGoodAfterOpening,
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();

  DateTime effectiveExpiry = expiryDate;
  bool dueToOpening = false;

  if (openedAt != null && daysGoodAfterOpening != null) {
    final openingLimit = openedAt.add(Duration(days: daysGoodAfterOpening));
    if (openingLimit.isBefore(effectiveExpiry)) {
      effectiveExpiry = openingLimit;
      dueToOpening = true;
    }
  }

  final daysRemaining = _dateOnly(effectiveExpiry).difference(_dateOnly(reference)).inDays;

  final TaskStatus status;
  if (daysRemaining <= 0) {
    status = TaskStatus.red;
  } else if (daysRemaining <= 3) {
    status = TaskStatus.yellow;
  } else {
    status = TaskStatus.green;
  }

  return PantryStatus(
    effectiveExpiryDate: effectiveExpiry,
    daysRemaining: daysRemaining,
    status: status,
    expiresDueToOpening: dueToOpening,
  );
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
