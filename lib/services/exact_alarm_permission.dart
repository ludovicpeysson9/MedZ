import 'dart:io';
import 'package:flutter/services.dart';

class ExactAlarmPermission {
  static const _channel = MethodChannel('medz/exact_alarm');

  static Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    return await _channel.invokeMethod<bool>('canScheduleExactAlarms') ?? false;
  }

  static Future<void> requestPermission() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod('requestExactAlarmPermission');
  }
}
