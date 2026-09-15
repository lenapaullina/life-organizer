import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/watchlist_providers.dart';
import '../watchlist_item.dart';
import 'add_watchlist_item_sheet.dart';

/// Watchlist mit "Wo streambar?" und Stimmungs-Tag – Ziel ist, bei
/// Überreizung nicht erst lange suchen zu müssen, was gerade passt.
class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(filteredWatchlistProvider);
    final activeFilter = ref.watch(watchlistMoodFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddWatchlistItemSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            child: Wrap(
              spacing: AppSpacing.xs,
              children: [
                ChoiceChip(
                  label: const Text('Alle'),
                  selected: activeFilter == null,
                  onSelected: (_) => ref.read(watchlistMoodFilterProvider.notifier).state = null,
                ),
                for (final mood in WatchMood.values)
                  ChoiceChip(
                    label: Text(mood.label),
                    selected: activeFilter == mood,
                    onSelected: (selected) => ref.read(watchlistMoodFilterProvider.notifier).state =
                        selected ? mood : null,
                  ),
              ],
            ),
          ),
          Expanded(
            child: itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Fehler: $err')),
              data: (items) {
                if (items.isEmpty) {
                  return const _EmptyState();
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) => _WatchlistCard(item: items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchlistCard extends ConsumerWidget {
  final WatchlistItem item;
  const _WatchlistCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Opacity(
        opacity: item.watched ? 0.55 : 1,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  item.watched ? Icons.check_circle : Icons.circle_outlined,
                  color: item.watched ? AppColors.statusGreen : AppColors.textSecondary,
                ),
                onPressed: () => ref.read(watchlistProvider.notifier).toggleWatched(item.id),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: item.watched ? TextDecoration.lineThrough : null,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (item.mood != null)
                          Chip(
                            label: Text(item.mood!.label, style: const TextStyle(fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ),
                        if (item.whereToStream != null)
                          Chip(
                            avatar: const Icon(Icons.live_tv_outlined, size: 16),
                            label: Text(item.whereToStream!, style: const TextStyle(fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    if (item.note != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.note!,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => ref.read(watchlistProvider.notifier).deleteItem(item.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'Noch nichts auf der Watchlist.\nTippe auf + um etwas hinzuzufügen.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
