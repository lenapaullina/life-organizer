import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/status_calculator.dart' show TaskStatus;
import '../../../shared/widgets/status_pill.dart';
import '../application/pantry_extra_providers.dart';
import '../application/pantry_item_with_status.dart';
import '../application/pantry_providers.dart';
import 'add_pantry_item_sheet.dart';
import 'edit_pantry_item_sheet.dart';
import 'receipt_scan_screen.dart';

class PantryScreen extends ConsumerWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(sortedPantryItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vorrat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'Kassenbon einbuchen',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ReceiptScanScreen()),
            ),
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Noch nichts im Vorrat erfasst.\nTippe auf + um loszulegen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => _PantryCard(entry: items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddPantryItemSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PantryCard extends ConsumerWidget {
  final PantryItemWithStatus entry;

  const _PantryCard({required this.entry});

  String _statusLabel(TaskStatus status) => switch (status) {
        TaskStatus.green => 'Frisch',
        TaskStatus.yellow => 'Bald ablaufend',
        TaskStatus.red => 'Kritisch',
      };

  String _remainingText() {
    final days = entry.status.daysRemaining;
    final suffix = entry.status.expiresDueToOpening ? ' (seit Öffnung)' : '';
    if (days < 0) return 'Seit ${-days} Tagen abgelaufen$suffix';
    if (days == 0) return 'Läuft heute ab$suffix';
    return 'Noch $days Tage haltbar$suffix';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = entry.item;
    final isOpened = item.openedAt != null;
    final extra = ref.watch(pantryExtraProvider)[item.id];

    // Tippen auf die Karte öffnet die volle Bearbeitung (Name, Menge,
    // MHD, Nachkauf-Zyklus) – die "Als geöffnet markieren"-Aktion
    // bleibt als eigener Button für den schnellen Ein-Klick-Fall.
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => showEditPantryItemSheet(context, ref, item),
        child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                ),
                StatusPill(status: entry.status.status, label: _statusLabel(entry.status.status)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(_remainingText(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            if (extra?.quantity != null || extra?.cycleDays != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  if (extra?.quantity != null)
                    _InfoChip(icon: Icons.inventory_2_outlined, label: extra!.quantity!),
                  if (extra?.cycleDays != null)
                    _InfoChip(
                      icon: Icons.autorenew,
                      label: 'alle ${extra!.cycleDays} Tage nachkaufen',
                    ),
                ],
              ),
            ],
            if (!isOpened && item.daysGoodAfterOpening != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => ref.read(pantryRepositoryProvider).markOpened(item.id),
                  icon: const Icon(Icons.lock_open, size: 18),
                  label: const Text('Als geöffnet markieren'),
                ),
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
