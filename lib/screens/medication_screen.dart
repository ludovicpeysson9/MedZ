import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/medication.dart';
import '../services/medication_service.dart';
import '../widgets/medication_form.dart';
import '../widgets/medication_card.dart';
import '../widgets/medz_app_bar.dart';
import '../l10n/app_localizations.dart';
import '../utils/context_extension.dart';
import '../services/notification_service.dart';
import '../utils/checks_persistence.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  List<Medication> medications = [];

  static const _donationUrl = 'https://buymeacoffee.com/ludovicpeysson';

  Map<int, Map<String, bool>> checkStates = {};

  @override
  void initState() {
    super.initState();
    _loadMedications();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.scheduleNotifications(
        title: context.loc.t(L10nKey.reminder),
        body: context.loc.t(L10nKey.reminderBody),
      );
    });
  }

  Future<void> _loadMedications() async {
    final loaded = await MedicationService.loadMedications();
    final persisted = await ChecksPersistence.loadChecks();
    setState(() {
      medications = loaded;
      checkStates.clear();
      for (var i = 0; i < medications.length; i++) {
        checkStates[i] =
            persisted[i] ?? {'morning': false, 'noon': false, 'evening': false};
      }
    });
  }

  void _onCheckChanged(int idx, String slot, bool val) {
    setState(() => checkStates[idx]![slot] = val);
    ChecksPersistence.saveChecks(checkStates);
  }

  Future<void> _launchDonation() async {
    if (!await launchUrlString(
      _donationUrl,
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.t(L10nKey.impossibleToOpenCoffeeLink)),
        ),
      );
    }
  }

  Widget _buildTable() {
    if (medications.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: Center(
          child: Text(
            context.loc.t(L10nKey.noMedication),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: medications.length,
      itemBuilder: (context, i) {
        return MedicationCard(
          medication: medications[i],
          index: i,
          checkStates: checkStates[i]!,
          onCheckChanged: (slot, val) => _onCheckChanged(i, slot, val),
          onUpdated: _loadMedications,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MedzAppBar(context: context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
            child: TextButton.icon(
              onPressed: _launchDonation,
              icon: const Icon(
                Icons.local_cafe,
                size: 20,
                color: Color.fromARGB(249, 233, 130, 0),
              ),
              label: Text(
                context.loc.t(L10nKey.offerCoffee),
                style: TextStyle(
                  color: Color.fromRGBO(249, 193, 130, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),

          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTable(),
                            const SizedBox(height: 32),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: MedicationForm(onSave: _loadMedications),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
