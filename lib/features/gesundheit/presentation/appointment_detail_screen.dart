import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../application/gesundheit_providers.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  final String appointmentId;
  final String appointmentName;
  final String? initialNotes;

  const AppointmentDetailScreen({
    super.key,
    required this.appointmentId,
    required this.appointmentName,
    required this.initialNotes,
  });

  @override
  ConsumerState<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends ConsumerState<AppointmentDetailScreen> {
  late final TextEditingController _notesController;
  final FocusNode _notesFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _notesFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_notesFocus.hasFocus) {
      ref.read(appointmentRepositoryProvider).updateNotes(
            widget.appointmentId,
            _notesController.text,
          );
    }
  }

  @override
  void dispose() {
    _notesFocus.removeListener(_onFocusChange);
    _notesController.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Termin löschen?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Löschen')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(appointmentRepositoryProvider).deleteAppointment(widget.appointmentId);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointmentName),
        actions: [
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: _confirmDelete),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(appointmentRepositoryProvider).markCompletedNow(widget.appointmentId),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Termin wahrgenommen'),
            ),
            SizedBox(height: AppSpacing.lg),
            Text('Was muss ich fragen/sagen?', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _notesController,
              focusNode: _notesFocus,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Notizen für den nächsten Termin ...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}