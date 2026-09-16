import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/json_object_store.dart';
import '../../cow_evolution/application/cow_pasture_providers.dart';
import '../domain/custom_color_settings.dart';
import '../domain/special_style.dart';

final _themeSettingsStoreProvider = Provider((ref) => JsonObjectStore('theme_settings.json'));

class ThemeSettingsNotifier extends StateNotifier<CustomColorSettings> {
  final JsonObjectStore _store;

  ThemeSettingsNotifier(this._store) : super(CustomColorSettings.fallback()) {
    _load();
  }

  Future<void> _load() async {
    final raw = await _store.read();
    if (raw.isNotEmpty) {
      state = CustomColorSettings.fromJson(raw);
    }
  }

  Future<void> _persist(CustomColorSettings value) async {
    state = value;
    await _store.write(value.toJson());
  }

  Future<void> setAccentColor(Color color) => _persist(state.copyWith(accentColorValue: color.value));

  Future<void> setBackgroundMode(BackgroundMode mode) =>
      _persist(state.copyWith(backgroundMode: mode));

  Future<void> setCardColor(Color? color) => color == null
      ? _persist(state.copyWith(clearCardColor: true))
      : _persist(state.copyWith(cardColorValue: color.value));

  Future<void> setSecondaryColor(Color? color) => color == null
      ? _persist(state.copyWith(clearSecondaryColor: true))
      : _persist(state.copyWith(secondaryColorValue: color.value));

  Future<void> setTextPrimaryColor(Color? color) => color == null
      ? _persist(state.copyWith(clearTextPrimaryColor: true))
      : _persist(state.copyWith(textPrimaryColorValue: color.value));

  Future<void> setTextSecondaryColor(Color? color) => color == null
      ? _persist(state.copyWith(clearTextSecondaryColor: true))
      : _persist(state.copyWith(textSecondaryColorValue: color.value));

  Future<void> setBorderColor(Color? color) => color == null
      ? _persist(state.copyWith(clearBorderColor: true))
      : _persist(state.copyWith(borderColorValue: color.value));

  Future<void> setGradientEndColor(Color? color) => color == null
      ? _persist(state.copyWith(clearGradientEnd: true))
      : _persist(state.copyWith(gradientEndColorValue: color.value));

  Future<void> applyPreset(ColorPreset preset) => _persist(preset.settings);
}

final themeSettingsProvider =
    StateNotifierProvider<ThemeSettingsNotifier, CustomColorSettings>((ref) {
  return ThemeSettingsNotifier(ref.watch(_themeSettingsStoreProvider));
});

/// Baut ein komplettes [ThemeData] entweder aus der freien
/// Farb-Administration ([CustomColorSettings]) oder – falls im
/// Milch-Shop aktiviert – aus einem [SpecialStyleItem]. Beide Wege
/// laufen durch dieselbe Funktion, damit sich Karten/Buttons/Chips
/// etc. konsistent verhalten, egal welcher Weg gerade aktiv ist.
///
/// Bewusste Scoping-Grenzen (siehe README):
/// - Widgets mit fest verdrahteten Farben (z. B. StatusPill/die
///   Grün-Gelb-Rot-Ampel) bleiben unangetastet – die "reizarme"
///   Statusfarblogik soll unabhängig vom gewählten Look immer gleich
///   erkennbar bleiben.
/// - Ein eingestellter Verlauf (`gradientEndColor`) wird in der
///   Live-Vorschau sowie künftig in einzelnen Kopfbereichen sichtbar
///   gemacht (siehe `accentGradient`), aber NICHT app-weit in jede
///   AppBar/jeden Button eingebaut: Flutters `AppBarTheme`/
///   `ElevatedButtonThemeData` unterstützen nur einfarbige Flächen,
///   ein echter Verlauf bräuchte pro Bildschirm eine eigene
///   Container-Deko statt der zentralen Theme-Konstanten.
ThemeData buildDynamicTheme({
  required CustomColorSettings custom,
  SpecialStyleItem? activeStyle,
}) {
  final Color accent;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Brightness brightness;
  final double cardRadius;
  final double borderWidth;
  final String fontFamily;

  if (activeStyle != null) {
    accent = activeStyle.accentColor;
    secondary = activeStyle.secondaryColor;
    background = activeStyle.backgroundColor;
    surface = activeStyle.surfaceColor;
    surfaceMuted = Color.alphaBlend(Colors.black.withOpacity(0.15), activeStyle.surfaceColor);
    brightness = ThemeData.estimateBrightnessForColor(background);
    textPrimary = brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1A1A);
    textSecondary = textPrimary.withOpacity(0.7);
    cardRadius = activeStyle.cardRadius;
    borderWidth = activeStyle.borderWidth;
    fontFamily = activeStyle.fontFamily;
  } else {
    final mode = custom.backgroundMode;
    accent = custom.accentColor;
    secondary = custom.secondaryColor;
    background = mode.background;
    surface = custom.cardColor ?? mode.surface;
    surfaceMuted = mode.surfaceMuted;
    brightness = mode.isDark ? Brightness.dark : Brightness.light;
    textPrimary = custom.textPrimaryColor;
    textSecondary = custom.textSecondaryColor;
    cardRadius = 8;
    borderWidth = 2;
    fontFamily = '';
  }

  final effectiveBorderColor = activeStyle != null ? accent : custom.borderColor;

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: background,
    fontFamily: fontFamily.isEmpty ? null : fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      surface: surface,
      primary: accent,
      secondary: secondary,
      error: const Color(0xFFFF3860),
    ),
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(color: textPrimary),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(color: textSecondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: accent,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      shadowColor: secondary,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
        color: Colors.white,
        fontFamily: fontFamily.isEmpty ? null : fontFamily,
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 3,
      shadowColor: accent.withOpacity(0.35),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: BorderSide(color: effectiveBorderColor.withOpacity(0.6), width: borderWidth),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 3,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius * 0.75)),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          fontFamily: fontFamily.isEmpty ? null : fontFamily,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: secondary,
        side: BorderSide(color: secondary, width: borderWidth),
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius * 0.75)),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: surfaceMuted,
      selectedColor: accent.withOpacity(0.25),
      side: BorderSide(color: secondary, width: 1.2),
      labelStyle: TextStyle(fontWeight: FontWeight.w700, color: textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceMuted,
      hintStyle: TextStyle(color: textSecondary),
      labelStyle: TextStyle(color: textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(cardRadius * 0.75),
        borderSide: BorderSide(color: accent.withOpacity(0.5), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(cardRadius * 0.75),
        borderSide: BorderSide(color: secondary, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: accent.withOpacity(0.25),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: MaterialStateProperty.all(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: secondary),
      ),
      iconTheme: MaterialStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(MaterialState.selected) ? accent : textSecondary,
        ),
      ),
    ),
    dividerTheme: DividerThemeData(color: effectiveBorderColor.withOpacity(0.4), thickness: 1),
    iconTheme: IconThemeData(color: textPrimary),
    listTileTheme: ListTileThemeData(iconColor: secondary, textColor: textPrimary),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceMuted,
      contentTextStyle: TextStyle(color: textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius * 0.75),
        side: BorderSide(color: secondary, width: 1.5),
      ),
      actionTextColor: secondary,
    ),
  );
}

/// Für Vorschau/Kopfbereiche, die den optionalen Verlauf wirklich als
/// Gradient darstellen wollen (statt der Solid-Farben aus ThemeData).
LinearGradient? accentGradient(CustomColorSettings custom) {
  final end = custom.gradientEndColor;
  if (end == null) return null;
  return LinearGradient(colors: [custom.accentColor, end]);
}

/// Das tatsächlich verwendete App-Theme: freie Farbwahl, oder falls
/// ein Special-Style aktiviert wurde, dessen fester Look.
final dynamicThemeProvider = Provider<ThemeData>((ref) {
  final custom = ref.watch(themeSettingsProvider);
  final pasture = ref.watch(cowPastureProvider).valueOrNull;
  final activeStyle = specialStyleById(pasture?.activeStyleId);
  return buildDynamicTheme(custom: custom, activeStyle: activeStyle);
});
