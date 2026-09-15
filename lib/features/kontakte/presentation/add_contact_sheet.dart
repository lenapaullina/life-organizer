import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../application/contact_providers.dart';

Future<void> showAddContactSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddContactSheet(),
  );
}

class _AddContactSheet extends ConsumerStatefulWidget {
  const _AddContactSheet();

  @override
  ConsumerState<_AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends ConsumerState<_AddContactSheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  bool _reminderEnabled = true;
  int _reminderInterval = 14; // Default aus der ursprünglichen Anforderung
  DateTime? _birthday;

  Future<void> _pickBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 30),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Geburtstag',
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await ref.read(contactRepositoryProvider).createContact(
          name: name,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          birthday: _birthday,
          reminderIntervalDays: _reminderEnabled ? _reminderInterval : null,
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
          Text('Neuer Kontakt', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notizen',
              helperText: 'Vorlieben, wichtige Infos, ...',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Geburtstag'),
            subtitle: Text(
              _birthday == null
                  ? 'Nicht gesetzt'
                  : '${_birthday!.day}.${_birthday!.month}.${_birthday!.year}',
            ),
            trailing: const Icon(Icons.cake_outlined),
            onTap: _pickBirthday,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Erinnerung "melden"'),
            value: _reminderEnabled,
            onChanged: (v) => setState(() => _reminderEnabled = v),
          ),
          if (_reminderEnabled)
            Row(
              children: [
                const Text('Alle'),
                Expanded(
                  child: Slider(
                    value: _reminderInterval.toDouble(),
                    min: 1,
                    max: 90,
                    divisions: 89,
                    label: '$_reminderInterval Tage',
                    onChanged: (v) => setState(() => _reminderInterval = v.round()),
                  ),
                ),
                Text('$_reminderInterval Tage'),
              ],
            ),
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Kontakt anlegen'),
          ),
        ],
      ),
      ),
    );
  }
}
