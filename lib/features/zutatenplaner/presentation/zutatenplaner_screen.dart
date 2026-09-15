import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../brain_dump/application/brain_dump_providers.dart';
import '../../vorrat/application/pantry_providers.dart';

/// Vereinfachte Version: prüft nur, ob ein Vorratsartikel mit
/// passendem/ähnlichem Namen vorhanden ist – KEINE Mengen-Rechnung,
/// da PantryItems aktuell keine Mengenangabe speichert. "Genug da"
/// bedeutet hier "der Gegenstand ist überhaupt im Vorrat erfasst".
class ZutatenplanerScreen extends ConsumerStatefulWidget {
  const ZutatenplanerScreen({super.key});

  @override
  ConsumerState<ZutatenplanerScreen> createState() => _ZutatenplanerScreenState();
}

class _ZutatenplanerScreenState extends ConsumerState<ZutatenplanerScreen> {
  final _controller = TextEditingController();
  List<String>? _missing;
  List<String>? _available;

  void _check() {
    final pantryItems = ref.read(sortedPantryItemsProvider).valueOrNull ?? [];
    final pantryNames = pantryItems.map((p) => p.item.name.toLowerCase().trim()).toSet();

    final needed = _controller.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final missing = <String>[];
    final available = <String>[];
    for (final ingredient in needed) {
      final has = pantryNames.any(
        (p) => p.contains(ingredient.toLowerCase()) || ingredient.toLowerCase().contains(p),
      );
      (has ? available : missing).add(ingredient);
    }

    setState(() {
      _missing = missing;
      _available = available;
    });
  }

  Future<void> _createNote() async {
    if (_missing == null || _missing!.isEmpty) return;
    final text = 'Einkaufen: ${_missing!.join(', ')}';
    await ref.read(brainDumpRepositoryProvider).add(text, category: 'Aufgabe', priority: 1);
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Notiz mit fehlenden Zutaten erstellt 📝'),
            duration: Duration(seconds: 3),
          ),
        );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zutatenplaner')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welche Zutaten brauchst du? (1 pro Zeile)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Mehl\nEier\nMilch\n...',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton(onPressed: _check, child: const Text('Abgleichen')),
            const SizedBox(height: AppSpacing.md),
            if (_available != null && _available!.isNotEmpty) ...[
              const Text('✅ Schon da', style: TextStyle(fontWeight: FontWeight.w600)),
              Wrap(
                spacing: AppSpacing.xs,
                children: _available!.map((a) => Chip(label: Text(a))).toList(),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (_missing != null) ...[
              Text(
                _missing!.isEmpty ? '🎉 Alles vorhanden!' : '🛒 Fehlt noch',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (_missing!.isNotEmpty) ...[
                Wrap(
                  spacing: AppSpacing.xs,
                  children: _missing!
                      .map((m) => Chip(
                            label: Text(m),
                            backgroundColor: AppColors.statusYellowBg,
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.sm),
                ElevatedButton.icon(
                  onPressed: _createNote,
                  icon: const Icon(Icons.note_add_outlined),
                  label: const Text('Notiz mit fehlenden Zutaten erstellen'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
