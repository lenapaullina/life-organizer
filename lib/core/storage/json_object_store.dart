import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Wie [JsonListStore], aber für genau EIN JSON-Objekt statt einer
/// Liste – gedacht für Einstellungen/Zustand, von dem es nur eine
/// Version gibt (z. B. Theme-Einstellungen, Kuh-Weide/Milch-Stand).
///
/// Gleiche bewusste Architektur-Entscheidung wie bei [JsonListStore]:
/// kein neues Drift-Schema (bräuchte build_runner), sondern eine
/// einfache lokale Datei im App-Verzeichnis.
class JsonObjectStore {
  final String fileName;
  File? _file;

  JsonObjectStore(this.fileName);

  Future<File> _getFile() async {
    if (_file != null) return _file!;
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, fileName));
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('{}');
    }
    _file = file;
    return file;
  }

  /// Liest das gespeicherte Objekt. Bei fehlender/kaputter Datei wird
  /// ein leeres Objekt zurückgegeben (der Aufrufer füllt dann seine
  /// eigenen Default-Werte ein), statt die App abstürzen zu lassen.
  Future<Map<String, dynamic>> read() async {
    try {
      final file = await _getFile();
      final content = await file.readAsString();
      if (content.trim().isEmpty) return {};
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> write(Map<String, dynamic> data) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(data));
  }
}
