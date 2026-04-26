class LanguageModel {
  final String id;
  String name;
  String proficiencyLevel;

  LanguageModel({
    required this.id,
    required this.name,
    required this.proficiencyLevel,
  });

  factory LanguageModel.empty() {
    return LanguageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      proficiencyLevel: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'proficiencyLevel': proficiencyLevel};
  }

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      proficiencyLevel: json['proficiencyLevel'] ?? '',
    );
  }
}
