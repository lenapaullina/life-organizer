import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assets/cow_asset_registry.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/cow_pasture_providers.dart';
import '../domain/cow.dart';
import '../domain/cow_accessory.dart';

/// Öffnet das Kuh-Profil als Bottom-Sheet (siehe [CowProfileModal]).
Future<void> showCowProfileModal(BuildContext context, String cowId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => CowProfileModal(cowId: cowId),
  );
}

/// Detailansicht einer einzelnen Kuh: große Charakterkarte, editierbarer
/// Name, Entstehungsdatum/Ursprungs-Task, ausrüstbare Accessoires und
/// ein (noch nicht mit echtem Audio verdrahtetes) Sprachmemo-Feld.
class CowProfileModal extends ConsumerStatefulWidget {
  final String cowId;
  const CowProfileModal({super.key, required this.cowId});

  @override
  ConsumerState<CowProfileModal> createState() => _CowProfileModalState();
}

class _CowProfileModalState extends ConsumerState<CowProfileModal> {
  late final TextEditingController _nameController;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    // Bewusster, ehrlicher Scoping-Hinweis: `audioplayers` (jetzt in
    // pubspec.yaml) kann fertige Sound-Dateien ABSPIELEN (siehe
    // maybePlaySound in app_settings_providers.dart) – für eine
    // eigene MIKROFON-AUFNAHME bräuchte es zusätzlich ein Recorder-
    // Package (z. B. `record`) inkl. Mikrofon-Berechtigungen, das noch
    // nicht eingebunden ist. Die UI ist vorbereitet, damit später nur
    // noch die Hook-Funktion hier ausgetauscht werden muss.
    setState(() => _isRecording = !_isRecording);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRecording
              ? 'Aufnahme gestartet (Vorschau – noch ohne echtes Audio-Paket).'
              : 'Aufnahme gestoppt (wird noch nicht gespeichert).',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pastureAsync = ref.watch(cowPastureProvider);
    final notifier = ref.read(cowPastureProvider.notifier);

    return pastureAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => SizedBox(
        height: 200,
        child: Center(child: Text('Fehler: $err')),
      ),
      data: (pasture) {
        final cow = pasture.cows.where((c) => c.id == widget.cowId).firstOrNull;
        if (cow == null) {
          return const SizedBox(
            height: 120,
            child: Center(child: Text('Diese Kuh gibt es nicht mehr.')),
          );
        }
        if (_nameController.text.isEmpty && cow.customName != null) {
          _nameController.text = cow.customName!;
        }

        final ownedAccessories = cowAccessories
            .where((a) => pasture.isItemUnlocked(a.id, a.price))
            .toList();

        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Center(
                  child: SafeAssetImage(
                    assetPath: cow.characterType.cardAssetPath,
                    height: 260,
                    fit: BoxFit.contain,
                    placeholderIcon: Icons.grass_outlined,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: cow.characterType.displayName,
                        ),
                        onSubmitted: (value) => notifier.renameCow(cow.id, value),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: const Icon(Icons.check),
                      tooltip: 'Namen speichern',
                      onPressed: () => notifier.renameCow(cow.id, _nameController.text),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _InfoRow(label: 'Charakter', value: cow.characterType.displayName),
                _InfoRow(label: 'Level', value: '${cow.level}'),
                _InfoRow(label: 'Entstanden', value: _formatDate(cow.createdAt)),
                _InfoRow(label: 'Ursprung', value: cow.originLabel ?? 'Unbekannt'),
                const SizedBox(height: AppSpacing.lg),
                Text('Sprachmemo ("Muh")', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Eigene Aufnahme/Wiedergabe kommt noch (getrennt von den '
                  'Sound-Effekten in den Einstellungen, die bereits echtes Audio abspielen) '
                  '– hier tut sich aktuell noch nichts Hörbares.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    // Expanded statt der Buttons direkt in der Row: siehe
                    // README-Eintrag zum Layout-Crash bei ElevatedButton/
                    // OutlinedButton in einer Row (unendliche Mindestbreite
                    // aus dem Button-Theme) – exakt dasselbe Muster war
                    // hier die Ursache für den schwarzen Profil-Screen.
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _toggleRecording,
                        icon: Icon(_isRecording ? Icons.stop_circle_outlined : Icons.mic_none),
                        label: Text(_isRecording ? 'Stopp' : 'Aufnehmen'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Noch kein Memo aufgenommen.')),
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Abspielen'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Accessoires', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                if (ownedAccessories.isEmpty)
                  const Text(
                    'Noch keine Accessoires freigeschaltet – im Milch-Shop erhältlich.',
                    style: TextStyle(fontSize: 13),
                  )
                else
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final item in ownedAccessories)
                        FilterChip(
                          avatar: SafeAssetImage(assetPath: item.assetPath, width: 20, height: 20),
                          label: Text(item.name),
                          selected: cow.equippedAccessoryIds.contains(item.id),
                          onSelected: (_) => notifier.toggleAccessory(cow.id, item.id),
                        ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.lg),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
