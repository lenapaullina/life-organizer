import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/status_calculator.dart' show TaskStatus;
import '../../../shared/widgets/status_pill.dart';
import '../application/contact_providers.dart';
import '../application/contact_with_status.dart';
import 'add_contact_sheet.dart';
import 'contact_detail_screen.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(sortedContactsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lenas Grüne Seiten')),
      body: contactsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Noch keine Kontakte angelegt.\nTippe auf + um loszulegen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: contacts.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => _ContactCard(entry: contacts[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddContactSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ContactCard extends ConsumerWidget {
  final ContactWithStatus entry;

  const _ContactCard({required this.entry});

  String _statusLabel(TaskStatus status) => switch (status) {
        TaskStatus.green => 'Kürzlich',
        TaskStatus.yellow => 'Bald melden',
        TaskStatus.red => 'Überfällig',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = entry.contact;
    final status = entry.intervalStatus;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ContactDetailScreen(contactId: contact.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.accentBg,
                    backgroundImage:
                        contact.photoPath != null ? FileImage(File(contact.photoPath!)) : null,
                    child: contact.photoPath == null
                        ? const Icon(Icons.person_outline, color: AppColors.accent, size: 18)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(contact.name, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  if (status != null)
                    StatusPill(status: status.status, label: _statusLabel(status.status)),
                ],
              ),
              if (status != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  status.daysSinceCompleted == null
                      ? 'Noch nicht kontaktiert · alle ${contact.reminderIntervalDays} Tage'
                      : 'Zuletzt vor ${status.daysSinceCompleted} Tagen · alle ${contact.reminderIntervalDays} Tage',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () =>
                        ref.read(contactRepositoryProvider).markContactedNow(contact.id),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Jetzt kontaktiert'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
