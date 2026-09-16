import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/json_object_store.dart';
import '../domain/app_settings.dart';

final _appSettingsStoreProvider = Provider((ref) => JsonObjectStore('app_settings.json'));

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final JsonObjectStore _store;

  AppSettingsNotifier(this._store) : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final raw = await _store.read();
    if (raw.isNotEmpty) {
      state = AppSettings.fromJson(raw);
    }
  }

  Future<void> setSoundEnabled(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _store.write(state.toJson());
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier(ref.watch(_appSettingsStoreProvider));
});

/// Sound-Events, für die (perspektivisch) ein Ton abgespielt werden soll.
enum SoundEvent { taskComplete, merge }

/// Bewusster, ehrlicher Scoping-Hinweis: Diese Sandbox hat keinen
/// Netzwerkzugriff auf pub.dev, um ein Audio-Package (z. B.
/// `audioplayers`) zu prüfen, und es liegen keine Sound-Assets vor.
/// Diese Funktion ist der vorbereitete "Hook" dafür – sie tut aktuell
/// nichts Hörbares, respektiert aber schon den An/Aus-Schalter aus den
/// Einstellungen, sodass ein echtes Sound-Package später nur noch HIER
/// eingehängt werden muss, ohne den Rest der App anzufassen.
void maybePlaySound(bool soundEnabled, SoundEvent event) {
  if (!soundEnabled) return;
  // TODO(Sound): echtes Audio-Package einhängen, sobald geprüft/verfügbar.
}

/// Haptisches Feedback ist unabhängig vom Sound-Schalter immer an –
/// fühlbares Feedback braucht keine Audio-Datei und funktioniert
/// garantiert auf jedem Gerät mit Vibrationsmotor.
void hapticTaskComplete() => HapticFeedback.lightImpact();
void hapticMerge() => HapticFeedback.mediumImpact();
