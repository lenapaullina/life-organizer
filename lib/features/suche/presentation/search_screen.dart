import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../budget/presentation/budget_screen.dart';
import '../../budget/presentation/envelope_detail_screen.dart';
import '../../gesundheit/presentation/appointment_detail_screen.dart';
import '../../gesundheit/presentation/gesundheit_screen.dart';
import '../../haushalt/presentation/household_screen.dart';
import '../../kontakte/presentation/contact_detail_screen.dart';
import '../../vorrat/presentation/pantry_screen.dart';
import '../application/search_providers.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  void _openResult(BuildContext context, SearchResultItem result) {
    final Widget target = switch (result.category) {
      // Haushalt/Vorrat/Budget/Medikamente haben keine Einzel-Detailansicht
      // -> öffnet die jeweilige Übersicht, in der der Eintrag zu finden ist.
      SearchCategory.haushalt => const HouseholdScreen(),
      SearchCategory.vorrat => const PantryScreen(),
      SearchCategory.budget => EnvelopeDetailScreen(envelopeId: result.id),
      SearchCategory.medikament => const GesundheitScreen(),
      SearchCategory.kontakt => ContactDetailScreen(contactId: result.id),
      SearchCategory.termin => AppointmentDetailScreen(
          appointmentId: result.id,
          appointmentName: result.title,
          initialNotes: result.appointmentNotes,
        ),
      SearchCategory.wo => const SizedBox.shrink(), // wird separat behandelt
    };

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Alles durchsuchen …',
            border: InputBorder.none,
          ),
          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
        ),
      ),
      body: results.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Tippe, um über alle Module hinweg zu suchen.',
                  style: TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final r = results[index];
                return Card(
                  child: ListTile(
                    leading: Icon(r.category.icon, color: AppColors.accent),
                    title: Text(r.title),
                    subtitle: Text('${r.category.label} · ${r.subtitle}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openResult(context, r),
                  ),
                );
              },
            ),
    );
  }
}
