/// Allgemeine App-Einstellungen, die nichts mit Farben zu tun haben
/// (die liegen in `theme_lab/domain/custom_color_settings.dart`).
/// Aktuell nur der Sound-Schalter, aber bewusst als eigenes,
/// erweiterbares Objekt statt als lose Variable irgendwo.
class AppSettings {
  final bool soundEnabled;

  const AppSettings({this.soundEnabled = false});

  AppSettings copyWith({bool? soundEnabled}) {
    return AppSettings(soundEnabled: soundEnabled ?? this.soundEnabled);
  }

  Map<String, dynamic> toJson() => {'soundEnabled': soundEnabled};

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(soundEnabled: json['soundEnabled'] as bool? ?? false);
  }
}
