import 'package:flutter/material.dart';

/// Bewusst reizarme Farbpalette: wenig Sättigung im Grundton,
/// klar unterscheidbare (aber nicht grelle) Statusfarben.
/// Die Statusfarben sind das einzige "laute" Element der App –
/// alles andere bleibt ruhig, damit Status wirklich ins Auge fällt.
class AppColors {
  AppColors._();

  // Neutrale Basis – leichter Lila-Stich statt reinem Grau/Weiß
  static const background = Color(0xFFFBF6FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF3EAF6);
  static const textPrimary = Color(0xFF352A38);
  static const textSecondary = Color(0xFF7A6B7E);
  static const border = Color(0xFFE6D9ED);

  // Statusfarben – bewusst unverändert, das ist das wichtigste Signal der App
  static const statusGreen = Color(0xFF4C9A6A);
  static const statusGreenBg = Color(0xFFE6F2EA);
  static const statusYellow = Color(0xFFCF9A2E);
  static const statusYellowBg = Color(0xFFFBF0DC);
  static const statusRed = Color(0xFFC0564D);
  static const statusRedBg = Color(0xFFF7E5E3);

  // Akzent – gedämpftes Lila/Magenta statt MySpace-Neon, sparsam einsetzen
  static const accent = Color(0xFF8B5FBF);
  static const accentBg = Color(0xFFF1E6F5);
  static const accentPink = Color(0xFFC15FA3);
}
