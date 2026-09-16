import 'package:flutter/material.dart';

/// Einfacher, abhängigkeitsfreier Farbwähler auf Basis von
/// Flutters eingebautem [HSVColor] + drei [Slider]n.
///
/// Bewusste Entscheidung gegen ein externes Package wie
/// `flutter_colorpicker`: pub.dev ist aus dieser Sandbox nicht
/// erreichbar, um Version/API-Kompatibilität zu prüfen – mit den
/// Bordmitteln lässt sich das Ergebnis dagegen vollständig von Hand
/// nachvollziehen und ist garantiert lauffähig.
class HsvColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onChanged;

  const HsvColorPicker({super.key, required this.initialColor, required this.onChanged});

  @override
  State<HsvColorPicker> createState() => _HsvColorPickerState();
}

class _HsvColorPickerState extends State<HsvColorPicker> {
  late HSVColor _hsv;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initialColor);
  }

  @override
  void didUpdateWidget(covariant HsvColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor) {
      _hsv = HSVColor.fromColor(widget.initialColor);
    }
  }

  void _update(HSVColor next) {
    setState(() => _hsv = next);
    widget.onChanged(next.toColor());
  }

  @override
  Widget build(BuildContext context) {
    final color = _hsv.toColor();
    final hex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
              ),
            ),
            const SizedBox(width: 12),
            Text(hex, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'monospace')),
          ],
        ),
        const SizedBox(height: 8),
        _ChannelSlider(
          label: 'Farbton',
          value: _hsv.hue,
          min: 0,
          max: 360,
          activeColor: HSVColor.fromAHSV(1, _hsv.hue, 1, 1).toColor(),
          onChanged: (v) => _update(_hsv.withHue(v)),
        ),
        _ChannelSlider(
          label: 'Sättigung',
          value: _hsv.saturation,
          min: 0,
          max: 1,
          activeColor: color,
          onChanged: (v) => _update(_hsv.withSaturation(v)),
        ),
        _ChannelSlider(
          label: 'Helligkeit',
          value: _hsv.value,
          min: 0,
          max: 1,
          activeColor: color,
          onChanged: (v) => _update(_hsv.withValue(v)),
        ),
      ],
    );
  }
}

class _ChannelSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const _ChannelSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 76, child: Text(label, style: const TextStyle(fontSize: 13))),
        Expanded(
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: activeColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
