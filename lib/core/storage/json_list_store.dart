import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Sehr einfacher, rein lokaler Persistenz-Baustein für Module, die
/// (noch) keine eigene Drift-Tabelle brauchen: eine Liste von
/// JSON-Objekten in einer einzelnen Datei im App-Verzeichnis.
///
/// Bewusste Abweichung von Modul 1/3/4/5/6 (die Drift/SQLite nutzen):
/// neue Drift-Tabellen brauchen einen `build_runner`-Lauf, der die
/// generierte `database.g.dart` aktualisiert. Für zwei komplett neue,
/// von den bestehenden Tabellen unabhängige Module (Watchlist,
/// Ausleihe-Tracker) ist ein einfacher JSON-Store der pragmatischere
/// Weg, ohne die bestehende, große generierte Datei von Hand anfassen
/// zu müssen. Genau wie die Drift-DB liegt die Datei ausschließlich
/// lokal im App-Sandbox-Verzeichnis – keine Cloud, kein Netzwerk.
class JsonListStore {
  final String fileName;
  File? _file;

  JsonListStore(this.fileName);

  Future<File> _getFile() async {
    if (_file != null) return _file!;
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, fileName));
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }
    _file = file;
    return file;
  }

  /// Liest alle Einträge. Bei fehlender/kaputter Datei wird eine
  /// leere Liste zurückgegeben, statt die App abstürzen zu lassen –
  /// lieber leerer Zustand als Crash beim Start.
  Future<List<Map<String, dynamic>>> readAll() async {
    try {
      final file = await _getFile();
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final decoded = jsonDecode(content) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> writeAll(List<Map<String, dynamic>> items) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(items));
  }
}
