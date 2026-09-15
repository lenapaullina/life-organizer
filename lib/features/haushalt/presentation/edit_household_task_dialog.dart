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
  var interval = task.intervalDays;

  return showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
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
            Row(
              children: [
                const Text('Alle'),
                Expanded(
                  child: Slider(
                    value: interval.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59,
                    label: '$interval Tage',
                    onChanged: (v) => setState(() => interval = v.round()),
                  ),
                ),
                Text('$interval Tage'),
              ],
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
              if (name.isEmpty) return;
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
    ),
  );
}
