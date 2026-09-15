import 'package:flutter/material.dart';

/// Y2K / 2000er-MySpace-Palette: dunkler Untergrund, zwei laute
/// Neon-Akzente (Pink + Cyan), Statusfarben bleiben als eigenes,
/// erkennbares Ampel-Set erhalten – nur eben jetzt neongrell statt
/// gedämpft, damit sie im dunklen Grundton trotzdem sofort auffallen.
class AppColors {
  AppColors._();

  // Dunkler Grundton statt hellem Lila-Weiß – das eigentliche "MySpace
  // bei Nacht"-Gefühl kommt vor allem von diesem tiefen Hintergrund.
  static const background = Color(0xFF121214);
  static const surface = Color(0xFF1E1E24);
  static const surfaceMuted = Color(0xFF2A2A32);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB8B8C2);
  static const border = Color(0xFFFF1493);

  // Statusfarben – bewusst weiterhin ein eigenes Grün/Gelb/Rot-Set
  // (siehe status_calculator.dart), nur jetzt als Neon-Variante,
  // damit die Ampel im dunklen Theme genauso sofort lesbar bleibt.
  static const statusGreen = Color(0xFF39FF14);
  static const statusGreenBg = Color(0xFF163019);
  static const statusYellow = Color(0xFFFFD600);
  static const statusYellowBg = Color(0xFF332B0A);
  static const statusRed = Color(0xFFFF3860);
  static const statusRedBg = Color(0xFF33111A);

  // Primärer Akzent: Neon-Pink/Magenta (der "MySpace-Pink" schlechthin).
  static const accent = Color(0xFFFF1493);
  static const accentBg = Color(0xFF33101F);
  static const accentPink = Color(0xFFFF1493);

  // Sekundärer Akzent: Cyan, für Links/zweite Hervorhebung – im
  // Original-MySpace-Stil das "besuchter Link/Hover"-Türkis.
  static const accentCyan = Color(0xFF00E5FF);
}
