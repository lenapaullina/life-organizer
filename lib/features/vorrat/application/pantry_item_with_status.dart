import '../../../core/database/database.dart';
import '../../../shared/utils/pantry_status_calculator.dart';

class PantryItemWithStatus {
  final PantryItem item;
  final PantryStatus status;

  const PantryItemWithStatus({required this.item, required this.status});

  factory PantryItemWithStatus.from(PantryItem item, {DateTime? now}) {
    return PantryItemWithStatus(
      item: item,
      status: calculatePantryStatus(
        expiryDate: item.expiryDate,
        openedAt: item.openedAt,
        daysGoodAfterOpening: item.daysGoodAfterOpening,
        now: now,
      ),
    );
  }
}
