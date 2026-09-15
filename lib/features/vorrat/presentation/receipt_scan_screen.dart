import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/utils/image_storage.dart';
import '../application/pantry_providers.dart';

/// WICHTIG: Es findet KEINE automatische Texterkennung des Kassenbons
/// statt – das Foto dient nur als Gedächtnisstütze beim Abtippen.
/// Alle Artikel bekommen dasselbe Standard-MHD (7 Tage), das danach
/// in der normalen Vorrat-Liste pro Artikel angepasst werden kann.
class ReceiptScanScreen extends ConsumerStatefulWidget {
  const ReceiptScanScreen({super.key});

  @override
  ConsumerState<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

class _ReceiptScanScreenState extends ConsumerState<ReceiptScanScreen> {
  String? _photoPath;
  final List<TextEditingController> _itemControllers = [TextEditingController()];
  int _defaultShelfLifeDays = 7;

  Future<void> _pickPhoto() async {
    final path = await pickAndPersistImage();
    if (path != null) setState(() => _photoPath = path);
  }

  void _addRow() => setState(() => _itemControllers.add(TextEditingController()));

  Future<void> _submitAll() async {
    final repo = ref.read(pantryRepositoryProvider);
    final expiry = DateTime.now().add(Duration(days: _defaultShelfLifeDays));

    for (final controller in _itemControllers) {
      final name = controller.text.trim();
      if (name.isEmpty) continue;
      await repo.createItem(name: name, expiryDate: expiry);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kassenbon einbuchen')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text(
            'Kein Auto-Scan: das Foto hilft dir nur beim Abtippen, du '
            'trägst die Artikel unten selbst ein.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_photoPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              child: Image.file(File(_photoPath!), height: 220, fit: BoxFit.cover, width: double.infinity),
            )
          else
            OutlinedButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Foto vom Kassenbon wählen'),
            ),
          const SizedBox(height: AppSpacing.lg),
          Text('Artikel', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < _itemControllers.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: TextField(
                controller: _itemControllers[i],
                decoration: InputDecoration(labelText: 'Artikel ${i + 1}'),
              ),
            ),
          TextButton.icon(
            onPressed: _addRow,
            icon: const Icon(Icons.add),
            label: const Text('Weiterer Artikel'),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Text('Standard-MHD:'),
              Expanded(
                child: Slider(
                  value: _defaultShelfLifeDays.toDouble(),
                  min: 1,
                  max: 60,
                  divisions: 59,
                  label: '$_defaultShelfLifeDays Tage',
                  onChanged: (v) => setState(() => _defaultShelfLifeDays = v.round()),
                ),
              ),
              Text('$_defaultShelfLifeDays Tage'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(onPressed: _submitAll, child: const Text('Alle einbuchen')),
        ],
      ),
    );
  }
}
