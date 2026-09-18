import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/name_autocomplete_field.dart';
import '../application/household_task_providers.dart';
import '../application/household_task_template_providers.dart';
import '../domain/household_task_template.dart';

/// Feste Presets für häufige Haushaltsaufgaben. Ein Tap reicht,
/// um eine Aufgabe anzulegen – Freitext ist nur der Fallback für
/// alles, was nicht in der Liste steht. Das ist der Kern von
/// "Low Friction": die häufigsten Fälle brauchen null Tipparbeit.
class _TaskPreset {
  final String name;
  final int intervalDays;
  final IconData icon;
  const _TaskPreset(this.name, this.intervalDays, this.icon);
}

const _presets = [
  _TaskPreset('Bad putzen', 7, Icons.bathtub_outlined),
  _TaskPreset('Staubsaugen', 4, Icons.cleaning_services_outlined),
  _TaskPreset('Küche wischen', 3, Icons.countertops_outlined),
  _TaskPreset('Wäsche waschen', 5, Icons.local_laundry_service_outlined),
  _TaskPreset('Bettwäsche wechseln', 14, Icons.bed_outlined),
  _TaskPreset('Müll rausbringen', 3, Icons.delete_outline),
  _TaskPreset('Pflanzen gießen', 7, Icons.local_florist_outlined),
  _TaskPreset('Fenster putzen', 30, Icons.window_outlined),
];

/// Öffnet den Anlege-Dialog als Bottom Sheet (schneller erreichbar
/// als ein Vollbild-Dialog, Daumen-freundlich auf dem Handy).
///
/// Gibt `true` zurück, wenn tatsächlich eine Aufgabe angelegt wurde
/// (Preset getippt oder eigene Aufgabe gespeichert) – die aufrufende
/// Stelle nutzt das für die kurze Bestätigung ("Aufgabe hinzugefügt").
/// Wird das Sheet nur weggewischt/abgebrochen, kommt `null`/`false`
/// zurück und es gibt keine Bestätigung.
Future<bool?> showAddHouseholdTaskSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddHouseholdTaskSheet(),
  );
}

class _AddHouseholdTaskSheetState extends ConsumerState<_AddHouseholdTaskSheet> {
  bool _showCustomForm = false;
  String _name = '';
  final _intervalController = TextEditingController(text: '7');
  bool _saveAsTemplate = false;

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }

  int get _customInterval => int.tryParse(_intervalController.text.trim()) ?? 7;

  Future<void> _createFromPreset(_TaskPreset preset) async {
    await ref.read(householdTaskRepositoryProvider).createTask(
          name: preset.name,
          intervalDays: preset.intervalDays,
        );
    if (mounted) Navigator.of(context).pop(true);
  }

  void _applyTemplate(HouseholdTaskTemplate template) {
    setState(() => _intervalController.text = template.intervalDays.toString());
  }

  Future<void> _createCustom() async {
    final name = _name.trim();
    if (name.isEmpty) return;
    final interval = _customInterval;

    await ref.read(householdTaskRepositoryProvider).createTask(
          name: name,
          intervalDays: interval,
        );

    if (_saveAsTemplate) {
      await ref
          .read(householdTaskTemplateProvider.notifier)
          .saveTemplate(name: name, intervalDays: interval);
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(householdTaskTemplateProvider).valueOrNull ?? const [];
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
          Text('Neue Aufgabe', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          if (!_showCustomForm) ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final preset in _presets)
                  ActionChip(
                    avatar: Icon(preset.icon, size: 18),
                    label: Text('${preset.name} · ${preset.intervalDays}T'),
                    onPressed: () => _createFromPreset(preset),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: () => setState(() => _showCustomForm = true),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Eigene Aufgabe eingeben'),
            ),
          ] else ...[
            // Freitext mit Autovervollständigung aus Presets + selbst
            // gespeicherten Vorlagen.
            NameAutocompleteField(
              label: 'Name der Aufgabe',
              suggestions: suggestionNames,
              onChanged: (value) => _name = value,
              onSuggestionSelected: (value) {
                final template = templateByName[value];
                if (template != null) _applyTemplate(template);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            // Zahlenfeld statt Slider – exakte Tage-Werte direkt
            // eintippbar statt über einen Regler zu treffen.
            TextField(
              controller: _intervalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Alle wie viele Tage?'),
            ),
            const SizedBox(height: AppSpacing.sm),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Als Vorlage speichern'),
              value: _saveAsTemplate,
              onChanged: (v) => setState(() => _saveAsTemplate = v ?? false),
            ),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton(
              onPressed: _createCustom,
              child: const Text('Aufgabe anlegen'),
            ),
          ],
        ],
      ),
      ),
    );
  }
}

class _AddHouseholdTaskSheet extends ConsumerStatefulWidget {
  const _AddHouseholdTaskSheet();

  @override
  ConsumerState<_AddHouseholdTaskSheet> createState() => _AddHouseholdTaskSheetState();
}
