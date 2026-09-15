/// Großzügige, konsistente Abstands-Skala.
/// Bewusst wenig Werte, damit im ganzen Team/Code nie "mal eben"
/// ein neuer krummer Abstand erfunden wird.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Bewusst kantiger als vorher (16/12) für den MySpace/Y2K-Look:
  // spürbar abgerundet, aber nicht "modern-rund".
  static const double cardRadius = 8;
  static const double buttonRadius = 6;
  static const double pillRadius = 999;
}
