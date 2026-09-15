import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Zentrale Stelle für lokale Benachrichtigungen. Bewusst als
/// statische Klasse (kein Riverpod-Provider nötig), weil sie von
/// Repositories aus mehreren, unabhängigen Modulen (Haushalt,
/// Kontakte, Gesundheit) aus demselben Muster heraus aufgerufen wird.
///
/// WICHTIG: Verdrahtet ist das bisher NUR für die drei
/// Intervall-Module (Haushalt, Kontakte, Gesundheit-Termine) – nicht
/// für Medikamente oder Vorrats-Ablaufdaten (andere Datenform, noch
/// nicht angebunden).
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    // Android 13+ verlangt eine explizite Laufzeit-Berechtigung.
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  /// Stabile, positive Notification-ID aus einem beliebigen String
  /// (z.B. der Task-ID), damit dieselbe Aufgabe immer dieselbe
  /// Benachrichtigung überschreibt statt neue anzuhäufen.
  static int _stableId(String key) => key.hashCode & 0x7fffffff;

  /// Plant (oder ersetzt) eine Fälligkeits-Erinnerung. Liegt
  /// [dueDate] in der Vergangenheit, wird nur storniert, nicht neu
  /// geplant – wir wollen keine "Sofort-Flut" beim Öffnen der App.
  static Future<void> scheduleDueReminder({
    required String id,
    required String title,
    required String body,
    required DateTime dueDate,
  }) async {
    final notificationId = _stableId(id);
    await _plugin.cancel(notificationId);

    if (dueDate.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(dueDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'due_reminders',
          'Fälligkeiten',
          channelDescription: 'Erinnerungen für fällige Aufgaben, Kontakte und Termine',
          importance: Importance.defaultImportance,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancel(String id) => _plugin.cancel(_stableId(id));
}