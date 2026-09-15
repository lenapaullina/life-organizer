import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/tables/routines.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/routine_providers.dart';

class _RoutinePreset {
  final String name;
  final String type;
  final List<String> items;
  final IconData icon;
  const _RoutinePreset(this.name, this.type, this.items, this.icon);
}

const _presets = [
  _RoutinePreset(
    'Morgenroutine',
    RoutineTypes.morning,
    ['Zähne putzen', 'Anziehen', 'Frühstücken', 'Medikamente nehmen'],
    Icons.wb_sunny_outlined,
  ),
  _RoutinePreset(
    'Abendroutine',
    RoutineTypes.evening,
    ['Zähne putzen', 'Wecker stellen', 'Sachen für morgen bereitlegen'],
    Icons.nights_stay_outlined,
  ),
];

Future<void> showAddRoutineSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddRoutineSheet(),
  );
}

class _AddRoutineSheet extends ConsumerStatefulWidget {
  const _AddRoutineSheet();

  @override
  ConsumerState<_AddRoutineSheet> createState() => _AddRoutineSheetState();
}

class _AddRoutineSheetState extends ConsumerState<_AddRoutineSheet> {
  bool _showCustomForm = false;
  final _nameController = TextEditingController();
  final _itemsController = TextEditingController();

  Future<void> _createFromPreset(_RoutinePreset preset) async {
    await ref.read(routineRepositoryProvider).createRoutine(
          name: preset.name,
          type: preset.type,
          itemTexts: preset.items,
        );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _createCustom() async {
    final name = _nameController.text.trim();
    final items = _itemsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (name.isEmpty || items.isEmpty) return;

    await ref.read(routineRepositoryProvider).createRoutine(
          name: name,
          type: RoutineTypes.custom,
          itemTexts: items,
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
          Text('Neue Routine', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          if (!_showCustomForm) ...[
            for (final preset in _presets)
              Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: Icon(preset.icon),
                  title: Text(preset.name),
                  subtitle: Text(preset.items.join(' · ')),
                  onTap: () => _createFromPreset(preset),
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: () => setState(() => _showCustomForm = true),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Eigene Routine erstellen'),
            ),
          ] else ...[
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name der Routine'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _itemsController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Checklisten-Punkte',
                helperText: 'Ein Punkt pro Zeile',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: _createCustom,
              child: const Text('Routine anlegen'),
            ),
          ],
        ],
      ),
      ),
    );
  }
}
