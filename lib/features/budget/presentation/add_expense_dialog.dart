import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/money_format.dart';
import '../application/budget_providers.dart';

/// Bewusst als Dialog statt Sheet – eine Ausgabe erfassen ist der
/// häufigste Vorgang hier und soll mit möglichst wenig Wechsel
/// zwischen Tastatur und Bildschirm gehen.
Future<void> showAddExpenseDialog(
  BuildContext context,
  WidgetRef ref, {
  required String envelopeId,
  required String envelopeName,
}) {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Ausgabe · $envelopeName'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Betrag', suffixText: '€'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: noteController,
            decoration: const InputDecoration(labelText: 'Wofür? (optional)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () {
            final cents = parseCents(amountController.text);
            if (cents == null || cents <= 0) return;
            ref.read(envelopeRepositoryProvider).addTransaction(
                  envelopeId: envelopeId,
                  amountCents: -cents, // Ausgabe = negativ
                  note: noteController.text.trim().isEmpty
                      ? null
                      : noteController.text.trim(),
                );
            Navigator.pop(dialogContext);
          },
          child: const Text('Buchen'),
        ),
      ],
    ),
  );
}
