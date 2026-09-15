import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/money_format.dart';
import '../../../shared/utils/status_calculator.dart' show TaskStatus;
import '../../../shared/widgets/simple_progress_bar.dart';
import '../../../shared/widgets/status_pill.dart';
import '../application/budget_providers.dart';
import '../application/envelope_with_status.dart';
import 'add_envelope_sheet.dart';
import 'add_expense_dialog.dart';
import 'allocate_income_sheet.dart';
import 'envelope_detail_screen.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envelopesAsync = ref.watch(envelopesWithStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Budget')),
      body: envelopesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (envelopes) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showAllocateIncomeSheet(context, ref),
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Gehalt verteilen'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (envelopes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xl),
                  child: Text(
                    'Noch keine Umschläge angelegt.\nTippe auf + um loszulegen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                ...envelopes.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _EnvelopeCard(entry: e),
                    )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEnvelopeSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EnvelopeCard extends ConsumerWidget {
  final EnvelopeWithStatus entry;

  const _EnvelopeCard({required this.entry});

  Color _colorFor(TaskStatus status) => switch (status) {
        TaskStatus.green => AppColors.statusGreen,
        TaskStatus.yellow => AppColors.statusYellow,
        TaskStatus.red => AppColors.statusRed,
      };

  String _labelFor(TaskStatus status) => switch (status) {
        TaskStatus.green => 'Gesund',
        TaskStatus.yellow => 'Knapp',
        TaskStatus.red => 'Aufgebraucht',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envelope = entry.envelope;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EnvelopeDetailScreen(envelopeId: envelope.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(envelope.name, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  if (entry.status != null)
                    StatusPill(status: entry.status!, label: _labelFor(entry.status!)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                formatCents(envelope.balanceCents),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              if (envelope.targetCents != null) ...[
                const SizedBox(height: AppSpacing.sm),
                SimpleProgressBar(
                  progress: envelope.balanceCents / envelope.targetCents!,
                  color: entry.status != null ? _colorFor(entry.status!) : AppColors.accent,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'von ${formatCents(envelope.targetCents!)}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => showAddExpenseDialog(
                    context,
                    ref,
                    envelopeId: envelope.id,
                    envelopeName: envelope.name,
                  ),
                  icon: const Icon(Icons.remove_circle_outline, size: 18),
                  label: const Text('Ausgabe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
