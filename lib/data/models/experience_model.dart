class ExperienceModel {
  final String id;
  String jobTitle;
  String companyName;
  DateTime startDate;
  DateTime? endDate;
  bool isCurrent;
  String description;

  ExperienceModel({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    required this.description,
  });

  factory ExperienceModel.empty() {
    return ExperienceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobTitle: '',
      companyName: '',
      startDate: DateTime.now(),
      description: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrent': isCurrent,
      'description': description,
    };
  }

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      jobTitle: json['jobTitle'] ?? '',
      companyName: json['companyName'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      description: json['description'] ?? '',
    );
  }
}
