import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/loan_providers.dart';
import '../loan_item.dart';

void showAddLoanSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddLoanSheet(),
  );
}

class _AddLoanSheet extends ConsumerStatefulWidget {
  const _AddLoanSheet();

  @override
  ConsumerState<_AddLoanSheet> createState() => _AddLoanSheetState();
}

class _AddLoanSheetState extends ConsumerState<_AddLoanSheet> {
  final _itemController = TextEditingController();
  final _personController = TextEditingController();
  final _noteController = TextEditingController();
  LoanDirection _direction = LoanDirection.lent;

  @override
  void dispose() {
    _itemController.dispose();
    _personController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final item = _itemController.text.trim();
    final person = _personController.text.trim();
    if (item.isEmpty || person.isEmpty) return;

    await ref.read(loanProvider.notifier).addLoan(
          itemName: item,
          personName: person,
          direction: _direction,
          note: _noteController.text,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Neuer Leih-Eintrag', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                for (final direction in LoanDirection.values)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: ChoiceChip(
                      label: Text(direction.label),
                      selected: _direction == direction,
                      onSelected: (_) => setState(() => _direction = direction),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _itemController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Was?',
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _personController,
              decoration: InputDecoration(
                labelText: _direction == LoanDirection.lent ? 'An wen?' : 'Von wem?',
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _noteController,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notiz (optional)',
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Hinzufügen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
