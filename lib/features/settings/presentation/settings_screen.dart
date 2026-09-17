import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme_lab/presentation/color_admin_section.dart';
import '../application/app_settings_providers.dart';

/// Einstellungen (Zahnrad-Symbol): freie Farb-Administration +
/// Audio-Schalter. Bewusst getrennt vom Milch-Shop (siehe
/// theme_and_shop_screen.dart) – hier geht es um "wie sieht/verhält
/// sich meine App", dort um "was kaufe ich mit Kuh-Milch".
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ColorAdminSection(
        leading: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sound-Effekte'),
            subtitle: const Text(
              'Kurzes Schaf-Blöken beim Erledigen, "Muh" beim Mergen '
              '(freie Mudchute-Park-&-Farm-Tieraufnahmen).',
            ),
            value: settings.soundEnabled,
            onChanged: notifier.setSoundEnabled,
          ),
          const Divider(),
          const Text('Farben', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
