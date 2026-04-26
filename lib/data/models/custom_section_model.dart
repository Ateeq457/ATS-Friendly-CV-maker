class CustomSectionModel {
  final String id;
  String title;
  List<CustomSectionEntry> entries;

  CustomSectionModel({
    required this.id,
    required this.title,
    required this.entries,
  });

  factory CustomSectionModel.empty() {
    return CustomSectionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      entries: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }

  factory CustomSectionModel.fromJson(Map<String, dynamic> json) {
    return CustomSectionModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      entries:
          (json['entries'] as List?)
              ?.map((e) => CustomSectionEntry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CustomSectionEntry {
  final String id;
  String title;
  String description;
  String? date;

  CustomSectionEntry({
    required this.id,
    required this.title,
    required this.description,
    this.date,
  });

  factory CustomSectionEntry.empty() {
    return CustomSectionEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      description: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description, 'date': date};
  }

  factory CustomSectionEntry.fromJson(Map<String, dynamic> json) {
    return CustomSectionEntry(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'],
    );
  }
}
