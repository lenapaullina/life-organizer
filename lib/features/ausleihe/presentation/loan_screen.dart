import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/loan_providers.dart';
import '../loan_item.dart';
import 'add_loan_sheet.dart';

String _formatDate(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day.$month.${d.year}';
}

/// "Wer hat mein Buch? Wem habe ich Werkzeug geliehen?" – verhindert,
/// dass Verliehenes im digitalen Nichts verschwindet.
class LoanScreen extends ConsumerWidget {
  const LoanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(filteredLoansProvider);
    final activeFilter = ref.watch(loanDirectionFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ausleihe')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddLoanSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            child: Wrap(
              spacing: AppSpacing.xs,
              children: [
                ChoiceChip(
                  label: const Text('Alle'),
                  selected: activeFilter == null,
                  onSelected: (_) => ref.read(loanDirectionFilterProvider.notifier).state = null,
                ),
                for (final direction in LoanDirection.values)
                  ChoiceChip(
                    label: Text(direction.label),
                    selected: activeFilter == direction,
                    onSelected: (selected) => ref.read(loanDirectionFilterProvider.notifier).state =
                        selected ? direction : null,
                  ),
              ],
            ),
          ),
          Expanded(
            child: loansAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Fehler: $err')),
              data: (loans) {
                if (loans.isEmpty) {
                  return const _EmptyState();
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: loans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) => _LoanCard(loan: loans[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanCard extends ConsumerWidget {
  final LoanItem loan;
  const _LoanCard({required this.loan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Opacity(
        opacity: loan.returned ? 0.55 : 1,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  loan.returned ? Icons.check_circle : Icons.circle_outlined,
                  color: loan.returned ? AppColors.statusGreen : AppColors.textSecondary,
                ),
                tooltip: 'Zurückgegeben',
                onPressed: () => ref.read(loanProvider.notifier).toggleReturned(loan.id),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.itemName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: loan.returned ? TextDecoration.lineThrough : null,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${loan.direction.label} · ${loan.direction.questionFor(loan.personName)} · ${_formatDate(loan.date)}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    if (loan.note != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        loan.note!,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => ref.read(loanProvider.notifier).deleteLoan(loan.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'Noch nichts verliehen oder geliehen.\nTippe auf + um etwas einzutragen.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
