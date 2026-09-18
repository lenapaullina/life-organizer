import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/name_autocomplete_field.dart';
import '../application/pantry_extra_providers.dart';
import '../application/pantry_providers.dart';
import '../application/pantry_template_providers.dart';
import '../domain/pantry_template.dart';

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
  String _name = '';
  final _quantityController = TextEditingController();
  final _cycleController = TextEditingController();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));
  bool _alreadyOpened = false;
  bool _saveAsTemplate = false;
  int? _daysGoodAfterOpeningOverride;

  @override
  void dispose() {
    _quantityController.dispose();
    _cycleController.dispose();
    super.dispose();
  }

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

  /// Übernimmt die Werte einer angetippten Vorlage (Autocomplete oder
  /// gespeicherte Vorlage) automatisch als Vorbefüllung.
  void _applyTemplate(PantryTemplate template) {
    setState(() {
      _daysGoodAfterOpeningOverride = template.daysGoodAfterOpening;
      _cycleController.text = template.cycleDays?.toString() ?? '';
    });
  }

  int? get _cycleDays {
    final text = _cycleController.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  Future<void> _submit() async {
    final name = _customName ? _name.trim() : _selectedPreset?.name;
    if (name == null || name.isEmpty) return;

    final daysGoodAfterOpening =
        _daysGoodAfterOpeningOverride ?? _selectedPreset?.daysGoodAfterOpening;

    final createdId = await ref.read(pantryRepositoryProvider).createItemReturningId(
          name: name,
          expiryDate: _expiryDate,
          daysGoodAfterOpening: daysGoodAfterOpening,
          openedAt: _alreadyOpened ? DateTime.now() : null,
        );

    await ref.read(pantryExtraProvider.notifier).setExtra(
          createdId,
          quantity: _quantityController.text,
          cycleDays: _cycleDays,
        );

    if (_customName && _saveAsTemplate) {
      await ref.read(pantryTemplateProvider.notifier).saveTemplate(
            name: name,
            daysGoodAfterOpening: daysGoodAfterOpening,
            cycleDays: _cycleDays,
          );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = '${_expiryDate.day}.${_expiryDate.month}.${_expiryDate.year}';
    final templates = ref.watch(pantryTemplateProvider).valueOrNull ?? const [];
    final suggestionNames = {
      for (final p in _presets) p.name,
      for (final t in templates) t.name,
    }.toList()
      ..sort();
    final templateByName = {for (final t in templates) t.name: t};

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
            // Freitext mit Autovervollständigung: schlägt sowohl die
            // festen Presets als auch selbst gespeicherte Vorlagen vor,
            // freies Tippen bleibt aber jederzeit möglich.
            NameAutocompleteField(
              label: 'Produktname',
              suggestions: suggestionNames,
              onChanged: (value) => setState(() => _name = value),
              onSuggestionSelected: (value) {
                final template = templateByName[value];
                if (template != null) _applyTemplate(template);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Als Vorlage speichern'),
              subtitle: const Text('Dann beim nächsten Mal per Autovervollständigung wählbar'),
              value: _saveAsTemplate,
              onChanged: (v) => setState(() => _saveAsTemplate = v ?? false),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Menge (optional)',
              hintText: 'z. B. 2 Stück, 1L, 500g',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mindesthaltbarkeitsdatum'),
            subtitle: Text(dateLabel),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickExpiryDate,
          ),
          const SizedBox(height: AppSpacing.md),
          // Zyklus/Intervall als Zahlenfeld statt Slider – exakte
          // Werte lassen sich so viel schneller eintippen.
          TextField(
            controller: _cycleController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nachkauf-Zyklus in Tagen (optional)',
              hintText: 'z. B. 14',
            ),
          ),
          if ((_daysGoodAfterOpeningOverride ?? _selectedPreset?.daysGoodAfterOpening) != null)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Bereits geöffnet'),
              subtitle: Text(
                  'Hält dann ${_daysGoodAfterOpeningOverride ?? _selectedPreset!.daysGoodAfterOpening} Tage ab heute'),
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
