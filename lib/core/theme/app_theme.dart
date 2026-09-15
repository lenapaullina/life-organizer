import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// MySpace/Y2K-Redesign: dunkler Hintergrund, laute Neon-Akzente
/// (Pink + Cyan), dicke kontrastreiche Ränder statt sanfter
/// Schatten, fette Überschriften mit leichtem Neon-Glow. Die
/// Status-Ampel (Grün/Gelb/Rot, siehe AppColors) bleibt als
/// eigenständiges, sofort erkennbares Signal erhalten – nur eben
/// jetzt neongrell statt gedämpft.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
        surface: AppColors.surface,
        primary: AppColors.accent,
        secondary: AppColors.accentCyan,
        error: AppColors.statusRed,
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          color: AppColors.textPrimary,
          shadows: [Shadow(color: AppColors.accent.withOpacity(0.6), blurRadius: 10)],
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        shadowColor: AppColors.accentCyan,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: Colors.white,
        ),
        // AppBarTheme.shape ist ein ShapeBorder (kein BoxBorder) – für den
        // Neon-Unterkante-Effekt sorgt hier vor allem shadowColor oben.
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accentBg,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accentCyan),
        ),
        iconTheme: MaterialStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(MaterialState.selected) ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.accentBg,
        backgroundColor: AppColors.surfaceMuted,
        side: const BorderSide(color: AppColors.accentCyan, width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 3,
        shadowColor: AppColors.accentPink.withOpacity(0.45),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: const BorderSide(color: AppColors.border, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: AppColors.accentCyan,
          side: const BorderSide(color: AppColors.accentCyan, width: 2),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentCyan,
          side: const BorderSide(color: AppColors.accentCyan, width: 2),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.accentCyan, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.accentCyan,
        textColor: AppColors.textPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceMuted,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          side: const BorderSide(color: AppColors.accentCyan, width: 1.5),
        ),
        actionTextColor: AppColors.accentCyan,
      ),
    );
  }
}
