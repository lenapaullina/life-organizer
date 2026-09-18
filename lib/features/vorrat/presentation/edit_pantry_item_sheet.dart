import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/name_autocomplete_field.dart';
import '../application/pantry_extra_providers.dart';
import '../application/pantry_providers.dart';
import '../application/pantry_template_providers.dart';

/// Volle Editierbarkeit eines bestehenden Vorratsartikels: Name,
/// Menge, Kategorie (aktuell frei über den Namen abgedeckt – ein
/// eigenes Kategoriefeld gibt es in dieser App-Version noch nicht),
/// MHD und Nachkauf-Zyklus. Erreichbar per Tap auf die Karte in
/// `pantry_screen.dart`.
Future<void> showEditPantryItemSheet(BuildContext context, WidgetRef ref, PantryItem item) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => _EditPantryItemSheet(item: item),
  );
}

class _EditPantryItemSheet extends ConsumerStatefulWidget {
  final PantryItem item;
  const _EditPantryItemSheet({required this.item});

  @override
  ConsumerState<_EditPantryItemSheet> createState() => _EditPantryItemSheetState();
}

class _EditPantryItemSheetState extends ConsumerState<_EditPantryItemSheet> {
  late String _name = widget.item.name;
  late final _quantityController = TextEditingController();
  late final _cycleController = TextEditingController();
  late final _daysGoodAfterOpeningController = TextEditingController();
  late DateTime _expiryDate = widget.item.expiryDate;
  late int? _daysGoodAfterOpening = widget.item.daysGoodAfterOpening;
  bool _saveAsTemplate = false;

  @override
  void initState() {
    super.initState();
    final extra = ref.read(pantryExtraProvider)[widget.item.id];
    _quantityController.text = extra?.quantity ?? '';
    _cycleController.text = extra?.cycleDays?.toString() ?? '';
    _daysGoodAfterOpeningController.text = widget.item.daysGoodAfterOpening?.toString() ?? '';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _cycleController.dispose();
    _daysGoodAfterOpeningController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      helpText: 'Mindesthaltbarkeitsdatum',
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  int? get _cycleDays {
    final text = _cycleController.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  Future<void> _submit() async {
    final name = _name.trim();
    if (name.isEmpty) return;

    await ref.read(pantryRepositoryProvider).updateItem(
          id: widget.item.id,
          name: name,
          expiryDate: _expiryDate,
          icon: widget.item.icon,
          category: widget.item.category,
          daysGoodAfterOpening: _daysGoodAfterOpening,
          clearDaysGoodAfterOpening: _daysGoodAfterOpening == null,
        );

    await ref.read(pantryExtraProvider.notifier).setExtra(
          widget.item.id,
          quantity: _quantityController.text,
          cycleDays: _cycleDays,
        );

    if (_saveAsTemplate) {
      await ref.read(pantryTemplateProvider.notifier).saveTemplate(
            name: name,
            daysGoodAfterOpening: _daysGoodAfterOpening,
            cycleDays: _cycleDays,
          );
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await ref.read(pantryRepositoryProvider).deleteItem(widget.item.id);
    await ref.read(pantryExtraProvider.notifier).removeExtra(widget.item.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = '${_expiryDate.day}.${_expiryDate.month}.${_expiryDate.year}';
    final templates = ref.watch(pantryTemplateProvider).valueOrNull ?? const [];
    final suggestionNames = {for (final t in templates) t.name}.toList()..sort();

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Artikel bearbeiten', style: Theme.of(context).textTheme.headlineMedium),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Löschen',
                  onPressed: _delete,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            NameAutocompleteField(
              label: 'Produktname',
              suggestions: suggestionNames,
              initialValue: _name,
              onChanged: (value) => _name = value,
            ),
            const SizedBox(height: AppSpacing.sm),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Als Vorlage speichern'),
              value: _saveAsTemplate,
              onChanged: (v) => setState(() => _saveAsTemplate = v ?? false),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Menge (optional)',
                hintText: 'z. B. 2 Stück, 1L, 500g',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mindesthaltbarkeitsdatum'),
              subtitle: Text(dateLabel),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickExpiryDate,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              keyboardType: TextInputType.number,
              controller: _daysGoodAfterOpeningController,
              decoration: const InputDecoration(
                labelText: 'Haltbar nach Öffnung (Tage, optional)',
              ),
              onChanged: (v) => _daysGoodAfterOpening = int.tryParse(v.trim()),
            ),
            const SizedBox(height: AppSpacing.md),
            // Zyklus/Intervall als Zahlenfeld statt Slider.
            TextField(
              controller: _cycleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nachkauf-Zyklus in Tagen (optional)',
                hintText: 'z. B. 14',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
