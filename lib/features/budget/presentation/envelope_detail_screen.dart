import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/money_format.dart';
import '../application/budget_providers.dart';
import '../application/envelope_with_status.dart';
import 'add_expense_dialog.dart';

class EnvelopeDetailScreen extends ConsumerWidget {
  final String envelopeId;

  const EnvelopeDetailScreen({super.key, required this.envelopeId});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Umschlag löschen?'),
        content: const Text('Alle Buchungen dieses Umschlags gehen dabei verloren.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Löschen')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(envelopeRepositoryProvider).deleteEnvelope(envelopeId);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envelopesAsync = ref.watch(envelopesWithStatusProvider);
    final transactionsAsync = ref.watch(envelopeTransactionsProvider(envelopeId));

    return envelopesAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Fehler: $err'))),
      data: (entries) {
        EnvelopeWithStatus? entry;
        for (final e in entries) {
          if (e.envelope.id == envelopeId) {
            entry = e;
            break;
          }
        }
        if (entry == null) {
          return const Scaffold(body: Center(child: Text('Umschlag wurde gelöscht.')));
        }
        final envelope = entry.envelope;

        return Scaffold(
          appBar: AppBar(
            title: Text(envelope.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatCents(envelope.balanceCents),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton.icon(
                  onPressed: () => showAddExpenseDialog(
                    context,
                    ref,
                    envelopeId: envelope.id,
                    envelopeName: envelope.name,
                  ),
                  icon: const Icon(Icons.remove_circle_outline),
                  label: const Text('Ausgabe hinzufügen'),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Letzte Buchungen', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: transactionsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Text('Fehler: $err'),
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return const Text(
                          'Noch keine Buchungen.',
                          style: TextStyle(color: AppColors.textSecondary),
                        );
                      }
                      return ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final t = transactions[index];
                          final isIncome = t.amountCents > 0;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              isIncome ? Icons.add_circle_outline : Icons.remove_circle_outline,
                              color: isIncome ? AppColors.statusGreen : AppColors.statusRed,
                            ),
                            title: Text(t.note ?? (isIncome ? 'Einzahlung' : 'Ausgabe')),
                            subtitle: Text(
                              '${t.createdAt.day}.${t.createdAt.month}.${t.createdAt.year}',
                            ),
                            trailing: Text(
                              formatCents(t.amountCents),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isIncome ? AppColors.statusGreen : AppColors.statusRed,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
