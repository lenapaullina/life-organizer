import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/gamification_providers.dart';

String _formatDay(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day.$month.';
}

/// "Dopamin-Speicher": erledigte Aufgaben verschwinden nicht einfach,
/// sondern bleiben hier nach Monat sortiert sichtbar – als Beleg
/// gegen das Gefühl, "nie irgendwas geschafft zu haben".
class SuccessLogbookScreen extends ConsumerWidget {
  const SuccessLogbookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logbookAsync = ref.watch(monthlyLogbookProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Erfolgs-Logbook')),
      body: logbookAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (months) {
          if (months.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Hier sammeln sich deine Erfolge, sobald du die erste\n'
                  'Aufgabe erledigst oder eine Routine komplett schaffst.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: months.length,
            itemBuilder: (context, index) {
              final month = months[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Das hast du im ${month.label} alles gerockt! 🎉',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${month.entries.length} ${month.entries.length == 1 ? "Erfolg" : "Erfolge"}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Card(
                      child: Column(
                        children: [
                          for (final entry in month.entries)
                            ListTile(
                              leading: Text(entry.emoji, style: const TextStyle(fontSize: 20)),
                              title: Text(entry.title),
                              trailing: Text(
                                _formatDay(entry.completedAt),
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
