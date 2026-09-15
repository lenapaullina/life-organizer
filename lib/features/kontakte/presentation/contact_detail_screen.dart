import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/image_storage.dart';
import '../application/contact_providers.dart';

class ContactDetailScreen extends ConsumerStatefulWidget {
  final String contactId;

  const ContactDetailScreen({super.key, required this.contactId});

  @override
  ConsumerState<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ContactDetailScreen> {
  final _notesController = TextEditingController();
  final _notesFocus = FocusNode();
  String? _loadedNotes; // um den Controller nur einmal mit DB-Daten zu füllen

  @override
  void initState() {
    super.initState();
    // Notizen werden beim Verlassen des Feldes automatisch gespeichert,
    // kein separater "Speichern"-Klick nötig -> Low Friction.
    _notesFocus.addListener(() {
      if (!_notesFocus.hasFocus) {
        ref.read(contactRepositoryProvider).updateNotes(
              widget.contactId,
              _notesController.text,
            );
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kontakt löschen?'),
        content: const Text('Das kann nicht rückgängig gemacht werden.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Löschen')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(contactRepositoryProvider).deleteContact(widget.contactId);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactAsync = ref.watch(contactDetailProvider(widget.contactId));

    return contactAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Fehler: $err'))),
      data: (contact) {
        if (contact == null) {
          return const Scaffold(body: Center(child: Text('Kontakt wurde gelöscht.')));
        }

        // Controller nur einmal initial befüllen, sonst überschreibt
        // jeder DB-Stream-Tick die laufende Eingabe des Nutzers.
        if (_loadedNotes == null) {
          _loadedNotes = contact.notes ?? '';
          _notesController.text = _loadedNotes!;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(contact.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final path = await pickAndPersistImage();
                      if (path != null) {
                        ref.read(contactRepositoryProvider).updatePhoto(contact.id, path);
                      }
                    },
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.accentBg,
                      backgroundImage: contact.photoPath != null ? FileImage(File(contact.photoPath!)) : null,
                      child: contact.photoPath == null
                          ? const Icon(Icons.add_a_photo_outlined, color: AppColors.accent, size: 28)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (contact.birthday != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(
                      'Geburtstag: ${contact.birthday!.day}.${contact.birthday!.month}.${contact.birthday!.year}',
                    ),
                  ),
                if (contact.reminderIntervalDays != null) ...[
                  ElevatedButton.icon(
                    onPressed: () =>
                        ref.read(contactRepositoryProvider).markContactedNow(contact.id),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Jetzt kontaktiert'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Text('Notizen', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _notesController,
                  focusNode: _notesFocus,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Vorlieben, wichtige Infos, letzte Gespräche ...',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
