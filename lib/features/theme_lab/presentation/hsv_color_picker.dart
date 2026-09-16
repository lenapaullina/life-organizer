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
  late TextEditingController _hexController;
  bool _hexFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initialColor);
    _hexController = TextEditingController(text: _hexOf(_hsv));
  }

  @override
  void didUpdateWidget(covariant HsvColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor) {
      _hsv = HSVColor.fromColor(widget.initialColor);
      if (!_hexFieldFocused) {
        _hexController.text = _hexOf(_hsv);
      }
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _hexOf(HSVColor hsv) {
    final color = hsv.toColor();
    return color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
  }

  void _update(HSVColor next, {bool syncHexField = true}) {
    setState(() => _hsv = next);
    if (syncHexField) {
      _hexController.text = _hexOf(next);
    }
    widget.onChanged(next.toColor());
  }

  void _onHexSubmitted(String raw) {
    final cleaned = raw.trim().replaceFirst('#', '');
    if (cleaned.length != 6 || int.tryParse(cleaned, radix: 16) == null) {
      // Ungültige Eingabe -> einfach auf den aktuellen Wert zurücksetzen,
      // statt die App abstürzen zu lassen.
      _hexController.text = _hexOf(_hsv);
      return;
    }
    final value = int.parse('FF$cleaned', radix: 16);
    _update(HSVColor.fromColor(Color(value)), syncHexField: false);
  }

  @override
  Widget build(BuildContext context) {
    final color = _hsv.toColor();

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
            const Text('#', style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            SizedBox(
              width: 110,
              child: Focus(
                onFocusChange: (hasFocus) => _hexFieldFocused = hasFocus,
                child: TextField(
                  controller: _hexController,
                  maxLength: 6,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                  decoration: const InputDecoration(counterText: '', isDense: true),
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: _onHexSubmitted,
                  onEditingComplete: () => _onHexSubmitted(_hexController.text),
                ),
              ),
            ),
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
            value: value.clamp(min, max).toDouble(),
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
