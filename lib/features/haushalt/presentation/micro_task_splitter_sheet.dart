import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../micro_task_splitter.dart';

/// Öffnet den "Aufgabe Zerstückler" für eine einzelne Haushaltsaufgabe.
/// Gibt `true` zurück, wenn die Person die ganze Aufgabe direkt aus
/// dem Sheet heraus als erledigt markiert hat – die aufrufende Stelle
/// ruft dann `markCompleted` auf, damit die Statuslogik unverändert
/// an einer Stelle bleibt.
Future<bool?> showMicroTaskSplitterSheet(BuildContext context, String taskName) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
    ),
    builder: (_) => _MicroTaskSplitterSheet(taskName: taskName),
  );
}

class _MicroTaskSplitterSheet extends StatefulWidget {
  final String taskName;
  const _MicroTaskSplitterSheet({required this.taskName});

  @override
  State<_MicroTaskSplitterSheet> createState() => _MicroTaskSplitterSheetState();
}

class _MicroTaskSplitterSheetState extends State<_MicroTaskSplitterSheet> {
  late List<String> _steps;
  final _checked = <int>{};
  bool _editingOwnSteps = false;
  late final TextEditingController _ownStepsController;

  @override
  void initState() {
    super.initState();
    _steps = microTaskStepsFor(widget.taskName);
    _ownStepsController = TextEditingController();
  }

  @override
  void dispose() {
    _ownStepsController.dispose();
    super.dispose();
  }

  void _applyOwnSteps() {
    final lines = _ownStepsController.text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.isEmpty) return;
    setState(() {
      _steps = lines;
      _checked.clear();
      _editingOwnSteps = false;
    });
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
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                ),
              ),
            ),
            Text(
              '„${widget.taskName}“ in Schritten',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Häkchen gelten nur für jetzt – wenn du weiter unten auf\n'
              '"Ganze Aufgabe erledigt" tippst, zählt es wie gewohnt.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_editingOwnSteps) ...[
              TextField(
                controller: _ownStepsController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Eigene Schritte, ein Schritt pro Zeile …',
                  filled: true,
                  fillColor: AppColors.surfaceMuted,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _applyOwnSteps,
                  child: const Text('Übernehmen'),
                ),
              ),
            ] else ...[
              for (var i = 0; i < _steps.length; i++)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _checked.contains(i),
                  title: Text(
                    _steps[i],
                    style: TextStyle(
                      decoration: _checked.contains(i) ? TextDecoration.lineThrough : null,
                      color: _checked.contains(i) ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    if (value == true) {
                      _checked.add(i);
                    } else {
                      _checked.remove(i);
                    }
                  }),
                ),
              const SizedBox(height: AppSpacing.xs),
              TextButton.icon(
                onPressed: () => setState(() => _editingOwnSteps = true),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Eigene Schritte eintippen'),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Ganze Aufgabe erledigt'),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Schließen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
