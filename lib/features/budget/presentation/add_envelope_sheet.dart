import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/money_format.dart';
import '../application/budget_providers.dart';

Future<void> showAddEnvelopeSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddEnvelopeSheet(),
  );
}

class _AddEnvelopeSheet extends ConsumerStatefulWidget {
  const _AddEnvelopeSheet();

  @override
  ConsumerState<_AddEnvelopeSheet> createState() => _AddEnvelopeSheetState();
}

class _AddEnvelopeSheetState extends ConsumerState<_AddEnvelopeSheet> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await ref.read(envelopeRepositoryProvider).createEnvelope(
          name: name,
          targetCents: parseCents(_targetController.text),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Neuer Umschlag', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name (z.B. "Lebensmittel")'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _targetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Ziel-Budget pro Periode (optional)',
              helperText: 'Nur für die Farbanzeige – ohne Angabe: nur Saldo',
              suffixText: '€',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(onPressed: _submit, child: const Text('Anlegen')),
        ],
      ),
      ),
    );
  }
}
