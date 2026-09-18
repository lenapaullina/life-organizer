import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/household_task_providers.dart';

Future<void> showEditHouseholdTaskDialog(
  BuildContext context,
  WidgetRef ref,
  HouseholdTask task,
) {
  final nameController = TextEditingController(text: task.name);
  final intervalController = TextEditingController(text: task.intervalDays.toString());

  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Aufgabe bearbeiten'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: AppSpacing.md),
          // Zahlenfeld statt Slider – exakte Tage-Werte direkt
          // eintippbar statt über einen Regler zu treffen.
          TextField(
            controller: intervalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Alle wie viele Tage?'),
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
            final name = nameController.text.trim();
            final interval = int.tryParse(intervalController.text.trim());
            if (name.isEmpty || interval == null || interval < 1) return;
            ref.read(householdTaskRepositoryProvider).updateTask(
                  id: task.id,
                  name: name,
                  intervalDays: interval,
                );
            Navigator.pop(dialogContext);
          },
          child: const Text('Speichern'),
        ),
      ],
    ),
  );
}
