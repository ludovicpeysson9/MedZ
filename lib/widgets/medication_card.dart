import 'package:flutter/material.dart';
import 'package:medz/l10n/app_localizations.dart';
import '../models/medication.dart';
import '../screens/edit_medication_screen.dart';
import '../services/confirmation_service.dart';
import '../utils/context_extension.dart';

class MedicationCard extends StatefulWidget {
  final Medication medication;
  final int index;
  final VoidCallback onUpdated;
  final Map<String, bool> checkStates;
  final void Function(String slot, bool value) onCheckChanged;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.index,
    required this.onUpdated,
    required this.checkStates,
    required this.onCheckChanged,
  });

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  @override
  Widget build(BuildContext context) {
    final med = widget.medication;

    final morning = widget.checkStates['morning'] ?? false;
    final noon = widget.checkStates['noon'] ?? false;
    final evening = widget.checkStates['evening'] ?? false;

    final isComplete =
        (!med.takeMorning || morning) &&
        (!med.takeNoon || noon) &&
        (!med.takeEvening || evening);

    return Card(
      color: isComplete
          ? const Color.fromRGBO(49, 233, 129, 0.4)
          : const Color.fromRGBO(255, 255, 255, 0.4),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${med.name} — ${med.dosage}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditMedicationScreen(
                          medication: med,
                          index: widget.index,
                        ),
                      ),
                    ).then((_) => widget.onUpdated());
                  },
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                if (med.takeMorning)
                  Row(
                    children: [
                      Checkbox(
                        value: morning,
                        onChanged: (val) async {
                          final confirmed =
                              await ConfirmationService.showConfirmationDialog(
                                context,
                              );
                          if (!confirmed) return;
                          widget.onCheckChanged('morning', val ?? false);
                        },
                      ),
                      Text(context.loc.t(L10nKey.morning)),
                    ],
                  ),
                if (med.takeNoon)
                  Row(
                    children: [
                      Checkbox(
                        value: noon,
                        onChanged: (val) async {
                          final confirmed =
                              await ConfirmationService.showConfirmationDialog(
                                context,
                              );
                          if (!confirmed) return;
                          widget.onCheckChanged('noon', val ?? false);
                        },
                      ),
                      Text(context.loc.t(L10nKey.noon)),
                    ],
                  ),
                if (med.takeEvening)
                  Row(
                    children: [
                      Checkbox(
                        value: evening,
                        onChanged: (val) async {
                          final confirmed =
                              await ConfirmationService.showConfirmationDialog(
                                context,
                              );
                          if (!confirmed) return;
                          widget.onCheckChanged('evening', val ?? false);
                        },
                      ),
                      Text(context.loc.t(L10nKey.evening)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
