import 'package:flutter/material.dart';

/// Grund-Hintergrundstimmung – die eigentliche Akzentfarbe kommt
/// unabhängig davon aus [CustomColorSettings.accentColor].
enum BackgroundMode { dark, oled, light, warmNeutral }

extension BackgroundModeX on BackgroundMode {
  String get label => switch (this) {
        BackgroundMode.dark => 'Dark',
        BackgroundMode.oled => 'OLED (reines Schwarz)',
        BackgroundMode.light => 'Light',
        BackgroundMode.warmNeutral => 'Warm Neutral',
      };

  /// Basisfarben, die aus dem gewählten Modus abgeleitet werden –
  /// darauf setzt dann die individuelle Akzent-/Kartenfarbe drauf.
  Color get background => switch (this) {
        BackgroundMode.dark => const Color(0xFF121214),
        BackgroundMode.oled => const Color(0xFF000000),
        BackgroundMode.light => const Color(0xFFF7F5FA),
        BackgroundMode.warmNeutral => const Color(0xFF2A2420),
      };

  Color get surface => switch (this) {
        BackgroundMode.dark => const Color(0xFF1E1E24),
        BackgroundMode.oled => const Color(0xFF0A0A0A),
        BackgroundMode.light => const Color(0xFFFFFFFF),
        BackgroundMode.warmNeutral => const Color(0xFF362F29),
      };

  Color get surfaceMuted => switch (this) {
        BackgroundMode.dark => const Color(0xFF2A2A32),
        BackgroundMode.oled => const Color(0xFF151515),
        BackgroundMode.light => const Color(0xFFEDE9F2),
        BackgroundMode.warmNeutral => const Color(0xFF433A33),
      };

  bool get isDark => this != BackgroundMode.light;

  Color get textPrimary => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF201C24);
  Color get textSecondary => isDark ? const Color(0xFFB8B8C2) : const Color(0xFF5B5566);
}

/// Frei einstellbares Grund-Design – für JEDE Nutzerin verfügbar,
/// unabhängig vom Milch-Shop (siehe special_style.dart). Wird als
/// eigenständiges JSON-Objekt persistiert (siehe json_object_store.dart).
class CustomColorSettings {
  final int accentColorValue;
  final BackgroundMode backgroundMode;
  final int? cardColorValue; // null = automatisch aus backgroundMode abgeleitet

  const CustomColorSettings({
    required this.accentColorValue,
    required this.backgroundMode,
    this.cardColorValue,
  });

  Color get accentColor => Color(accentColorValue);
  Color? get cardColor => cardColorValue == null ? null : Color(cardColorValue!);

  factory CustomColorSettings.fallback() => const CustomColorSettings(
        accentColorValue: 0xFFFF1493, // Neon-Pink, wie bisheriges Y2K-Theme
        backgroundMode: BackgroundMode.dark,
        cardColorValue: null,
      );

  CustomColorSettings copyWith({
    int? accentColorValue,
    BackgroundMode? backgroundMode,
    int? cardColorValue,
    bool clearCardColor = false,
  }) {
    return CustomColorSettings(
      accentColorValue: accentColorValue ?? this.accentColorValue,
      backgroundMode: backgroundMode ?? this.backgroundMode,
      cardColorValue: clearCardColor ? null : (cardColorValue ?? this.cardColorValue),
    );
  }

  Map<String, dynamic> toJson() => {
        'accentColorValue': accentColorValue,
        'backgroundMode': backgroundMode.name,
        'cardColorValue': cardColorValue,
      };

  factory CustomColorSettings.fromJson(Map<String, dynamic> json) {
    return CustomColorSettings(
      accentColorValue: json['accentColorValue'] as int? ?? 0xFFFF1493,
      backgroundMode: BackgroundMode.values.firstWhere(
        (m) => m.name == json['backgroundMode'],
        orElse: () => BackgroundMode.dark,
      ),
      cardColorValue: json['cardColorValue'] as int?,
    );
  }
}

/// Ein fertig kombiniertes Preset zum Ein-Klick-Übernehmen.
class ColorPreset {
  final String name;
  final CustomColorSettings settings;
  const ColorPreset(this.name, this.settings);
}

const colorPresets = [
  ColorPreset(
    'Pastell',
    CustomColorSettings(
      accentColorValue: 0xFFB79CED,
      backgroundMode: BackgroundMode.light,
      cardColorValue: 0xFFF1E9FB,
    ),
  ),
  ColorPreset(
    'Minimalist Dark',
    CustomColorSettings(
      accentColorValue: 0xFF7C8CF8,
      backgroundMode: BackgroundMode.oled,
      cardColorValue: 0xFF151515,
    ),
  ),
  ColorPreset(
    'High Contrast',
    CustomColorSettings(
      accentColorValue: 0xFFFFD600,
      backgroundMode: BackgroundMode.oled,
      cardColorValue: 0xFF000000,
    ),
  ),
];
