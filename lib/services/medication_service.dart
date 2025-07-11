import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/medication.dart';

class MedicationService {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/medication.json');
  }

  static Future<List<Medication>> loadMedications() async {
    final file = await _getFile();
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([]));
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];

    final List decoded = jsonDecode(content);
    return decoded.map((e) => Medication.fromJson(e)).toList();
  }

  static Future<void> saveMedication(Medication med) async {
    final file = await _getFile();
    final meds = await loadMedications();
    meds.add(med);
    final List<Map<String, dynamic>> jsonList = meds
        .map((e) => e.toJson())
        .toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  static Future<void> clearAll() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> updateMedication(int index, Medication newMed) async {
    final meds = await loadMedications();
    if (index >= 0 && index < meds.length) {
      meds[index] = newMed;
      final file = await _getFile();
      await file.writeAsString(
        jsonEncode(meds.map((e) => e.toJson()).toList()),
      );
    }
  }

  static Future<void> deleteMedication(int index) async {
    final meds = await loadMedications();
    if (index >= 0 && index < meds.length) {
      meds.removeAt(index);
      final file = await _getFile();
      await file.writeAsString(
        jsonEncode(meds.map((e) => e.toJson()).toList()),
      );
    }
  }
}
