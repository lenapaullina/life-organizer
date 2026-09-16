import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../application/cow_pasture_providers.dart';
import '../domain/cow.dart';

/// Interaktive Weide: Kühe erscheinen als Belohnung fürs Erledigen
/// von Aufgaben/Routinen (siehe household_screen.dart, routine_screen.dart).
/// Zwei gleich-levelige Kühe antippen (nacheinander auswählen) merged
/// sie zu einer stärkeren Kuh + Milch-Bonus – Tippen statt Drag&Drop,
/// weil das auf dem Handy zuverlässiger und barrierefreier ist als
/// Drag-Gesten, ohne die Merge-Mechanik selbst zu verändern.
class CowPastureScreen extends ConsumerStatefulWidget {
  const CowPastureScreen({super.key});

  @override
  ConsumerState<CowPastureScreen> createState() => _CowPastureScreenState();
}

class _CowPastureScreenState extends ConsumerState<CowPastureScreen> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    // Passive Milch seit dem letzten Besuch beim Öffnen gutschreiben.
    Future.microtask(() => ref.read(cowPastureProvider.notifier).collectPassiveIncome());
  }

  Future<void> _onTapCow(Cow cow) async {
    if (_selectedId == null) {
      setState(() => _selectedId = cow.id);
      return;
    }
    if (_selectedId == cow.id) {
      setState(() => _selectedId = null);
      return;
    }

    final notifier = ref.read(cowPastureProvider.notifier);
    final ok = await notifier.mergeCows(_selectedId!, cow.id);
    setState(() => _selectedId = null);

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Das geht nur mit zwei gleich-levligen Kühen.')),
      );
    } else if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kühe verschmolzen! ✨ Milch-Bonus gutgeschrieben.'), duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pastureAsync = ref.watch(cowPastureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kuh-Weide')),
      body: pastureAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (pasture) {
          final cowByPosition = {for (final c in pasture.cows) c.position: c};

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🥛', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: AppSpacing.xs),
                    Text('${pasture.milk} Kuh-Milch', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  pasture.cows.isEmpty
                      ? 'Noch keine Kühe – erledige Aufgaben, um welche zu bekommen.'
                      : 'Tippe zwei gleich-levelige Kühe nacheinander an, um sie zu verschmelzen.',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: GridView.builder(
                    itemCount: cowPastureGridSize,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                    ),
                    itemBuilder: (context, index) {
                      final cow = cowByPosition[index];
                      final selected = cow != null && cow.id == _selectedId;
                      return _PastureCell(cow: cow, selected: selected, onTap: cow == null ? null : () => _onTapCow(cow));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PastureCell extends StatelessWidget {
  final Cow? cow;
  final bool selected;
  final VoidCallback? onTap;

  const _PastureCell({required this.cow, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color?.withOpacity(0.6) ??
              Theme.of(context).colorScheme.surface.withOpacity(0.6),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            width: 3,
          ),
        ),
        alignment: Alignment.center,
        child: cow == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emojiForCowLevel(cow!.level), style: const TextStyle(fontSize: 26)),
                  Text('Lv. ${cow!.level}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
      ),
    );
  }
}
