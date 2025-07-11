class Medication {
  final String name;
  final String dosage;
  final bool takeMorning;
  final bool takeNoon;
  final bool takeEvening;

  Medication({
    required this.name,
    required this.dosage,
    required this.takeMorning,
    required this.takeNoon,
    required this.takeEvening,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'takeMorning': takeMorning,
      'takeNoon': takeNoon,
      'takeEvening': takeEvening,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      dosage: json['dosage'],
      takeMorning: json['takeMorning'] ?? false,
      takeNoon: json['takeNoon'] ?? false,
      takeEvening: json['takeEvening'] ?? false,
    );
  }
}
