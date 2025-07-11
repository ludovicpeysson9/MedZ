import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SettingsService {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/settings.json');
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return {
          'morning': {'hour': 7, 'minute': 0},
          'noon': {'hour': 11, 'minute': 30},
          'evening': {'hour': 19, 'minute': 0},
        };
      }
      final content = await file.readAsString();
      return json.decode(content);
    } catch (_) {
      return {
        'morning': {'hour': 7, 'minute': 0},
        'noon': {'hour': 11, 'minute': 30},
        'evening': {'hour': 19, 'minute': 0},
      };
    }
  }

  static Future<void> saveSettings(Map<String, dynamic> data) async {
    final file = await _getFile();
    await file.writeAsString(json.encode(data));
  }
}
