import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../application/gesundheit_providers.dart';

class _AppointmentPreset {
  final String name;
  final int intervalDays;
  final IconData icon;
  const _AppointmentPreset(this.name, this.intervalDays, this.icon);
}

const _presets = [
  _AppointmentPreset('Zahnarzt', 180, Icons.sentiment_satisfied_outlined),
  _AppointmentPreset('Hausarzt-Check', 365, Icons.medical_services_outlined),
  _AppointmentPreset('Augenarzt', 730, Icons.remove_red_eye_outlined),
  _AppointmentPreset('Vorsorgeuntersuchung', 365, Icons.favorite_border),
];

Future<void> showAddAppointmentSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddAppointmentSheet(),
  );
}

class _AddAppointmentSheet extends ConsumerStatefulWidget {
  const _AddAppointmentSheet();

  @override
  ConsumerState<_AddAppointmentSheet> createState() => _AddAppointmentSheetState();
}

class _AddAppointmentSheetState extends ConsumerState<_AddAppointmentSheet> {
  bool _customName = false;
  final _nameController = TextEditingController();
  final _institutionController = TextEditingController();
  final _addressController = TextEditingController();
  int _intervalDays = 365;

  Future<void> _createFromPreset(_AppointmentPreset preset) async {
    await ref.read(appointmentRepositoryProvider).createAppointment(
          name: preset.name,
          intervalDays: preset.intervalDays,
        );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _createCustom() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    await ref.read(appointmentRepositoryProvider).createAppointment(
          name: name,
          intervalDays: _intervalDays,
          institution: _institutionController.text.trim().isEmpty ? null : _institutionController.text.trim(),
          address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
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
          Text('Neuer Termin', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          if (!_customName) ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final preset in _presets)
                  ActionChip(
                    avatar: Icon(preset.icon, size: 18),
                    label: Text(preset.name),
                    onPressed: () => _createFromPreset(preset),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: () => setState(() => _customName = true),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Eigenen Termin eingeben'),
            ),
          ] else ...[
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name des Termins'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _institutionController,
              decoration: const InputDecoration(labelText: 'Einrichtung (optional)', hintText: 'z.B. "Praxis Dr. Müller"'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Adresse (optional)'),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Text('Alle'),
                Expanded(
                  child: Slider(
                    value: _intervalDays.toDouble(),
                    min: 30,
                    max: 730,
                    divisions: 70,
                    label: '$_intervalDays Tage',
                    onChanged: (v) => setState(() => _intervalDays = v.round()),
                  ),
                ),
                Text('$_intervalDays Tage'),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton(onPressed: _createCustom, child: const Text('Anlegen')),
          ],
        ],
      ),
      ),
    );
  }
}
