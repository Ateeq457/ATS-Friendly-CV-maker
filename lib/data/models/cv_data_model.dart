import 'personal_info_model.dart';
import 'experience_model.dart';
import 'education_model.dart';
import 'language_model.dart';
import 'certification_model.dart';
import 'project_model.dart';
import 'social_link_model.dart';
import 'custom_section_model.dart';

class CVDataModel {
  final String id;
  PersonalInfoModel personalInfo;
  List<ExperienceModel> experiences;
  List<EducationModel> educations;
  List<String> skills;
  List<LanguageModel> languages;
  List<CertificationModel> certifications;
  List<ProjectModel> projects;
  List<SocialLinkModel> socialLinks;
  List<CustomSectionModel> customSections;
  DateTime lastUpdated;
  String selectedTemplateId;

  CVDataModel({
    required this.id,
    required this.personalInfo,
    required this.experiences,
    required this.educations,
    required this.skills,
    required this.languages,
    required this.certifications,
    required this.projects,
    required this.socialLinks,
    required this.customSections,
    required this.lastUpdated,
    required this.selectedTemplateId,
  });

  factory CVDataModel.empty() {
    return CVDataModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      personalInfo: PersonalInfoModel.empty(),
      experiences: [],
      educations: [],
      skills: [],
      languages: [],
      certifications: [],
      projects: [],
      socialLinks: [],
      customSections: [],
      lastUpdated: DateTime.now(),
      selectedTemplateId: 'usa_classic',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personalInfo': personalInfo.toJson(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'skills': skills,
      'languages': languages.map((l) => l.toJson()).toList(),
      'certifications': certifications.map((c) => c.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'socialLinks': socialLinks.map((s) => s.toJson()).toList(),
      'customSections': customSections.map((c) => c.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'selectedTemplateId': selectedTemplateId,
    };
  }

  factory CVDataModel.fromJson(Map<String, dynamic> json) {
    return CVDataModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      personalInfo: PersonalInfoModel.fromJson(json['personalInfo'] ?? {}),
      experiences:
          (json['experiences'] as List?)
              ?.map((e) => ExperienceModel.fromJson(e))
              .toList() ??
          [],
      educations:
          (json['educations'] as List?)
              ?.map((e) => EducationModel.fromJson(e))
              .toList() ??
          [],
      skills: List<String>.from(json['skills'] ?? []),
      languages:
          (json['languages'] as List?)
              ?.map((l) => LanguageModel.fromJson(l))
              .toList() ??
          [],
      certifications:
          (json['certifications'] as List?)
              ?.map((c) => CertificationModel.fromJson(c))
              .toList() ??
          [],
      projects:
          (json['projects'] as List?)
              ?.map((p) => ProjectModel.fromJson(p))
              .toList() ??
          [],
      socialLinks:
          (json['socialLinks'] as List?)
              ?.map((s) => SocialLinkModel.fromJson(s))
              .toList() ??
          [],
      customSections:
          (json['customSections'] as List?)
              ?.map((c) => CustomSectionModel.fromJson(c))
              .toList() ??
          [],
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
      selectedTemplateId: json['selectedTemplateId'] ?? 'usa_classic',
    );
  }
}
