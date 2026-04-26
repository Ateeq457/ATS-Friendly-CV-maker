class CertificationModel {
  final String id;
  String name;
  String organization;
  DateTime? issueDate;
  DateTime? expiryDate;
  String? credentialId;
  String? credentialUrl;

  CertificationModel({
    required this.id,
    required this.name,
    required this.organization,
    this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.credentialUrl,
  });

  factory CertificationModel.empty() {
    return CertificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      organization: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organization': organization,
      'issueDate': issueDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'credentialId': credentialId,
      'credentialUrl': credentialUrl,
    };
  }

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      organization: json['organization'] ?? '',
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'])
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      credentialId: json['credentialId'],
      credentialUrl: json['credentialUrl'],
    );
  }
}
