import 'package:flutter/material.dart';

import '../../../core/assets/cow_asset_registry.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/cow_accessory.dart';

/// Weiden-Hintergrund: wechselbare Bodentextur + Zaun-Streifen +
/// feste Deko-Slots (siehe Anfrage Punkt 2/3 – bewusst KEIN freies
/// Canvas-Dragging, sondern ein einfaches Slot-System: gekaufte
/// Deko-Objekte werden einem der [decorationSlots] zugewiesen und
/// dort als PNG gerendert).
class PastureBackgroundWidget extends StatelessWidget {
  final String groundId;
  final String fenceId;
  final List<String?> decorationSlots;
  final ValueChanged<int> onSlotTap;

  /// Der eigentliche Weiden-Inhalt (z. B. das Kuh-Raster), der über
  /// dem Bodenbild liegt.
  final Widget child;

  const PastureBackgroundWidget({
    super.key,
    required this.groundId,
    required this.fenceId,
    required this.decorationSlots,
    required this.onSlotTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ground = groundById(groundId);
    final fence = fenceById(fenceId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                child: SafeAssetImage(
                  assetPath: ground.assetPath,
                  fit: BoxFit.cover,
                  placeholderIcon: Icons.grass_outlined,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: child,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Zaun-Streifen: rein dekorativ, keine eigene Interaktion.
        SizedBox(
          height: 36,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            child: SafeAssetImage(
              assetPath: fence.assetPath,
              fit: BoxFit.cover,
              // `Icons.grid_view_outlined` statt eines Zaun-spezifischen
              // Icons: garantiert im Kern-Icon-Set vorhanden (keine
              // Abhängigkeit von einer bestimmten Material-Icons-Version).
              placeholderIcon: Icons.grid_view_outlined,
            ),
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
