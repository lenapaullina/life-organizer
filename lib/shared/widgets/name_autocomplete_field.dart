import 'package:flutter/material.dart';

/// Freitext-Eingabefeld mit Autovervollständigung aus einer Liste von
/// Vorschlägen (feste Presets + selbst gespeicherte Vorlagen). Tippen
/// bleibt weiterhin jederzeit möglich – die Vorschlagsliste ist reine
/// Komfort-Hilfe, kein Zwang zur Auswahl.
///
/// [onChanged] feuert bei jeder Texteingabe (auch Freitext).
/// [onSuggestionSelected] feuert zusätzlich NUR, wenn ein Eintrag aus
/// der Vorschlagsliste angetippt wurde – die aufrufende Stelle nutzt
/// das, um z. B. bei einer bekannten Vorlage automatisch Zyklus/
/// Kategorie mit vorzubefüllen.
class NameAutocompleteField extends StatelessWidget {
  final String label;
  final List<String> suggestions;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSuggestionSelected;

  const NameAutocompleteField({
    super.key,
    required this.label,
    required this.suggestions,
    required this.onChanged,
    this.initialValue = '',
    this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) return suggestions;
        return suggestions.where((s) => s.toLowerCase().contains(query));
      },
      onSelected: (selection) {
        onChanged(selection);
        onSuggestionSelected?.call(selection);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          decoration: InputDecoration(labelText: label),
          onChanged: onChanged,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 320),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
