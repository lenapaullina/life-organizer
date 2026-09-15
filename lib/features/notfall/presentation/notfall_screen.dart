import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../notfall_micro_tasks.dart';

/// Öffnet den Notfall-Modus als eigene Route, ohne Bottom-Navigation
/// und ohne Zugriff auf andere Screens – "alles ausblenden" ist
/// hier wörtlich gemeint, nicht nur visuell reduziert.
void showNotfallScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const NotfallScreen(),
    ),
  );
}

class NotfallScreen extends StatefulWidget {
  const NotfallScreen({super.key});

  @override
  State<NotfallScreen> createState() => _NotfallScreenState();
}

class _NotfallScreenState extends State<NotfallScreen> {
  late String _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = _pickRandomTask();
  }

  String _pickRandomTask() {
    return notfallMicroTasks[Random().nextInt(notfallMicroTasks.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              // Kleiner, unauffälliger Ausgang statt großer "Abbrechen"-Aktion,
              // die wie ein Scheitern wirken könnte.
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ),
              const Spacer(),
              Text(
                'Nur das hier. Mehr nicht.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                _currentTask,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Erledigt'),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => setState(() => _currentTask = _pickRandomTask()),
                child: const Text('Etwas anderes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}