import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

import '../../../core/assets/cow_asset_registry.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/voice_memo_storage.dart';
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
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    // Sobald die Wiedergabe von selbst zu Ende ist, den Button wieder
    // auf "Abspielen" zurücksetzen (statt dauerhaft "läuft" zu zeigen).
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    // Fire-and-forget: eine laufende Aufnahme/Wiedergabe beim Schließen
    // des Modals sauber beenden, ohne das Dispose selbst zu blockieren.
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording(Cow cow) async {
    if (_isRecording) {
      final path = await _recorder.stop();
      if (!mounted) return;
      setState(() => _isRecording = false);
      if (path != null) {
        await ref.read(cowPastureProvider.notifier).setVoiceMemoPath(cow.id, path);
      }
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ohne Mikrofon-Berechtigung kann nicht aufgenommen werden.')),
      );
      return;
    }

    try {
      final path = await newVoiceMemoPath();
      await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
      if (!mounted) return;
      setState(() => _isRecording = true);
    } catch (error) {
      // Fail-safe: ein Aufnahme-Fehler (z. B. kein Mikrofon vorhanden)
      // darf nie die App abstürzen lassen, nur die Aufnahme scheitern.
      if (kDebugMode) debugPrint('Aufnahme konnte nicht gestartet werden: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aufnahme konnte nicht gestartet werden.')),
      );
    }
  }

  Future<void> _togglePlayback(String memoPath) async {
    if (_isPlaying) {
      await _player.stop();
      if (mounted) setState(() => _isPlaying = false);
      return;
    }
    try {
      await _player.play(DeviceFileSource(memoPath));
      if (!mounted) return;
      setState(() => _isPlaying = true);
    } catch (error) {
      if (kDebugMode) debugPrint('Memo konnte nicht abgespielt werden: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memo konnte nicht abgespielt werden.')),
      );
    }
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
                Text(
                  cow.voiceMemoPath == null
                      ? 'Noch keine Aufnahme vorhanden.'
                      : 'Eine Aufnahme ist gespeichert – neu aufnehmen ersetzt sie.',
                  style: const TextStyle(fontSize: 12),
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
                        onPressed: () => _toggleRecording(cow),
                        icon: Icon(_isRecording ? Icons.stop_circle_outlined : Icons.mic_none),
                        label: Text(_isRecording ? 'Stopp' : 'Aufnehmen'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: cow.voiceMemoPath == null
                            ? () => ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Noch kein Memo aufgenommen.')),
                                )
                            : () => _togglePlayback(cow.voiceMemoPath!),
                        icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                        label: Text(_isPlaying ? 'Stopp' : 'Abspielen'),
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
