import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../ausleihe/presentation/loan_screen.dart';
import '../../budget/presentation/budget_screen.dart';
import '../../gesundheit/presentation/gesundheit_screen.dart';
import '../../kontakte/presentation/contacts_screen.dart';
import '../../vorrat/presentation/pantry_screen.dart';
import '../../watchlist/presentation/watchlist_screen.dart';
import '../../wo_liegt_was/presentation/storage_locations_screen.dart';
import '../../zutatenplaner/presentation/zutatenplaner_screen.dart';
import 'style_showcase_screen.dart';

/// Bündelt Module, die man seltener öffnet als Haushalt/Routinen,
/// als Liste statt als eigene Bottom-Nav-Tabs. So bleibt die
/// Hauptnavigation klein (4 statt 6+ Tabs), ohne dass Module
/// verloren gehen – wichtig für "klickarm/reizarm" bei wachsendem
/// Funktionsumfang.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.kitchen_outlined,
        label: 'Vorrat',
        builder: (BuildContext _) => const PantryScreen(),
      ),
      (
        icon: Icons.people_outline,
        label: 'Lenas Grüne Seiten',
        builder: (BuildContext _) => const ContactsScreen(),
      ),
      (
        icon: Icons.account_balance_wallet_outlined,
        label: 'Budget',
        builder: (BuildContext _) => const BudgetScreen(),
      ),
      (
        icon: Icons.favorite_border,
        label: 'Gesundheit',
        builder: (BuildContext _) => const GesundheitScreen(),
      ),
      (
        icon: Icons.search,
        label: 'Wo liegt was?',
        builder: (BuildContext _) => const StorageLocationsScreen(),
      ),
      (
        icon: Icons.soup_kitchen_outlined,
        label: 'Zutatenplaner',
        builder: (BuildContext _) => const ZutatenplanerScreen(),
      ),
      (
        icon: Icons.movie_outlined,
        label: 'Watchlist',
        builder: (BuildContext _) => const WatchlistScreen(),
      ),
      (
        icon: Icons.swap_horiz,
        label: 'Ausleihe',
        builder: (BuildContext _) => const LoanScreen(),
      ),
      (
        icon: Icons.style_outlined,
        label: 'Style-Vorschau',
        builder: (BuildContext _) => const StyleShowcaseScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mehr')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: item.builder),
              ),
            ),
          );
        },
      ),
    );
  }
}
