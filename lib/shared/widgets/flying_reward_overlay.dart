import 'package:flutter/material.dart';

/// Kleine "Juiciness"-Belohnungs-Animation: ein Emoji fliegt vom
/// Auslöse-Punkt (z. B. dem "Erledigt"-Button) nach oben rechts und
/// verblasst dabei – ein Hinweis darauf, dass gerade Kuh-Milch
/// verdient wurde, ohne dass man extra auf die Weide wechseln muss.
///
/// Bewusste Vereinfachung: es gibt in der Bottom-Navigation aktuell
/// keine eigene Kuh-Weide-Kachel (nur Start/Haushalt/Routinen/Mehr),
/// daher fliegt das Icon zu einem festen Punkt oben rechts im
/// sichtbaren Bereich, statt zu einem exakten Nav-Bar-Icon – für ein
/// echtes Ziel-Icon in der Nav-Leiste bräuchte es einen größeren
/// Navigations-Umbau (5. Tab oder Badge), den ich hier nicht
/// eigenmächtig vorgenommen habe.
class FlyingRewardOverlay {
  static void play(
    BuildContext context, {
    required Offset startGlobalPosition,
    String emoji = '🐄',
  }) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final screenSize = MediaQuery.of(context).size;
    final endPosition = Offset(screenSize.width - 32, 48);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _FlyingEmoji(
        start: startGlobalPosition,
        end: endPosition,
        emoji: emoji,
        onDone: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _FlyingEmoji extends StatefulWidget {
  final Offset start;
  final Offset end;
  final String emoji;
  final VoidCallback onDone;

  const _FlyingEmoji({
    required this.start,
    required this.end,
    required this.emoji,
    required this.onDone,
  });

  @override
  State<_FlyingEmoji> createState() => _FlyingEmojiState();
}

class _FlyingEmojiState extends State<_FlyingEmoji> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _position;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _position = Tween<Offset>(begin: widget.start, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
    );
    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1, curve: Curves.easeOut)),
    );
    _scale = Tween<double>(begin: 1.1, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _position.value.dx,
          top: _position.value.dy,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Text(widget.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
        );
      },
    );
  }
}

/// Ermittelt die globale Position eines Widgets (über seinen
/// [BuildContext]) – praktisch, um die Flug-Animation genau am
/// gedrückten Button starten zu lassen.
Offset? globalCenterOf(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.attached) return null;
  final topLeft = box.localToGlobal(Offset.zero);
  return topLeft + Offset(box.size.width / 2, box.size.height / 2);
}
