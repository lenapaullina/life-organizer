import 'package:flutter/material.dart';

/// Ein mit Kuh-Milch freischaltbarer "Special Style" – überschreibt,
/// wenn aktiv, die freie Farb-Administration mit einem fest
/// vorgegebenen, thematischen Look.
///
/// Bewusste Scoping-Entscheidung: die vier Styles werden über
/// Farbpalette + Form/Rand/Typografie-Parameter umgesetzt (das lässt
/// sich mit reinen Flutter-Bordmitteln sauber und verifizierbar
/// bauen). Echte CRT-Scanline-/Glitch-Shader, Pixel-Font-Dateien
/// oder handgezeichnete Tinten-Texturen bräuchten zusätzliche
/// Asset-/Package-Abhängigkeiten, die sich hier ohne Netzwerk/Compiler
/// nicht verifizieren lassen – die Namen/Preise/Freischaltung sind
/// aber voll funktionsfähig, nur die visuelle Tiefe ist reduziert.
class SpecialStyleItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final int accentColorValue;
  final int secondaryColorValue;
  final int backgroundColorValue;
  final int surfaceColorValue;
  final double cardRadius;
  final double borderWidth;
  final String fontFamily; // built-in Flutter-Familie, kein externes Asset nötig
  final bool scanlineHint; // Cyberpunk: schmale Linien-Deko statt echtem Shader
  final bool roughBorderHint; // Ink & Comic: unregelmäßig wirkender Rand

  const SpecialStyleItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.accentColorValue,
    required this.secondaryColorValue,
    required this.backgroundColorValue,
    required this.surfaceColorValue,
    this.cardRadius = 8,
    this.borderWidth = 2,
    this.fontFamily = '',
    this.scanlineHint = false,
    this.roughBorderHint = false,
  });

  Color get accentColor => Color(accentColorValue);
  Color get secondaryColor => Color(secondaryColorValue);
  Color get backgroundColor => Color(backgroundColorValue);
  Color get surfaceColor => Color(surfaceColorValue);
}

const specialStyles = <SpecialStyleItem>[
  SpecialStyleItem(
    id: 'y2k_cyber',
    name: 'Y2K / Late-90s Cyber',
    description: 'Silber, Chrom & Glas-Optik mit Neon-Magenta und Eisblau.',
    price: 200,
    accentColorValue: 0xFFFF007F, // Neon-Magenta
    secondaryColorValue: 0xFF00E5FF, // Eisblau
    backgroundColorValue: 0xFF14141C,
    surfaceColorValue: 0xFF2B2B3A, // "Chrom"-graue Fläche
    cardRadius: 18,
    borderWidth: 1.5,
  ),
  SpecialStyleItem(
    id: 'cyberpunk_neon',
    name: 'Cyberpunk / Low-Poly Neon',
    description: 'Neon-Cyan, Hot-Pink & Electric-Blue vor Deep-Black, mit Scanline-Deko.',
    price: 350,
    accentColorValue: 0xFF00FFF7, // Neon-Cyan
    secondaryColorValue: 0xFFFF2EC4, // Hot-Pink
    backgroundColorValue: 0xFF000000,
    surfaceColorValue: 0xFF0D0D14,
    cardRadius: 2,
    borderWidth: 2,
    scanlineHint: true,
  ),
  SpecialStyleItem(
    id: 'pixel_retro',
    name: 'Pixel-Art / 16-Bit Retro',
    description: 'SNES-/Arcade-Palette mit blockigen Formen und Monospace-Schrift.',
    price: 500,
    accentColorValue: 0xFFE84C3D, // kräftiges Arcade-Rot
    secondaryColorValue: 0xFF3DC0E8, // Arcade-Blau
    backgroundColorValue: 0xFF1B1035,
    surfaceColorValue: 0xFF2E1F5E,
    cardRadius: 0,
    borderWidth: 3,
    fontFamily: 'monospace',
  ),
  SpecialStyleItem(
    id: 'ink_comic',
    name: 'Grotesque Underground / Ink & Comic',
    description: 'Monochromes Schwarz-Weiß mit Gift-Grün- oder Blutrot-Akzent.',
    price: 750,
    accentColorValue: 0xFF39FF14, // Gift-Grün
    secondaryColorValue: 0xFFB80000, // Blutrot
    backgroundColorValue: 0xFF0E0E0E,
    surfaceColorValue: 0xFFFFFFFF,
    cardRadius: 0,
    borderWidth: 3,
    roughBorderHint: true,
  ),
];

SpecialStyleItem? specialStyleById(String? id) {
  if (id == null) return null;
  for (final s in specialStyles) {
    if (s.id == id) return s;
  }
  return null;
}
