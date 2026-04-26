class ProjectModel {
  final String id;
  String name;
  String description;
  String? technologies;
  String? projectUrl;
  DateTime? startDate;
  DateTime? endDate;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    this.technologies,
    this.projectUrl,
    this.startDate,
    this.endDate,
  });

  factory ProjectModel.empty() {
    return ProjectModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      description: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'technologies': technologies,
      'projectUrl': projectUrl,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      technologies: json['technologies'],
      projectUrl: json['projectUrl'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
}
