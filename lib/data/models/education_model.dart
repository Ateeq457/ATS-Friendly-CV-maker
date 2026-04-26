class EducationModel {
  final String id;
  String degree;
  String institution;
  DateTime startDate;
  DateTime? endDate;
  bool isCurrent;
  String? grade;

  EducationModel({
    required this.id,
    required this.degree,
    required this.institution,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.grade,
  });

  factory EducationModel.empty() {
    return EducationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      degree: '',
      institution: '',
      startDate: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'institution': institution,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrent': isCurrent,
      'grade': grade,
    };
  }

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      grade: json['grade'],
    );
  }
}
