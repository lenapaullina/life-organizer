import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
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

/// Sound-Events, für die ein Ton abgespielt werden soll.
enum SoundEvent { taskComplete, merge }

/// Ein einziger, wiederverwendeter [AudioPlayer] statt pro Sound-Event einen
/// neuen zu erstellen – vermeidet unnötigen Overhead bei häufigen Erfolgen
/// (z. B. viele abgehakte Haushalts-Tasks hintereinander).
final _soundPlayer = AudioPlayer();

/// Datei je [SoundEvent], jeweils unter `assets/sounds/` (siehe
/// `assets/sounds/ATTRIBUTION.txt` für Lizenz/Quelle: freie
/// Mudchute-Park-&-Farm-Tieraufnahmen von Lena, CC-BY-SA/GFDL).
///
/// Zuordnung bewusst thematisch statt zufällig gewählt: das Schaf für
/// "Task erledigt" (kurz, unaufdringlich, passt zum ADHS-freundlichen
/// leisen Ping), die Kuh fürs Mergen (die Kern-Spielmechanik dreht sich
/// ja um Kühe). Ente/Schwein/Lamm liegen als Bonus-Assets bereit, falls
/// später mehr Abwechslung gewünscht ist.
const _soundAssetByEvent = <SoundEvent, String>{
  SoundEvent.taskComplete: 'sounds/Mudchute_sheep_1.ogg',
  SoundEvent.merge: 'sounds/Mudchute_cow_1.ogg',
};

/// Spielt den zu [event] gehörenden Ton ab, sofern Sound in den
/// Einstellungen aktiviert ist. Bewusst "fire-and-forget" mit
/// `catchError`: ein Problem bei der Audiowiedergabe (z. B. fehlendes
/// Asset, Plattform-Codec-Problem) darf NIEMALS die eigentliche
/// Task-Erledigung/Merge-Aktion blockieren oder die App zum Absturz
/// bringen – im schlimmsten Fall bleibt es einfach stumm.
void maybePlaySound(bool soundEnabled, SoundEvent event) {
  if (!soundEnabled) return;
  final asset = _soundAssetByEvent[event];
  if (asset == null) return;
  _soundPlayer.play(AssetSource(asset)).catchError((Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('Sound konnte nicht abgespielt werden ($asset): $error');
    }
  });
}

/// Haptisches Feedback ist unabhängig vom Sound-Schalter immer an –
/// fühlbares Feedback braucht keine Audio-Datei und funktioniert
/// garantiert auf jedem Gerät mit Vibrationsmotor.
void hapticTaskComplete() => HapticFeedback.lightImpact();
void hapticMerge() => HapticFeedback.mediumImpact();
