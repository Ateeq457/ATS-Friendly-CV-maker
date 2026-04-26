class PersonalInfoModel {
  String fullName;
  String email;
  String phone;
  String address;
  String summary;
  String? profileImagePath;

  PersonalInfoModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.summary,
    this.profileImagePath,
  });

  factory PersonalInfoModel.empty() {
    return PersonalInfoModel(
      fullName: '',
      email: '',
      phone: '',
      address: '',
      summary: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'summary': summary,
      'profileImagePath': profileImagePath,
    };
  }

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      summary: json['summary'] ?? '',
      profileImagePath: json['profileImagePath'],
    );
  }
}
