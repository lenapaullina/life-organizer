import 'package:flutter/material.dart';

import '../../../core/assets/cow_asset_registry.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/cow_accessory.dart';

/// Weiden-Rahmen: der Zaun liegt jetzt AUSSCHLIESSLICH als schmaler
/// Rand an den 4 Außenkanten des Raster-Feldes (vier eigenständige
/// Streifen in einem Stack, siehe [_FenceStrip]) – kein Kachel-Muster
/// mehr, das über die ganze Fläche läuft. Die Bodentextur (Gras) wird
/// NICHT mehr hier gerendert: die liegt jetzt pro Kachel nur auf
/// tatsächlich besetzten Feldern (siehe `_PastureCell` in
/// `cow_pasture_screen.dart`), leere Kacheln zeigen den normalen
/// dunklen App-Hintergrund. Zusätzlich feste Deko-Slots (siehe
/// Anfrage Punkt 2/3 – bewusst KEIN freies Canvas-Dragging, sondern
/// ein einfaches Slot-System: gekaufte Deko-Objekte werden einem der
/// [decorationSlots] zugewiesen und dort als PNG gerendert).
class PastureBackgroundWidget extends StatelessWidget {
  final String fenceId;
  final List<String?> decorationSlots;
  final ValueChanged<int> onSlotTap;

  /// Der eigentliche Weiden-Inhalt (das Kuh-Raster), der innerhalb
  /// des Zaun-Rahmens liegt.
  final Widget child;

  const PastureBackgroundWidget({
    super.key,
    required this.fenceId,
    required this.decorationSlots,
    required this.onSlotTap,
    required this.child,
  });

  /// Breite des Zaun-Rahmens in Pixeln – als Konstante, damit die vier
  /// Streifen unten und das Innen-Padding exakt zusammenpassen.
  static const _fenceThickness = 14.0;

  @override
  Widget build(BuildContext context) {
    final fence = fenceById(fenceId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            children: [
              // Dunkler Standard-Untergrund der App als Basis – NICHT die
              // Bodentextur (die zeigt sich nur noch pro Kachel auf
              // besetzten Feldern, siehe Klassenkommentar oben).
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                ),
              ),
              // Das Spielfeld (Kuh-Raster) sitzt innerhalb des Zaun-Rahmens.
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(_fenceThickness),
                  child: child,
                ),
              ),
              // Zaun NUR als Rahmen an den 4 Außenkanten des Grids – vier
              // eigenständige, sich an den Ecken nicht überlappende
              // Streifen statt eines flächendeckenden Kachel-Musters.
              // `IgnorePointer`, damit der Rahmen nie Drag/Tap-Gesten
              // auf dem darunterliegenden Grid abfängt.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _fenceThickness,
                child: _FenceStrip(fence: fence),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: _fenceThickness,
                child: _FenceStrip(fence: fence),
              ),
              Positioned(
                top: _fenceThickness,
                bottom: _fenceThickness,
                left: 0,
                width: _fenceThickness,
                child: _FenceStrip(fence: fence),
              ),
              Positioned(
                top: _fenceThickness,
                bottom: _fenceThickness,
                right: 0,
                width: _fenceThickness,
                child: _FenceStrip(fence: fence),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: decorationSlots.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final decoId = decorationSlots[index];
              final deco = cowDecorationById(decoId);
              return _DecoSlot(
                deco: deco,
                onTap: () => onSlotTap(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Ein einzelner, schmaler Zaun-Streifen (siehe [PastureBackgroundWidget]).
/// `ResizeImage` skaliert das (meist sehr viel breitere als hohe)
/// Zaun-PNG vorab auf eine kleine Kachelgröße, bevor `repeat` es
/// mehrfach nebeneinander zeichnet – so bleiben die einzelnen
/// Zaunpfosten klein und erkennbar statt riesig verzerrt zu wirken.
class _FenceStrip extends StatelessWidget {
  final PastureFenceItem fence;
  const _FenceStrip({required this.fence});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12, // sichtbar, falls das Bild mal fehlschlägt
          image: DecorationImage(
            image: ResizeImage(AssetImage(fence.assetPath), width: 40),
            repeat: ImageRepeat.repeat,
            // Fail-Safe: schlägt das Bild fehl, wird der Fehler nur
            // geloggt statt die App abstürzen zu lassen (DecorationImage
            // hat kein `errorBuilder` wie Image.asset, siehe
            // SafeAssetImage in cow_asset_registry.dart für die
            // Image.asset-Variante der Fail-Safe-Pipeline).
            onError: (error, stackTrace) {
              debugPrint('Zaun-Bild konnte nicht geladen werden: $error');
            },
          ),
        ),
      ),
    );
  }
}

class _DecoSlot extends StatelessWidget {
  final CowDecorationItem? deco;
  final VoidCallback onTap;
  const _DecoSlot({required this.deco, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      child: Container(
        width: 64,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          color: Colors.black.withOpacity(0.05),
        ),
        alignment: Alignment.center,
        child: deco == null
            ? const Icon(Icons.add, color: Colors.black38)
            : SafeAssetImage(assetPath: deco!.assetPath, width: 48, height: 48),
      ),
    );
  }
}
