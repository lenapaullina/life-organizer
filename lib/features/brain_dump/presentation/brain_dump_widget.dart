import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/brain_dump_providers.dart';

const _categories = ['Idee', 'Erinnerung', 'Aufgabe', 'Sonstiges'];
const _priorityLabels = ['niedrig', 'mittel', 'hoch'];

Color priorityColor(int priority) => switch (priority) {
      0 => AppColors.statusGreen,
      2 => AppColors.statusRed,
      _ => AppColors.statusYellow,
    };

/// Eingabe ist immer sichtbar, jetzt mit mehr Platz (mehrzeilig) und
/// optionaler Kategorie/Priorität – beides mit sinnvollem Default,
/// damit man trotzdem einfach nur tippen und abschicken kann.
class BrainDumpCapture extends ConsumerStatefulWidget {
  const BrainDumpCapture({super.key});

  @override
  ConsumerState<BrainDumpCapture> createState() => _BrainDumpCaptureState();
}

class _BrainDumpCaptureState extends ConsumerState<BrainDumpCapture> {
  final _controller = TextEditingController();
  String? _category;
  int _priority = 1;

  // "Brain Dump" Audio-Notiz: spricht direkt in dasselbe Textfeld,
  // damit danach alles (Kategorie/Priorität wählen, abschicken) genau
  // wie beim Eintippen weitergeht – keine separate Audio-Ablage.
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _textBeforeListening = '';

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if ((status == 'done' || status == 'notListening') && mounted) {
          setState(() => _isListening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _isListening = false);
      },
    );

    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Spracherkennung nicht verfügbar – Mikrofon-Berechtigung erteilt?'),
          ),
        );
      }
      return;
    }

    _textBeforeListening = _controller.text;
    setState(() => _isListening = true);

    await _speech.listen(
      localeId: 'de_DE',
      onResult: (result) {
        final separator = _textBeforeListening.trim().isEmpty ? '' : ' ';
        final newText = '$_textBeforeListening$separator${result.recognizedWords}';
        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      },
    );
  }

  Future<void> _submit() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    await ref.read(brainDumpRepositoryProvider).add(text, category: _category, priority: _priority);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          minLines: 2,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Kurz notieren, bevor du es vergisst …',
            filled: true,
            fillColor: AppColors.surfaceMuted,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final c in _categories)
              ChoiceChip(
                label: Text(c),
                selected: _category == c,
                onSelected: (selected) => setState(() => _category = selected ? c : null),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            const Text('Priorität:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(width: AppSpacing.sm),
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: ChoiceChip(
                  label: Text(_priorityLabels[i]),
                  selected: _priority == i,
                  selectedColor: priorityColor(i).withOpacity(0.25),
                  onSelected: (_) => setState(() => _priority = i),
                ),
              ),
            const Spacer(),
            IconButton(
              onPressed: _toggleListening,
              tooltip: _isListening ? 'Aufnahme stoppen' : 'Per Sprache eintippen',
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none_outlined,
                color: _isListening ? AppColors.statusRed : null,
              ),
            ),
            IconButton.filled(onPressed: _submit, icon: const Icon(Icons.arrow_upward)),
          ],
        ),
      ],
    );
  }
}

/// Liste der offenen Gedanken: angeheftet zuerst, dann nach Priorität.
class BrainDumpList extends ConsumerWidget {
  const BrainDumpList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(openBrainDumpEntriesProvider);

    return entriesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (err, _) => Text('Fehler: $err'),
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Notizen (${entries.length})', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...entries.map(
              (e) => Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    onPressed: () => ref.read(brainDumpRepositoryProvider).markDone(e.id),
                  ),
                  title: Text(e.content),
                  subtitle: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: priorityColor(e.priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (e.category != null) Text('${e.category} ', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          e.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                          size: 20,
                          color: e.pinned ? AppColors.accent : null,
                        ),
                        onPressed: () =>
                            ref.read(brainDumpRepositoryProvider).setPinned(e.id, !e.pinned),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () => ref.read(brainDumpRepositoryProvider).delete(e.id),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
