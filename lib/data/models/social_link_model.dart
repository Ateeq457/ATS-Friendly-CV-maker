class SocialLinkModel {
  final String id;
  String platform; // linkedin, github, twitter, portfolio, etc.
  String url;

  SocialLinkModel({
    required this.id,
    required this.platform,
    required this.url,
  });

  factory SocialLinkModel.empty() {
    return SocialLinkModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      platform: '',
      url: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'platform': platform, 'url': url};
  }

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
