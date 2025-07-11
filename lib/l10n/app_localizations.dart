import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

// 1) Vos clés de texte
enum L10nKey {
  no,
  yes,
  offerCoffee,
  impossibleToOpenCoffeeLink,
  noMedication,
  addMedicationFormTitle,
  nameOfMedication,
  dosageOfMedication,
  medicationAdded,
  modifyTheMedication,
  medicationModified,
  medicationDeleted,
  settingsOfNotifications,
  morning,
  noon,
  evening,
  save,
  confirmed,
  ok,
  noNotifications,
  pleaseFill,
  duplicataDetected,
  alreadyExistingMedication,
  reminder,
  reminderBody,
  exactAlarmsNotPermitted,
  // … ajoutez ici toutes vos clés
}

// 2) Le dictionnaire des traductions
const Map<String, Map<L10nKey, String>> _kTranslations = {
  'fr': {
    L10nKey.no:'Non',
    L10nKey.yes:'Oui',
    L10nKey.offerCoffee: 'Offrez-moi un café',
    L10nKey.impossibleToOpenCoffeeLink: 'Impossible d\'ouvrir le lien de donation',
    L10nKey.noMedication: 'Pas encore de traitement renseigné',
    L10nKey.addMedicationFormTitle: 'Ajoutez un traitement',
    L10nKey.nameOfMedication : 'Nom du traitement',
    L10nKey.dosageOfMedication : 'Posologie',
    L10nKey.medicationAdded: 'Traitement ajouté!',
    L10nKey.modifyTheMedication : 'Modifier le traitement',
    L10nKey.medicationModified : 'Traitement modifié',
    L10nKey.medicationDeleted : 'Traitement supprimé',
    L10nKey.settingsOfNotifications : 'Paramètres des notifications',
    L10nKey.morning: 'Matin',
    L10nKey.noon: 'Midi',
    L10nKey.evening: 'Soir',
    L10nKey.save: 'Sauvegarder',
    L10nKey.confirmed: 'Confirmé',
    L10nKey.ok: 'Ok',
    L10nKey.noNotifications: 'Aucune notification activée',
    L10nKey.pleaseFill: 'Veuillez remplir tous les champs et cocher au moins une prise.',
    L10nKey.duplicataDetected: 'Duplicata détecté',
    L10nKey.alreadyExistingMedication: 'Ce traitement existe déjà. Voulez-vous vraiment l’ajouter ?',
    L10nKey.reminder: 'Rappel de prise',    
    L10nKey.reminderBody: 'Avez vous pris votre traitement?',
    L10nKey.exactAlarmsNotPermitted: 'Impossible d\'utiliser des alarmes précises sur cet appareil',
    // …
  },
  'en': {
    L10nKey.no:'No',
    L10nKey.yes:'Yes',
    L10nKey.offerCoffee: 'Buy me a coffee',
    L10nKey.impossibleToOpenCoffeeLink: 'Impossible to open the donation link',
    L10nKey.noMedication: 'No medication entered yet',
    L10nKey.addMedicationFormTitle: 'Add a medication',
    L10nKey.nameOfMedication : 'Name of the medication',
    L10nKey.dosageOfMedication : 'Dosage',
    L10nKey.medicationAdded: 'Medication added!',
    L10nKey.modifyTheMedication : 'Modify this medication',
    L10nKey.medicationModified : 'Medication modified',
    L10nKey.medicationDeleted : 'Medication deleted',
    L10nKey.settingsOfNotifications : 'Notification settings',
    L10nKey.morning: 'Morning',
    L10nKey.noon: 'Noon',
    L10nKey.evening: 'Evening',
    L10nKey.save: 'Save',
    L10nKey.confirmed: 'Confirmed',
    L10nKey.ok: 'Ok',
    L10nKey.noNotifications: 'No notifications enabled',
    L10nKey.pleaseFill: 'Please fill in all fields and check at least one take',
    L10nKey.duplicataDetected: 'Duplicata détecté',
    L10nKey.alreadyExistingMedication: 'This medication already exists. Would you like to add it again?',
    L10nKey.reminder: 'Reminder',    
    L10nKey.reminderBody: 'Did you take your meds?',
    L10nKey.exactAlarmsNotPermitted: 'Unable to use accurate alarms on this device',

    // …
  },
};

/// 3) Classe d’accès aux traductions
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String t(L10nKey key) {
    final lang = locale.languageCode;
    final map = _kTranslations[lang] ?? _kTranslations['fr']!;
    return map[key] ?? '‹${describeEnum(key)}›';
  }

  /// Le Delegate que l’on passera à MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) =>
      ['fr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
