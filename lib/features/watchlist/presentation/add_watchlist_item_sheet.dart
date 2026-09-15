import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/watchlist_providers.dart';
import '../watchlist_item.dart';

void showAddWatchlistItemSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => const _AddWatchlistItemSheet(),
  );
}

class _AddWatchlistItemSheet extends ConsumerStatefulWidget {
  const _AddWatchlistItemSheet();

  @override
  ConsumerState<_AddWatchlistItemSheet> createState() => _AddWatchlistItemSheetState();
}

class _AddWatchlistItemSheetState extends ConsumerState<_AddWatchlistItemSheet> {
  final _titleController = TextEditingController();
  final _whereController = TextEditingController();
  final _noteController = TextEditingController();
  WatchMood? _mood;

  @override
  void dispose() {
    _titleController.dispose();
    _whereController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    await ref.read(watchlistProvider.notifier).addItem(
          title: title,
          whereToStream: _whereController.text,
          mood: _mood,
          note: _noteController.text,
        );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Neu auf der Watchlist', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Titel',
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _whereController,
              decoration: const InputDecoration(
                labelText: 'Wo streambar? (optional)',
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Stimmung', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                for (final mood in WatchMood.values)
                  ChoiceChip(
                    label: Text(mood.label),
                    selected: _mood == mood,
                    onSelected: (selected) => setState(() => _mood = selected ? mood : null),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _noteController,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notiz (optional)',
                filled: true,
                fillColor: AppColors.surfaceMuted,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Hinzufügen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
