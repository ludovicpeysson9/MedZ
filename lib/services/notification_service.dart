import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'exact_alarm_permission.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    final String localName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localName));
    print('[MedZ] Time-zone set to $localName');
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings);

    if (Platform.isAndroid) {

      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      final notiGranted =
          await android?.requestNotificationsPermission() ?? true;         
      if (!notiGranted) {
        return;
      }

      print("permission?");
      print(notiGranted);

      if (!await ExactAlarmPermission.canScheduleExactAlarms()) {
        await ExactAlarmPermission.requestPermission();
      }

      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          'medz_channel',
          'MedZ',
          description: 'Notifications - MedZ',
          importance: Importance.max,
        ),
      );
      await scheduleNotifications(
        title: "Reminder - MedZ", 
        body: "Did you take your meds ?"
      );
    }
  }

  static Future<void> scheduleNotifications({
    required String title,
    required String body,
  }) async {
    final hasExact = !Platform.isAndroid ||
        await ExactAlarmPermission.canScheduleExactAlarms();

    final settings = await loadNotificationSettings();
    await _plugin.cancelAll();

    for (var i = 0; i < settings.length; i++) {
      final entry = settings[i];
      if (entry['enabled'] != true) continue;

      final h = entry['hour'] as int;
      final m = entry['minute'] as int;
      final scheduled = _nextInstanceOf(h, m);

      print("nextInstance : ");
      print('[MedZ] Schedule id=$i => $scheduled  exact=$hasExact');

      await _plugin.zonedSchedule(
        i,
        title,
        body,
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medz_channel',
            'Rappels MedZ',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: hasExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,        
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<List<Map<String, dynamic>>> loadNotificationSettings() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/settings.json');
    if (!await file.exists()) {
      final defaults = [
        {'hour': 7, 'minute': 0, 'enabled': true},
        {'hour': 11, 'minute': 30, 'enabled': true},
        {'hour': 19, 'minute': 0, 'enabled': true},
      ];
      await file.writeAsString(jsonEncode(defaults));
      return defaults;
    }
    final raw = jsonDecode(await file.readAsString()) as List;
    return raw.map((item) {
      return {
        'hour': item['hour'] is int
            ? item['hour']
            : int.parse(item['hour'].toString()),
        'minute': item['minute'] is int
            ? item['minute']
            : int.parse(item['minute'].toString()),
        'enabled': item['enabled'] is bool ? item['enabled'] : true,
      };
    }).toList();
  }

  static Future<void> updateNotificationTimes(
    List<Map<String, dynamic>> settings,
  ) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/settings.json');
    await file.writeAsString(jsonEncode(settings));
  }
}
