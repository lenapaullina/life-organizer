import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/notifications/notification_service.dart';
import 'features/theme_lab/application/theme_settings_providers.dart';
import 'features/haushalt/presentation/household_screen.dart';
import 'features/mehr/presentation/more_screen.dart';
import 'features/routinen/application/routine_providers.dart';
import 'features/routinen/presentation/add_routine_sheet.dart';
import 'features/routinen/presentation/routine_screen.dart';
import 'features/start/presentation/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const ProviderScope(child: LifeOrganizerApp()));
}

class LifeOrganizerApp extends ConsumerWidget {
  const LifeOrganizerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dynamisches Theme statt fester AppTheme.dark-Konstante: reagiert
    // live auf die freie Farb-Administration bzw. einen aktivierten
    // Special-Style aus dem Milch-Shop (siehe theme_settings_providers.dart).
    final theme = ref.watch(dynamicThemeProvider);
    return MaterialApp(
      title: 'Vergissmeinnicht',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const _RootScreen(),
    );
  }
}

/// Bewusst flache Navigation (2 Tabs statt Drawer/Untermenüs) –
/// weniger Klicks zum Ziel ist wichtiger als visuelle Eleganz.
/// Weitere Module kommen in Phase 3+ als weitere Tabs dazu.
class _RootScreen extends StatefulWidget {
  const _RootScreen();

  @override
  State<_RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<_RootScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const StartScreen(),
      const HouseholdScreen(),
      const _RoutinenTab(),
      const MoreScreen(),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Start'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Haushalt'),
          NavigationDestination(icon: Icon(Icons.wb_sunny_outlined), label: 'Routinen'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Mehr'),
        ],
      ),
    );
  }
}

class _RoutinenTab extends ConsumerWidget {
  const _RoutinenTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Routinen')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddRoutineSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: routinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
        data: (routines) {
          if (routines.isEmpty) {
            return const Center(child: Text('Noch keine Routine angelegt.'));
          }
          return ListView(
            children: routines
                .map(
                  (r) => ListTile(
                    title: Text(r.name),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RoutineScreen(routine: r),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
