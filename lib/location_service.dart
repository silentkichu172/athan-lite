import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'prayer_service.dart';

/// Handles local (on-device) notifications for the Azan.
/// No server, no push service, no ads SDK involved.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    const channel = AndroidNotificationChannel(
      'prayer_channel',
      'Prayer Times',
      description: 'Azan notifications for daily prayer times',
      importance: Importance.max,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  /// Cancels any previously scheduled prayer notifications and schedules
  /// fresh ones for today's five prayers. Call this once a day (e.g. on
  /// app open, or from a daily background task once you add one).
  static Future<void> scheduleTodaysPrayers(DailyPrayerTimes times) async {
    await _plugin.cancelAll();

    final entries = [
      MapEntry('Fajr', times.fajr),
      MapEntry('Dhuhr', times.dhuhr),
      MapEntry('Asr', times.asr),
      MapEntry('Maghrib', times.maghrib),
      MapEntry('Isha', times.isha),
    ];

    var id = 0;
    for (final entry in entries) {
      if (entry.value.isAfter(DateTime.now())) {
        await _scheduleOne(id, entry.key, entry.value);
      }
      id++;
    }
  }

  static Future<void> _scheduleOne(
    int id,
    String prayerName,
    DateTime time,
  ) async {
    await _plugin.zonedSchedule(
      id,
      'Time for $prayerName',
      'It is time to pray $prayerName.',
      tz.TZDateTime.from(time, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel',
          'Prayer Times',
          channelDescription: 'Azan notifications for daily prayer times',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
