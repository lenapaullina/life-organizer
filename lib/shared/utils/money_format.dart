/// Formatiert Cent-Beträge im deutschen Format ("12,34 €"),
/// inkl. korrektem Vorzeichen bei negativen Beträgen.
String formatCents(int cents) {
  final isNegative = cents < 0;
  final abs = cents.abs();
  final euros = abs ~/ 100;
  final rest = (abs % 100).toString().padLeft(2, '0');
  final formatted = '$euros,$rest €';
  return isNegative ? '-$formatted' : formatted;
}

/// Wandelt eine deutsche Texteingabe ("12,34" oder "12.34") in
/// Cents um. Gibt null zurück, wenn der Text nicht parsebar ist.
int? parseCents(String input) {
  final normalized = input.trim().replaceAll(',', '.');
  if (normalized.isEmpty) return null;
  final value = double.tryParse(normalized);
  if (value == null) return null;
  return (value * 100).round();
}
