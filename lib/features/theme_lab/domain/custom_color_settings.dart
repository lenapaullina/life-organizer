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
///
/// Jedes Farbfeld außer der Akzentfarbe ist bewusst NULLABLE: `null`
/// heißt "automatisch aus backgroundMode/accentColor abgeleitet", statt
/// dass man erst mal alles einzeln einstellen muss, um ein stimmiges
/// Ergebnis zu bekommen. Wer will, kann trotzdem jede einzelne Farbe
/// überschreiben – nur die Status-Ampel (Grün/Gelb/Rot, siehe
/// status_calculator.dart/StatusPill) bleibt bewusst außen vor, damit
/// sie immer gleich erkennbar bleibt (siehe README).
class CustomColorSettings {
  final int accentColorValue;
  final BackgroundMode backgroundMode;
  final int? cardColorValue; // Karten-/Container-Fläche
  final int? secondaryColorValue; // zweiter Akzent (Links, Ränder, Icons)
  final int? textPrimaryColorValue;
  final int? textSecondaryColorValue;
  final int? borderColorValue;
  // Optionaler Verlauf: wenn gesetzt, wird statt der reinen
  // Akzentfarbe ein Verlauf von accentColor -> gradientEndColor in
  // der Vorschau sowie in AppBar/Kopfbereichen verwendet.
  final int? gradientEndColorValue;

  const CustomColorSettings({
    required this.accentColorValue,
    required this.backgroundMode,
    this.cardColorValue,
    this.secondaryColorValue,
    this.textPrimaryColorValue,
    this.textSecondaryColorValue,
    this.borderColorValue,
    this.gradientEndColorValue,
  });

  Color get accentColor => Color(accentColorValue);
  Color? get cardColor => cardColorValue == null ? null : Color(cardColorValue!);
  Color get secondaryColor =>
      secondaryColorValue == null ? const Color(0xFF00E5FF) : Color(secondaryColorValue!);
  Color get textPrimaryColor =>
      textPrimaryColorValue == null ? backgroundMode.textPrimary : Color(textPrimaryColorValue!);
  Color get textSecondaryColor => textSecondaryColorValue == null
      ? backgroundMode.textSecondary
      : Color(textSecondaryColorValue!);
  Color get borderColor => borderColorValue == null ? accentColor : Color(borderColorValue!);
  Color? get gradientEndColor =>
      gradientEndColorValue == null ? null : Color(gradientEndColorValue!);
  bool get hasGradient => gradientEndColorValue != null;

  factory CustomColorSettings.fallback() => const CustomColorSettings(
        accentColorValue: 0xFFFF1493, // Neon-Pink, wie bisheriges Y2K-Theme
        backgroundMode: BackgroundMode.dark,
      );

  CustomColorSettings copyWith({
    int? accentColorValue,
    BackgroundMode? backgroundMode,
    int? cardColorValue,
    bool clearCardColor = false,
    int? secondaryColorValue,
    bool clearSecondaryColor = false,
    int? textPrimaryColorValue,
    bool clearTextPrimaryColor = false,
    int? textSecondaryColorValue,
    bool clearTextSecondaryColor = false,
    int? borderColorValue,
    bool clearBorderColor = false,
    int? gradientEndColorValue,
    bool clearGradientEnd = false,
  }) {
    return CustomColorSettings(
      accentColorValue: accentColorValue ?? this.accentColorValue,
      backgroundMode: backgroundMode ?? this.backgroundMode,
      cardColorValue: clearCardColor ? null : (cardColorValue ?? this.cardColorValue),
      secondaryColorValue:
          clearSecondaryColor ? null : (secondaryColorValue ?? this.secondaryColorValue),
      textPrimaryColorValue:
          clearTextPrimaryColor ? null : (textPrimaryColorValue ?? this.textPrimaryColorValue),
      textSecondaryColorValue: clearTextSecondaryColor
          ? null
          : (textSecondaryColorValue ?? this.textSecondaryColorValue),
      borderColorValue: clearBorderColor ? null : (borderColorValue ?? this.borderColorValue),
      gradientEndColorValue:
          clearGradientEnd ? null : (gradientEndColorValue ?? this.gradientEndColorValue),
    );
  }

  Map<String, dynamic> toJson() => {
        'accentColorValue': accentColorValue,
        'backgroundMode': backgroundMode.name,
        'cardColorValue': cardColorValue,
        'secondaryColorValue': secondaryColorValue,
        'textPrimaryColorValue': textPrimaryColorValue,
        'textSecondaryColorValue': textSecondaryColorValue,
        'borderColorValue': borderColorValue,
        'gradientEndColorValue': gradientEndColorValue,
      };

  factory CustomColorSettings.fromJson(Map<String, dynamic> json) {
    return CustomColorSettings(
      accentColorValue: json['accentColorValue'] as int? ?? 0xFFFF1493,
      backgroundMode: BackgroundMode.values.firstWhere(
        (m) => m.name == json['backgroundMode'],
        orElse: () => BackgroundMode.dark,
      ),
      cardColorValue: json['cardColorValue'] as int?,
      secondaryColorValue: json['secondaryColorValue'] as int?,
      textPrimaryColorValue: json['textPrimaryColorValue'] as int?,
      textSecondaryColorValue: json['textSecondaryColorValue'] as int?,
      borderColorValue: json['borderColorValue'] as int?,
      gradientEndColorValue: json['gradientEndColorValue'] as int?,
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
  ColorPreset(
    'Sonnenuntergang (Verlauf)',
    CustomColorSettings(
      accentColorValue: 0xFFFF5F6D,
      backgroundMode: BackgroundMode.dark,
      gradientEndColorValue: 0xFFFFC371,
    ),
  ),
];
