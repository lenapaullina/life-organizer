import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../budget/application/budget_providers.dart';
import '../../gesundheit/application/gesundheit_providers.dart';
import '../../haushalt/application/household_task_providers.dart';
import '../../kontakte/application/contact_providers.dart';
import '../../vorrat/application/pantry_providers.dart';
import '../../wo_liegt_was/application/storage_location_providers.dart';

enum SearchCategory { haushalt, vorrat, kontakt, budget, termin, medikament, wo }

extension SearchCategoryUi on SearchCategory {
  String get label => switch (this) {
        SearchCategory.haushalt => 'Haushalt',
        SearchCategory.vorrat => 'Vorrat',
        SearchCategory.kontakt => 'Kontakt',
        SearchCategory.budget => 'Budget',
        SearchCategory.termin => 'Termin',
        SearchCategory.medikament => 'Medikament',
        SearchCategory.wo => 'Wo liegt was',
      };

  IconData get icon => switch (this) {
        SearchCategory.haushalt => Icons.checklist,
        SearchCategory.vorrat => Icons.kitchen_outlined,
        SearchCategory.kontakt => Icons.people_outline,
        SearchCategory.budget => Icons.account_balance_wallet_outlined,
        SearchCategory.termin => Icons.medical_services_outlined,
        SearchCategory.medikament => Icons.medication_outlined,
        SearchCategory.wo => Icons.search,
      };
}

class SearchResultItem {
  final SearchCategory category;
  final String id;
  final String title;
  final String subtitle;
  final String? appointmentNotes; // nur für category == termin

  const SearchResultItem({
    required this.category,
    required this.id,
    required this.title,
    required this.subtitle,
    this.appointmentNotes,
  });
}

final searchQueryProvider = StateProvider<String>((ref) => '');

/// Durchsucht alle Module clientseitig nach dem eingegebenen Text.
/// Bewusst nur Namen/Titel, keine Volltextsuche über Notizfelder –
/// das würde bei Kontakt-/Termin-Notizen zu viel Streuung erzeugen.
final searchResultsProvider = Provider<List<SearchResultItem>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return [];

  final results = <SearchResultItem>[];
  bool matches(String text) => text.toLowerCase().contains(query);

  for (final t in ref.watch(sortedHouseholdTasksProvider).valueOrNull ?? []) {
    if (matches(t.task.name)) {
      results.add(SearchResultItem(
        category: SearchCategory.haushalt,
        id: t.task.id,
        title: t.task.name,
        subtitle: 'Alle ${t.task.intervalDays} Tage',
      ));
    }
  }

  for (final p in ref.watch(sortedPantryItemsProvider).valueOrNull ?? []) {
    if (matches(p.item.name)) {
      results.add(SearchResultItem(
        category: SearchCategory.vorrat,
        id: p.item.id,
        title: p.item.name,
        subtitle: p.status.daysRemaining < 0 ? 'Abgelaufen' : 'Noch ${p.status.daysRemaining} Tage',
      ));
    }
  }

  for (final c in ref.watch(sortedContactsProvider).valueOrNull ?? []) {
    if (matches(c.contact.name)) {
      results.add(SearchResultItem(
        category: SearchCategory.kontakt,
        id: c.contact.id,
        title: c.contact.name,
        subtitle: 'Kontakt',
      ));
    }
  }

  for (final e in ref.watch(envelopesWithStatusProvider).valueOrNull ?? []) {
    if (matches(e.envelope.name)) {
      results.add(SearchResultItem(
        category: SearchCategory.budget,
        id: e.envelope.id,
        title: e.envelope.name,
        subtitle: 'Umschlag',
      ));
    }
  }

  for (final a in ref.watch(sortedAppointmentsProvider).valueOrNull ?? []) {
    if (matches(a.appointment.name)) {
      results.add(SearchResultItem(
        category: SearchCategory.termin,
        id: a.appointment.id,
        title: a.appointment.name,
        subtitle: 'Termin',
        appointmentNotes: a.appointment.notes,
      ));
    }
  }

  for (final m in ref.watch(medicationsProvider).valueOrNull ?? []) {
    if (matches(m.name)) {
      results.add(SearchResultItem(
        category: SearchCategory.medikament,
        id: m.id,
        title: m.name,
        subtitle: m.dosageNote ?? 'Medikament',
      ));
    }
  }

  for (final s in ref.watch(storageLocationsProvider).valueOrNull ?? []) {
    if (matches(s.itemName)) {
      results.add(SearchResultItem(
        category: SearchCategory.wo,
        id: s.id,
        title: s.itemName,
        subtitle: s.location,
      ));
    }
  }

  return results;
});
