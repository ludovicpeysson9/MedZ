import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LastResetDate {
  static const _fileName = 'last_reset.json';

  static Future<DateTime?> load() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!await file.exists()) return null;
    try {
      final d = jsonDecode(await file.readAsString()) as String;
      return DateTime.parse(d);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveToday() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    final today = DateTime.now();
    final isoDate = DateTime(today.year, today.month, today.day).toIso8601String();
    await file.writeAsString(jsonEncode(isoDate));
  }
}
