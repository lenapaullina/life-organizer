import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/money_format.dart';
import '../application/budget_providers.dart';

Future<void> showAllocateIncomeSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AllocateIncomeSheet(),
  );
}

class _AllocateIncomeSheet extends ConsumerStatefulWidget {
  const _AllocateIncomeSheet();

  @override
  ConsumerState<_AllocateIncomeSheet> createState() => _AllocateIncomeSheetState();
}

class _AllocateIncomeSheetState extends ConsumerState<_AllocateIncomeSheet> {
  final _totalController = TextEditingController();
  final Map<String, TextEditingController> _envelopeControllers = {};

  TextEditingController _controllerFor(String envelopeId) {
    return _envelopeControllers.putIfAbsent(envelopeId, () => TextEditingController());
  }

  int get _totalCents => parseCents(_totalController.text) ?? 0;

  int get _allocatedCents {
    return _envelopeControllers.values
        .map((c) => parseCents(c.text) ?? 0)
        .fold(0, (a, b) => a + b);
  }

  Future<void> _submit(List<Envelope> envelopes) async {
    final repo = ref.read(envelopeRepositoryProvider);
    for (final envelope in envelopes) {
      final cents = parseCents(_envelopeControllers[envelope.id]?.text ?? '');
      if (cents != null && cents > 0) {
        await repo.addTransaction(
          envelopeId: envelope.id,
          amountCents: cents,
          note: 'Gehaltseingang',
        );
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _totalController.dispose();
    for (final c in _envelopeControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final envelopesAsync = ref.watch(envelopesWithStatusProvider);

    return SingleChildScrollView(
      child: Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: envelopesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Text('Fehler: $err'),
        data: (envelopesWithStatus) {
          final envelopes = envelopesWithStatus.map((e) => e.envelope).toList();

          if (envelopes.isEmpty) {
            return const Text('Lege zuerst mindestens einen Umschlag an.');
          }

          final remaining = _totalCents - _allocatedCents;

          return StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gehalt verteilen', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _totalController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Gesamtbetrag', suffixText: '€'),
                    onChanged: (_) => setSheetState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...envelopes.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        children: [
                          Expanded(child: Text(e.name)),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _controllerFor(e.id),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(suffixText: '€'),
                              onChanged: (_) => setSheetState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    remaining == 0
                        ? 'Vollständig verteilt'
                        : 'Noch nicht verteilt: ${formatCents(remaining)}',
                    style: TextStyle(
                      color: remaining < 0 ? AppColors.statusRed : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => _submit(envelopes),
                    child: const Text('Verteilen'),
                  ),
                ],
              );
            },
          );
        },
      ),
      ),
    );
  }
}
