import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../application/gesundheit_providers.dart';

Future<void> showAddMedicationSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddMedicationSheet(),
  );
}

class _AddMedicationSheet extends ConsumerStatefulWidget {
  const _AddMedicationSheet();

  @override
  ConsumerState<_AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends ConsumerState<_AddMedicationSheet> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  int _timesPerDay = 1;

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await ref.read(medicationRepositoryProvider).createMedication(
          name: name,
          dosageNote: _dosageController.text.trim().isEmpty ? null : _dosageController.text.trim(),
          timesPerDay: _timesPerDay,
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
          Text('Neues Medikament', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _dosageController,
            decoration: const InputDecoration(labelText: 'Dosierung (optional)', hintText: 'z.B. "1 Tablette"'),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Text('Einnahmen pro Tag:'),
              const Spacer(),
              IconButton(
                onPressed: _timesPerDay > 1 ? () => setState(() => _timesPerDay--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_timesPerDay', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              IconButton(
                onPressed: _timesPerDay < 6 ? () => setState(() => _timesPerDay++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(onPressed: _submit, child: const Text('Anlegen')),
        ],
      ),
      ),
    );
  }
}
