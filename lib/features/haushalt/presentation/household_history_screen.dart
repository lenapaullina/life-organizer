import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/household_task_providers.dart';

class HouseholdHistoryScreen extends ConsumerWidget {
  const HouseholdHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(householdHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historie')),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Text('Noch nichts erledigt.', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final e = entries[index];
              return ListTile(
                leading: const Icon(Icons.check_circle_outline, color: AppColors.statusGreen),
                title: Text(e.taskName),
                subtitle: Text(
                  '${e.completedAt.day}.${e.completedAt.month}.${e.completedAt.year} · '
                  '${e.completedAt.hour.toString().padLeft(2, '0')}:${e.completedAt.minute.toString().padLeft(2, '0')} Uhr',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
