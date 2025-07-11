import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ChecksPersistence {
  static const _fileName = 'checks.json';

  static Future<Map<int, Map<String, bool>>> loadChecks() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!await file.exists()) return {};
    try {
      final content = await file.readAsString();
      final Map<String, dynamic> raw = jsonDecode(content);
      return raw.map((key, value) {
        final inner = Map<String, dynamic>.from(value);
        return MapEntry(
          int.parse(key),
          inner.map((slot, v) => MapEntry(slot, v as bool)),
        );
      });
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveChecks(Map<int, Map<String, bool>> checks) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    final encodable = checks.map((idx, slots) {
      return MapEntry(idx.toString(), slots);
    });
    await file.writeAsString(jsonEncode(encodable));
  }

  static Future<void> clearAll() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
