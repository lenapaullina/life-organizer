import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Erzeugt einen neuen, dauerhaften Pfad für eine Sprachmemo-Aufnahme
/// (im App-Verzeichnis unter `voice_memos/`), analog zu
/// `pickAndPersistImage` in `image_storage.dart`. Die Datei existiert
/// nach diesem Aufruf noch nicht – der aufrufende Recorder erzeugt sie
/// erst beim Start der Aufnahme.
Future<String> newVoiceMemoPath() async {
  final docsDir = await getApplicationDocumentsDirectory();
  final memosDir = Directory(p.join(docsDir.path, 'voice_memos'));
  if (!await memosDir.exists()) {
    await memosDir.create(recursive: true);
  }
  return p.join(memosDir.path, '${const Uuid().v4()}.m4a');
}

/// Löscht eine alte Sprachmemo-Datei (z. B. beim Neu-Aufnehmen oder
/// Löschen). Bewusst fehlertolerant: eine bereits fehlende oder aus
/// irgendeinem Grund nicht löschbare Datei darf die eigentliche
/// Aktion (Neuaufnahme speichern) nie zum Absturz bringen.
Future<void> deleteVoiceMemo(String? path) async {
  if (path == null) return;
  try {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  } catch (_) {
    // Fail-safe: Datei bleibt im schlimmsten Fall einfach liegen.
  }
}
