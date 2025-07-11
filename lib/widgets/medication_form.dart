import 'package:flutter/material.dart';
import 'package:medz/l10n/app_localizations.dart';
import '../services/medication_service.dart';
import '../models/medication.dart';
import '../services/confirmation_service.dart';
import '../utils/context_extension.dart'; 

class MedicationForm extends StatefulWidget {
  final VoidCallback onSave;

  const MedicationForm({super.key, required this.onSave});

  @override
  State<MedicationForm> createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();

  bool takeMorning = false;
  bool takeNoon = false;
  bool takeEvening = false;

  Future<void> saveMedication() async {
    final name = _nameController.text.trim();
    final dosage = _dosageController.text.trim();

    if (name.isEmpty ||
        dosage.isEmpty ||
        (!takeMorning && !takeNoon && !takeEvening)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.loc.t(L10nKey.pleaseFill),
          ),
        ),
      );
      return;
    }

    final existing = await MedicationService.loadMedications();
    final lowerName = name.toLowerCase();

    final duplicate = existing.any((m) => m.name.toLowerCase() == lowerName);

    if (duplicate) {
      final proceed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(context.loc.t(L10nKey.duplicataDetected)),
              content: Text(
                  context.loc.t(L10nKey.alreadyExistingMedication)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(context.loc.t(L10nKey.no)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(context.loc.t(L10nKey.yes)),
                ),
              ],
            ),
          ) ??
          false;
      if (!proceed) {
        return;
      }
    }

    final confirmed =
        await ConfirmationService.showConfirmationDialog(context);
    if (!confirmed) return;

    final newEntry = Medication(
      name: name,
      dosage: dosage,
      takeMorning: takeMorning,
      takeNoon: takeNoon,
      takeEvening: takeEvening,
    );
    await MedicationService.saveMedication(newEntry);

    _nameController.clear();
    _dosageController.clear();
    setState(() {
      takeMorning = false;
      takeNoon = false;
      takeEvening = false;
    });

    widget.onSave();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.loc.t(L10nKey.medicationAdded))));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(255, 255, 255, 0.5),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.t(L10nKey.addMedicationFormTitle),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.loc.t(L10nKey.nameOfMedication),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: context.loc.t(L10nKey.dosageOfMedication),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: takeMorning,
                      onChanged: (val) {
                        setState(() => takeMorning = val ?? false);
                      },
                    ),
                    Text(context.loc.t(L10nKey.morning)),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: takeNoon,
                      onChanged: (val) {
                        setState(() => takeNoon = val ?? false);
                      },
                    ),
                    Text(context.loc.t(L10nKey.noon)),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: takeEvening,
                      onChanged: (val) {
                        setState(() => takeEvening = val ?? false);
                      },
                    ),
                    Text(context.loc.t(L10nKey.evening)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: saveMedication,
                icon: const Icon(Icons.save, color: Colors.teal),
                label: Text(
                  context.loc.t(L10nKey.save),
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
