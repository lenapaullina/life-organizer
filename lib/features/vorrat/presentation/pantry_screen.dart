import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/status_calculator.dart' show TaskStatus;
import '../../../shared/widgets/status_pill.dart';
import '../application/pantry_item_with_status.dart';
import '../application/pantry_providers.dart';
import 'add_pantry_item_sheet.dart';
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

    return Card(
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
    );
  }
}
