import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../services/medication_service.dart';
import '../services/confirmation_service.dart';
import '../widgets/medz_app_bar.dart';
import '../l10n/app_localizations.dart';
import '../utils/context_extension.dart'; 

class EditMedicationScreen extends StatefulWidget {
  final Medication medication;
  final int index;

  const EditMedicationScreen({
    super.key,
    required this.medication,
    required this.index,
  });

  @override
  State<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  bool takeMorning = false;
  bool takeNoon = false;
  bool takeEvening = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medication.name);
    _dosageController = TextEditingController(text: widget.medication.dosage);
    takeMorning = widget.medication.takeMorning;
    takeNoon = widget.medication.takeNoon;
    takeEvening = widget.medication.takeEvening;
  }

  Future<void> _saveChanges() async {
    final confirmed = await ConfirmationService.showConfirmationDialog(context);
    if (!confirmed) return;

    final updated = Medication(
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      takeMorning: takeMorning,
      takeNoon: takeNoon,
      takeEvening: takeEvening,
    );

    await MedicationService.updateMedication(widget.index, updated);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.loc.t(L10nKey.medicationModified))));
      Navigator.pop(context);
    }
  }

  Future<void> _deleteMedication() async {
    final confirmed = await ConfirmationService.showConfirmationDialog(context);
    if (!confirmed) return;

    await MedicationService.deleteMedication(widget.index);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.loc.t(L10nKey.medicationDeleted))));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MedzAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.loc.t(L10nKey.modifyTheMedication),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: _saveChanges,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteMedication,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: context.loc.t(L10nKey.nameOfMedication)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(labelText: context.loc.t(L10nKey.dosageOfMedication)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: takeMorning,
                  onChanged: (val) => setState(() => takeMorning = val!),
                ),
                Text(context.loc.t(L10nKey.morning)),
                Checkbox(
                  value: takeNoon,
                  onChanged: (val) => setState(() => takeNoon = val!),
                ),
                Text(context.loc.t(L10nKey.noon)),
                Checkbox(
                  value: takeEvening,
                  onChanged: (val) => setState(() => takeEvening = val!),
                ),
                Text(context.loc.t(L10nKey.evening)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
