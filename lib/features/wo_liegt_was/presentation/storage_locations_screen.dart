import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/image_storage.dart';
import '../application/storage_location_providers.dart';

class StorageLocationsScreen extends ConsumerStatefulWidget {
  const StorageLocationsScreen({super.key});

  @override
  ConsumerState<StorageLocationsScreen> createState() => _StorageLocationsScreenState();
}

class _StorageLocationsScreenState extends ConsumerState<StorageLocationsScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(storageLocationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wo liegt was?')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Gegenstand suchen …',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => _filter = v.trim().toLowerCase()),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: itemsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Fehler: $err')),
                data: (items) {
                  final filtered = _filter.isEmpty
                      ? items
                      : items.where((i) => i.itemName.toLowerCase().contains(_filter)).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        items.isEmpty ? 'Noch nichts erfasst.' : 'Nichts gefunden.',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Card(
                        child: ListTile(
                          leading: item.photoPath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                                  child: Image.file(
                                    File(item.photoPath!),
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const CircleAvatar(
                                  backgroundColor: AppColors.accentBg,
                                  child: Icon(Icons.inventory_2_outlined, color: AppColors.accent, size: 18),
                                ),
                          title: Text(item.itemName),
                          subtitle: Text(
                            item.notes == null ? item.location : '${item.location} · ${item.notes}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () =>
                                ref.read(storageLocationRepositoryProvider).delete(item.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final itemController = TextEditingController();
    final locationController = TextEditingController();
    final notesController = TextEditingController();
    String? photoPath;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Neue Zuordnung'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (photoPath != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                      child: Image.file(File(photoPath!), height: 100),
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final path = await pickAndPersistImage();
                    if (path != null) setDialogState(() => photoPath = path);
                  },
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: Text(photoPath == null ? 'Foto hinzufügen (optional)' : 'Foto ändern'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: itemController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Gegenstand'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Ort', hintText: 'z.B. "Schublade Flur"'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notiz (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                if (itemController.text.trim().isEmpty || locationController.text.trim().isEmpty) {
                  return;
                }
                ref.read(storageLocationRepositoryProvider).create(
                      itemName: itemController.text.trim(),
                      location: locationController.text.trim(),
                      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                      photoPath: photoPath,
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
}
