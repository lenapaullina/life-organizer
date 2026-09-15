import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/status_calculator.dart' show TaskStatus;
import '../../../shared/widgets/simple_progress_bar.dart';
import '../../../shared/widgets/status_pill.dart';
import '../application/appointment_with_status.dart';
import '../application/gesundheit_providers.dart';
import 'add_appointment_sheet.dart';
import 'add_medication_sheet.dart';
import 'appointment_detail_screen.dart';
import '../../../core/database/database.dart';

class GesundheitScreen extends StatelessWidget {
  const GesundheitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gesundheit'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Termine'), Tab(text: 'Medikamente')],
          ),
        ),
        body: const TabBarView(
          children: [_AppointmentsTab(), _MedicationsTab()],
        ),
      ),
    );
  }
}

class _AppointmentsTab extends ConsumerWidget {
  const _AppointmentsTab();

  String _statusLabel(TaskStatus status) => switch (status) {
        TaskStatus.green => 'Im Plan',
        TaskStatus.yellow => 'Bald fällig',
        TaskStatus.red => 'Überfällig',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(sortedAppointmentsProvider);

    return Scaffold(
      body: appointmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (appointments) {
          if (appointments.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Noch keine Termine angelegt.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final entry = appointments[index];
              final appointment = entry.appointment;
              final status = entry.intervalStatus;
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AppointmentDetailScreen(
                        appointmentId: appointment.id,
                        appointmentName: appointment.name,
                        initialNotes: appointment.notes,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(appointment.name, style: Theme.of(context).textTheme.titleMedium),
                            ),
                            StatusPill(status: status.status, label: _statusLabel(status.status)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          status.daysSinceCompleted == null
                              ? 'Noch nie wahrgenommen · alle ${appointment.intervalDays} Tage'
                              : 'Zuletzt vor ${status.daysSinceCompleted} Tagen · alle ${appointment.intervalDays} Tage',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => showAddAppointmentSheet(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _MedicationsTab extends ConsumerWidget {
  const _MedicationsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsAsync = ref.watch(medicationsProvider);

    return Scaffold(
      body: medicationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (medications) {
          if (medications.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Noch keine Medikamente angelegt.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: medications.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => _MedicationCard(medication: medications[index]),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => showAddMedicationSheet(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _MedicationCard extends ConsumerWidget {
  final Medication medication;

  const _MedicationCard({required this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intakeAsync = ref.watch(todayIntakeProvider(medication.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: intakeAsync.when(
          loading: () => const SizedBox(height: 40),
          error: (err, _) => Text('Fehler: $err'),
          data: (log) {
            final taken = log?.takenCount ?? 0;
            final total = medication.timesPerDay;
            final progress = total == 0 ? 0.0 : taken / total;
            final done = taken >= total;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(medication.name, style: Theme.of(context).textTheme.titleMedium),
                    ),
                    Text('$taken / $total heute'),
                  ],
                ),
                if (medication.dosageNote != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(medication.dosageNote!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
                const SizedBox(height: AppSpacing.sm),
                SimpleProgressBar(
                  progress: progress,
                  color: done ? AppColors.statusGreen : AppColors.accent,
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: done
                        ? null
                        : () => ref
                            .read(medicationRepositoryProvider)
                            .logIntake(medication.id, maxPerDay: total),
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(done ? 'Heute erledigt' : 'Genommen'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
