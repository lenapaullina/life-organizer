import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assets/cow_asset_registry.dart';
import '../../../core/theme/app_spacing.dart';
import '../../settings/application/app_settings_providers.dart';
import '../application/cow_pasture_providers.dart';
import '../domain/cow.dart';
import '../domain/cow_accessory.dart';
import 'cow_profile_modal.dart';
import 'pasture_background_widget.dart';

/// Interaktive Weide: Kühe erscheinen als Belohnung fürs Erledigen
/// von Aufgaben/Routinen (siehe household_screen.dart, routine_screen.dart).
///
/// Zwei Wege zum Mergen, bewusst beide angeboten:
/// - Ziehen (Draggable/DragTarget): während des Ziehens leuchten alle
///   Kühe mit demselben Level auf, alles andere wird leicht ausgegraut.
/// - Antippen (zwei Kühe nacheinander auswählen): als zuverlässigere
///   Alternative für alle, denen Drag-Gesten schwerfallen.
class CowPastureScreen extends ConsumerStatefulWidget {
  const CowPastureScreen({super.key});

  @override
  ConsumerState<CowPastureScreen> createState() => _CowPastureScreenState();
}

class _CowPastureScreenState extends ConsumerState<CowPastureScreen> {
  String? _selectedId;
  int? _draggingLevel;

  // "Moo-Loop": solange die Weide offen ist, meldet sich in
  // unregelmäßigen Abständen (8-15s) zufällig eine der stehenden Kühe
  // – mit ihrer eigenen Sprachmemo, falls vorhanden, sonst mit dem
  // Standard-Muh (siehe app_settings_providers.dart für die dort
  // verwendeten Sound-Assets). Eigener Player statt des globalen
  // Sound-Effekt-Players, damit ein laufendes Ambient-Muh nicht mit
  // einem Merge-/Task-Sound um denselben Player konkurriert.
  final _ambientPlayer = AudioPlayer();
  final _ambientRandom = Random();
  Timer? _ambientTimer;

  @override
  void initState() {
    super.initState();
    // Passive Milch seit dem letzten Besuch beim Öffnen gutschreiben.
    Future.microtask(() => ref.read(cowPastureProvider.notifier).collectPassiveIncome());
    _scheduleAmbientMoo();
  }

  void _scheduleAmbientMoo() {
    final delay = Duration(seconds: 8 + _ambientRandom.nextInt(8)); // 8-15s
    _ambientTimer = Timer(delay, _playAmbientMoo);
  }

  Future<void> _playAmbientMoo() async {
    if (!mounted) return;
    final soundEnabled = ref.read(appSettingsProvider).soundEnabled;
    final cows = ref.read(cowPastureProvider).valueOrNull?.cows ?? const <Cow>[];
    if (soundEnabled && cows.isNotEmpty) {
      final cow = cows[_ambientRandom.nextInt(cows.length)];
      try {
        // Eigene Sprachmemo bevorzugt, sonst Fallback auf den Standard-
        // Kuh-Sound – fire-and-forget mit Fehlerabfang wie überall bei
        // der Audiowiedergabe: ein Problem hier darf nie die Weide zum
        // Absturz bringen, im schlimmsten Fall bleibt es nur stumm.
        if (cow.voiceMemoPath != null) {
          await _ambientPlayer.play(DeviceFileSource(cow.voiceMemoPath!));
        } else {
          await _ambientPlayer.play(AssetSource('sounds/Mudchute_cow_1.ogg'));
        }
      } catch (error) {
        if (kDebugMode) debugPrint('Weiden-Loop-Sound fehlgeschlagen: $error');
      }
    }
    // Nächste Runde planen, unabhängig davon ob diesmal gespielt wurde
    // (z. B. Sound war aus oder keine Kuh vorhanden) – so springt der
    // Loop automatisch wieder an, sobald wieder Kühe da sind/Sound an ist.
    if (mounted) _scheduleAmbientMoo();
  }

  @override
  void dispose() {
    _ambientTimer?.cancel();
    _ambientPlayer.dispose();
    super.dispose();
  }

  Future<void> _merge(String idA, String idB) async {
    final notifier = ref.read(cowPastureProvider.notifier);
    final ok = await notifier.mergeCows(idA, idB);
    if (!mounted) return;

    if (ok) {
      hapticMerge();
      final soundEnabled = ref.read(appSettingsProvider).soundEnabled;
      maybePlaySound(soundEnabled, SoundEvent.merge);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kühe verschmolzen! ✨ Milch-Bonus gutgeschrieben.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Das geht nur mit zwei gleich-levligen Kühen.')),
      );
    }
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
    final otherId = _selectedId!;
    setState(() => _selectedId = null);
    await _merge(otherId, cow.id);
  }

  Future<void> _autoMerge() async {
    final count = await ref.read(cowPastureProvider.notifier).autoMergeAll();
    if (!mounted) return;
    if (count > 0) hapticMerge();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          count == 0 ? 'Nichts zum Zusammenführen gefunden.' : '$count Kühe automatisch gemerged! ✨',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pastureAsync = ref.watch(cowPastureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuh-Weide'),
        actions: [
          if (pastureAsync.valueOrNull?.hasAutoMerge == true)
            IconButton(
              icon: const Icon(Icons.auto_fix_high),
              tooltip: 'Sortieren & Mergen',
              onPressed: _autoMerge,
            ),
        ],
      ),
      body: pastureAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (pasture) {
          final cowByPosition = {for (final c in pasture.cows) c.position: c};
          final rate = passiveMilkPerMinute(pasture.cows);
          // Einmal pro Build nachschlagen statt in jeder Kachel neu: alle
          // Kacheln teilen sich dieselbe aktive Bodentextur.
          final groundAssetPath = groundById(pasture.activeGroundId).assetPath;

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
                if (rate > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Deine Kühe produzieren +${rate.toStringAsFixed(1)} Milch / Min',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Text(
                  pasture.cows.isEmpty
                      ? 'Noch keine Kühe – erledige Aufgaben, um welche zu bekommen.'
                      : 'Ziehe eine Kuh auf eine gleich-levelige, tippe zwei nacheinander an, '
                          'um sie zu verschmelzen, oder halte eine Kuh gedrückt fürs Profil.',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: PastureBackgroundWidget(
                    fenceId: pasture.activeFenceId,
                    decorationSlots: pasture.decorationSlots,
                    onSlotTap: (slot) => _pickDecoration(slot, pasture.decorationSlots[slot]),
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
                      final matchesDrag = _draggingLevel != null && cow?.level == _draggingLevel;
                      final dimmed = _draggingLevel != null && !matchesDrag;

                      return DragTarget<Cow>(
                        onWillAcceptWithDetails: (details) =>
                            cow != null && details.data.level == cow.level && details.data.id != cow.id,
                        onAcceptWithDetails: (details) => _merge(details.data.id, cow!.id),
                        builder: (context, candidates, rejected) {
                          final cell = _PastureCell(
                            cow: cow,
                            groundAssetPath: groundAssetPath,
                            selected: selected,
                            highlighted: matchesDrag,
                            dimmed: dimmed,
                            hovering: candidates.isNotEmpty,
                            onTap: cow == null ? null : () => _onTapCow(cow),
                            // Langes Drücken statt normalem Tippen fürs
                            // Profil, damit der bestehende
                            // Antippen-zum-Mergen-Ablauf unangetastet bleibt.
                            onLongPress:
                                cow == null ? null : () => showCowProfileModal(context, cow.id),
                          );
                          if (cow == null) return cell;
                          return Draggable<Cow>(
                            data: cow,
                            feedback: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: _PastureCell(
                                  cow: cow,
                                  groundAssetPath: groundAssetPath,
                                  selected: false,
                                  highlighted: true,
                                  dimmed: false,
                                  hovering: false,
                                  onTap: null,
                                  onLongPress: null,
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(opacity: 0.3, child: cell),
                            onDragStarted: () => setState(() => _draggingLevel = cow.level),
                            onDragEnd: (_) => setState(() => _draggingLevel = null),
                            onDraggableCanceled: (_, __) => setState(() => _draggingLevel = null),
                            child: cell,
                          );
                        },
                      );
                    },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDecoration(int slotIndex, String? currentId) async {
    final pasture = ref.read(cowPastureProvider).valueOrNull;
    if (pasture == null) return;
    final notifier = ref.read(cowPastureProvider.notifier);

    final ownedDecorations =
        cowDecorations.where((d) => pasture.isItemUnlocked(d.id, d.price)).toList();

    final chosen = await showModalBottomSheet<String?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('Slot leeren'),
                // Leerer String statt `null` als Rückgabewert: `null`
                // bedeutet hier "Sheet weggewischt, nichts ändern" (siehe
                // unten), ein echtes "leeren" braucht also einen eigenen,
                // von `null` unterscheidbaren Wert.
                onTap: () => Navigator.of(context).pop(''),
              ),
              if (ownedDecorations.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text('Noch keine Deko freigeschaltet – im Milch-Shop erhältlich.'),
                )
              else
                for (final deco in ownedDecorations)
                  ListTile(
                    leading: SafeAssetImage(assetPath: deco.assetPath, width: 32, height: 32),
                    title: Text(deco.name),
                    onTap: () => Navigator.of(context).pop(deco.id),
                  ),
            ],
          ),
        );
      },
    );

    // `null` = Sheet weggewischt/zurück -> nichts ändern. Leerer String
    // = "Slot leeren" bewusst angetippt -> Slot wird geleert.
    if (!mounted || chosen == null) return;
    await notifier.placeDecoration(slotIndex, chosen.isEmpty ? null : chosen);
  }
}

class _PastureCell extends StatelessWidget {
  final Cow? cow;

  /// Pfad der aktiven Bodentextur – wird als Kachel-Hintergrund NUR
  /// gerendert, wenn [cow] nicht `null` ist (siehe Anfrage Punkt 2:
  /// Gras nur auf tatsächlich besetzten Kacheln, leere Felder bleiben
  /// beim normalen dunklen App-Hintergrund).
  final String groundAssetPath;
  final bool selected;
  final bool highlighted;
  final bool dimmed;
  final bool hovering;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _PastureCell({
    required this.cow,
    required this.groundAssetPath,
    required this.selected,
    required this.highlighted,
    required this.dimmed,
    required this.hovering,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).cardTheme.color?.withOpacity(0.6) ??
        Theme.of(context).colorScheme.surface.withOpacity(0.6);
    final accent = Theme.of(context).colorScheme.primary;

    Color borderColor = Colors.transparent;
    if (selected) borderColor = accent;
    if (highlighted || hovering) borderColor = Theme.of(context).colorScheme.secondary;

    final hasCow = cow != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: dimmed ? 0.35 : 1,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        // Bewusst ein einfacher `Container` statt `AnimatedContainer`:
        // ein zweiter, unabhängiger Verdachtsmoment für die
        // Skalierungs-Probleme war die implizite Decoration-Interpolation
        // von AnimatedContainer (u. a. beim schnellen Umschalten von
        // `hovering`/`selected` während des Ziehens) – mit einem
        // schlichten Container entfällt diese Fehlerquelle komplett, nur
        // der Rahmen wechselt dann ohne Fade-Animation die Farbe.
        child: Container(
          // Verhindert, dass Gras-/Zaun-Bild oder das Kuh-Artwork über
          // die abgerundeten Ecken hinaus gezeichnet werden.
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            // Nur besetzte Kacheln bekommen die Gras-Textur als
            // Hintergrund; leere Kacheln bleiben beim normalen
            // (halbtransparenten) Karten-Hintergrund der App.
            color: hovering ? accent.withOpacity(0.25) : baseColor,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: borderColor, width: 3),
            image: hasCow
                ? DecorationImage(
                    image: AssetImage(groundAssetPath),
                    // Füllt die Kachel wirklich vollständig aus – kein
                    // eigenständiges Bild-Widget mehr im Child-Tree, das
                    // klein irgendwo hätte landen können.
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {
                      debugPrint('Boden-Bild (Kachel) konnte nicht geladen werden: $error');
                    },
                  )
                : null,
          ),
          // Bewusst KEIN `alignment` mehr hier: das gibt dem Kind (Stack)
          // straffe statt lose Constraints, sodass der Stack die Kachel
          // garantiert exakt ausfüllt statt sich an seinem Inhalt zu
          // orientieren.
          child: !hasCow
              ? const SizedBox.shrink()
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. Kuh-Charakterbild, zentriert und so groß wie
                    // möglich (BoxFit.contain) innerhalb eines festen
                    // Innenabstands, der unten Platz fürs Level-Badge lässt.
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6, left: 6, right: 6, bottom: 22),
                        child: SafeAssetImage(
                          assetPath: cow!.characterType.cardAssetPath,
                          fit: BoxFit.contain,
                          placeholderIcon: Icons.pets,
                        ),
                      ),
                    ),
                    // 2. Level-Badge am unteren Rand, horizontal zentriert
                    // (durch die fehlenden left/right-Werte übernimmt die
                    // Stack-`alignment` oben die Zentrierung).
                    Positioned(
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Lv. ${cow!.level}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
