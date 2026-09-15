import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Wählt ein Bild aus der Galerie und kopiert es dauerhaft ins
/// App-Verzeichnis (photos/). Notwendig, weil der von image_picker
/// zurückgegebene Pfad oft nur ein temporärer Cache-Pfad ist, der
/// jederzeit vom System aufgeräumt werden kann – die App braucht
/// aber einen stabilen, dauerhaften Speicherort.
///
/// Gibt null zurück, wenn die Auswahl abgebrochen wurde.
Future<String?> pickAndPersistImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
  if (picked == null) return null;

  final docsDir = await getApplicationDocumentsDirectory();
  final photosDir = Directory(p.join(docsDir.path, 'photos'));
  if (!await photosDir.exists()) {
    await photosDir.create(recursive: true);
  }

  final ext = p.extension(picked.path);
  final newPath = p.join(photosDir.path, '${const Uuid().v4()}$ext');
  await File(picked.path).copy(newPath);
  return newPath;
}
