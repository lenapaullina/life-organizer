import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../application/pantry_providers.dart';

/// Presets tragen die typische Öffnungsfrist schon mit – das MHD
/// selbst kann sich je nach Packung stark unterscheiden und muss
/// daher immer manuell eingegeben werden (steht ja aufgedruckt).
class _PantryPreset {
  final String name;
  final int? daysGoodAfterOpening;
  final IconData icon;
  const _PantryPreset(this.name, this.daysGoodAfterOpening, this.icon);
}

const _presets = [
  _PantryPreset('Milch', 3, Icons.local_drink_outlined),
  _PantryPreset('Joghurt', 5, Icons.icecream_outlined),
  _PantryPreset('Aufschnitt', 3, Icons.lunch_dining_outlined),
  _PantryPreset('Käse', 10, Icons.egg_outlined),
  _PantryPreset('Butter', 30, Icons.bakery_dining_outlined),
  _PantryPreset('Eier', null, Icons.egg_alt_outlined),
  _PantryPreset('Gemüse', null, Icons.eco_outlined),
  _PantryPreset('Angebrochene Reste', 3, Icons.dinner_dining_outlined),
];

Future<void> showAddPantryItemSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddPantryItemSheet(),
  );
}

class _AddPantryItemSheet extends ConsumerStatefulWidget {
  const _AddPantryItemSheet();

  @override
  ConsumerState<_AddPantryItemSheet> createState() => _AddPantryItemSheetState();
}

class _AddPantryItemSheetState extends ConsumerState<_AddPantryItemSheet> {
  _PantryPreset? _selectedPreset;
  bool _customName = false;
  final _nameController = TextEditingController();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));
  bool _alreadyOpened = false;

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      helpText: 'Mindesthaltbarkeitsdatum',
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _submit() async {
    final name = _customName ? _nameController.text.trim() : _selectedPreset?.name;
    if (name == null || name.isEmpty) return;

    await ref.read(pantryRepositoryProvider).createItem(
          name: name,
          expiryDate: _expiryDate,
          daysGoodAfterOpening: _selectedPreset?.daysGoodAfterOpening,
          openedAt: _alreadyOpened ? DateTime.now() : null,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = '${_expiryDate.day}.${_expiryDate.month}.${_expiryDate.year}';

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
          Text('Neuer Vorratsartikel', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          if (!_customName) ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final preset in _presets)
                  ChoiceChip(
                    avatar: Icon(preset.icon, size: 18),
                    label: Text(preset.name),
                    selected: _selectedPreset == preset,
                    onSelected: (_) => setState(() => _selectedPreset = preset),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: () => setState(() => _customName = true),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Eigenes Produkt eingeben'),
            ),
          ] else ...[
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Produktname'),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mindesthaltbarkeitsdatum'),
            subtitle: Text(dateLabel),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickExpiryDate,
          ),
          if (_selectedPreset?.daysGoodAfterOpening != null)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Bereits geöffnet'),
              subtitle: Text('Hält dann ${_selectedPreset!.daysGoodAfterOpening} Tage ab heute'),
              value: _alreadyOpened,
              onChanged: (v) => setState(() => _alreadyOpened = v),
            ),
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
      ),
    );
  }
}
