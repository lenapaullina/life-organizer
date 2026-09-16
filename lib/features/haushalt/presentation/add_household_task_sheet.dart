import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../application/household_task_providers.dart';

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

class _AddHouseholdTaskSheet extends ConsumerStatefulWidget {
  const _AddHouseholdTaskSheet();

  @override
  ConsumerState<_AddHouseholdTaskSheet> createState() => _AddHouseholdTaskSheetState();
}

class _AddHouseholdTaskSheetState extends ConsumerState<_AddHouseholdTaskSheet> {
  bool _showCustomForm = false;
  final _nameController = TextEditingController();
  int _customInterval = 7;

  Future<void> _createFromPreset(_TaskPreset preset) async {
    await ref.read(householdTaskRepositoryProvider).createTask(
          name: preset.name,
          intervalDays: preset.intervalDays,
        );
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _createCustom() async {
    if (_nameController.text.trim().isEmpty) return;
    await ref.read(householdTaskRepositoryProvider).createTask(
          name: _nameController.text.trim(),
          intervalDays: _customInterval,
        );
    if (mounted) Navigator.of(context).pop(true);
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
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name der Aufgabe'),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Text('Alle'),
                Expanded(
                  child: Slider(
                    value: _customInterval.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59,
                    label: '$_customInterval Tage',
                    onChanged: (v) => setState(() => _customInterval = v.round()),
                  ),
                ),
                Text('$_customInterval Tage'),
              ],
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
