import 'dart:typed_data';

import 'package:flutter/material.dart';

// ============ CV MODEL (Main Class) ============
class CVModel {
  final String id;
  final String title;
  final String status; // 'draft' or 'completed'
  final double progress; // 0.0 to 1.0
  final DateTime lastEdited;
  final Map<String, dynamic> data; // Actual CV data

  CVModel({
    required this.id,
    required this.title,
    this.status = 'draft',
    this.progress = 0.0,
    required this.lastEdited,
    this.data = const {},
  });

  // Sample data for UI demonstration
  static List<CVModel> getSampleCVs() {
    return [
      CVModel(
        id: '1',
        title: 'Senior Flutter Developer',
        status: 'draft',
        progress: 0.65,
        lastEdited: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CVModel(
        id: '2',
        title: 'Product Manager CV',
        status: 'completed',
        progress: 1.0,
        lastEdited: DateTime.now().subtract(const Duration(days: 3)),
      ),
      CVModel(
        id: '3',
        title: 'UI/UX Designer',
        status: 'draft',
        progress: 0.3,
        lastEdited: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  static void deleteCV(String id) {
    debugPrint('Deleting CV: $id');
  }

  static void duplicateCV(CVModel cv) {
    debugPrint('Duplicating CV: ${cv.title}');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'progress': progress,
      'lastEdited': lastEdited.toIso8601String(),
      'data': data,
    };
  }

  factory CVModel.fromJson(Map<String, dynamic> json) {
    return CVModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'Untitled CV',
      status: json['status'] ?? 'draft',
      progress: (json['progress'] ?? 0.0).toDouble(),
      lastEdited: json['lastEdited'] != null
          ? DateTime.parse(json['lastEdited'])
          : DateTime.now(),
      data: json['data'] ?? {},
    );
  }
}

// ============ CV DATA CLASS (for form provider) ============
class CVData {
  String fullName;
  String title;
  String email;
  String phone;
  String location;
  String linkedin;
  String github;
  String summary;
  Uint8List? photoBytes;
  List<Experience> experiences;
  List<Education> educations;
  List<String> skills;
  List<Project> projects;
  List<Certification> certifications;
  List<Language> languages;
  List<SocialLinkModel> socialLinks;
  List<CustomSectionModel> customSections;

  CVData({
    required this.fullName,
    required this.title,
    required this.email,
    required this.phone,
    required this.location,
    required this.linkedin,
    required this.github,
    required this.summary,
    this.photoBytes,
    required this.experiences,
    required this.educations,
    required this.skills,
    required this.projects,
    required this.certifications,
    required this.languages,
    this.socialLinks = const [],
    this.customSections = const [],
  });

  factory CVData.empty() {
    return CVData(
      fullName: '',
      title: '',
      email: '',
      phone: '',
      location: '',
      linkedin: '',
      github: '',
      summary: '',
      experiences: [],
      educations: [],
      skills: [],
      projects: [],
      certifications: [],
      languages: [],
    );
  }

  factory CVData.sample() {
    return CVData(
      fullName: 'John Doe',
      title: 'Flutter Developer',
      email: 'john@example.com',
      phone: '+92 300 1234567',
      location: 'Karachi, Pakistan',
      linkedin: 'linkedin.com/in/johndoe',
      github: 'github.com/johndoe',
      summary: 'Experienced Flutter developer with 5+ years of experience.',
      experiences: [
        Experience(
          jobTitle: 'Senior Flutter Developer',
          company: 'Tech Solutions',
          startDate: DateTime(2022, 1),
          endDate: null,
          isCurrent: true,
          description: 'Leading mobile app development team.',
        ),
      ],
      educations: [
        Education(
          degree: 'BS Computer Science',
          institution: 'University',
          startDate: DateTime(2015, 9),
          endDate: DateTime(2019, 6),
          gpa: '3.8',
        ),
      ],
      skills: ['Flutter', 'Dart', 'Firebase'],
      projects: [],
      certifications: [],
      languages: [],
    );
  }

  // ✅ ADDED: toJson method
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'title': title,
      'email': email,
      'phone': phone,
      'location': location,
      'linkedin': linkedin,
      'github': github,
      'summary': summary,
      'experiences': experiences
          .map(
            (e) => {
              'jobTitle': e.jobTitle,
              'company': e.company,
              'startDate': e.startDate.toIso8601String(),
              'endDate': e.endDate?.toIso8601String(),
              'isCurrent': e.isCurrent,
              'description': e.description,
            },
          )
          .toList(),
      'educations': educations
          .map(
            (e) => {
              'degree': e.degree,
              'institution': e.institution,
              'startDate': e.startDate.toIso8601String(),
              'endDate': e.endDate?.toIso8601String(),
              'gpa': e.gpa,
            },
          )
          .toList(),
      'skills': skills,
      'projects': projects
          .map(
            (p) => {
              'name': p.name,
              'description': p.description,
              'technologies': p.technologies,
              'projectUrl': p.projectUrl,
            },
          )
          .toList(),
      'certifications': certifications
          .map(
            (c) => {
              'name': c.name,
              'issuer': c.issuer,
              'issueDate': c.issueDate?.toIso8601String(),
              'expiryDate': c.expiryDate?.toIso8601String(),
              'credentialId': c.credentialId,
              'credentialUrl': c.credentialUrl,
            },
          )
          .toList(),
      'languages': languages
          .map((l) => {'name': l.name, 'proficiencyLevel': l.proficiencyLevel})
          .toList(),
      'socialLinks': socialLinks
          .map((s) => {'id': s.id, 'platform': s.platform, 'url': s.url})
          .toList(),
      'customSections': customSections
          .map(
            (c) => {
              'id': c.id,
              'title': c.title,
              'entries': c.entries
                  .map(
                    (e) => {
                      'id': e.id,
                      'title': e.title,
                      'description': e.description,
                      'date': e.date,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
    };
  }

  // ✅ ADDED: fromJson factory
  factory CVData.fromJson(Map<String, dynamic> json) {
    return CVData(
      fullName: json['fullName'] ?? '',
      title: json['title'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      summary: json['summary'] ?? '',
      experiences:
          (json['experiences'] as List?)
              ?.map(
                (e) => Experience(
                  jobTitle: e['jobTitle'] ?? '',
                  company: e['company'] ?? '',
                  startDate:
                      DateTime.tryParse(e['startDate'] ?? '') ?? DateTime.now(),
                  endDate: e['endDate'] != null
                      ? DateTime.tryParse(e['endDate'])
                      : null,
                  isCurrent: e['isCurrent'] ?? false,
                  description: e['description'] ?? '',
                ),
              )
              .toList() ??
          [],
      educations:
          (json['educations'] as List?)
              ?.map(
                (e) => Education(
                  degree: e['degree'] ?? '',
                  institution: e['institution'] ?? '',
                  startDate:
                      DateTime.tryParse(e['startDate'] ?? '') ?? DateTime.now(),
                  endDate: e['endDate'] != null
                      ? DateTime.tryParse(e['endDate'])
                      : null,
                  gpa: e['gpa'],
                ),
              )
              .toList() ??
          [],
      skills: List<String>.from(json['skills'] ?? []),
      projects:
          (json['projects'] as List?)
              ?.map(
                (p) => Project(
                  name: p['name'] ?? '',
                  description: p['description'] ?? '',
                  technologies: p['technologies'],
                  projectUrl: p['projectUrl'],
                ),
              )
              .toList() ??
          [],
      certifications:
          (json['certifications'] as List?)
              ?.map(
                (c) => Certification(
                  name: c['name'] ?? '',
                  issuer: c['issuer'] ?? '',
                  issueDate: c['issueDate'] != null
                      ? DateTime.tryParse(c['issueDate'])
                      : null,
                  expiryDate: c['expiryDate'] != null
                      ? DateTime.tryParse(c['expiryDate'])
                      : null,
                  credentialId: c['credentialId'],
                  credentialUrl: c['credentialUrl'],
                ),
              )
              .toList() ??
          [],
      languages:
          (json['languages'] as List?)
              ?.map(
                (l) => Language(
                  name: l['name'] ?? '',
                  proficiencyLevel: l['proficiencyLevel'] ?? '',
                ),
              )
              .toList() ??
          [],
      socialLinks:
          (json['socialLinks'] as List?)
              ?.map(
                (s) => SocialLinkModel(
                  id:
                      s['id'] ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  platform: s['platform'] ?? '',
                  url: s['url'] ?? '',
                ),
              )
              .toList() ??
          [],
      customSections:
          (json['customSections'] as List?)
              ?.map(
                (c) => CustomSectionModel(
                  id:
                      c['id'] ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: c['title'] ?? '',
                  entries:
                      (c['entries'] as List?)
                          ?.map(
                            (e) => CustomSectionEntry(
                              id:
                                  e['id'] ??
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              title: e['title'] ?? '',
                              description: e['description'] ?? '',
                              date: e['date'],
                            ),
                          )
                          .toList() ??
                      [],
                ),
              )
              .toList() ??
          [],
    );
  }
}

// ============ EXPERIENCE CLASS ============
class Experience {
  String jobTitle;
  String company;
  DateTime startDate;
  DateTime? endDate;
  bool isCurrent;
  String description;

  Experience({
    required this.jobTitle,
    required this.company,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    required this.description,
  });

  factory Experience.empty() {
    return Experience(
      jobTitle: '',
      company: '',
      startDate: DateTime.now(),
      description: '',
    );
  }
}

// ============ EDUCATION CLASS ============
class Education {
  String degree;
  String institution;
  DateTime startDate;
  DateTime? endDate;
  String? gpa;

  Education({
    required this.degree,
    required this.institution,
    required this.startDate,
    this.endDate,
    this.gpa,
  });

  factory Education.empty() {
    return Education(degree: '', institution: '', startDate: DateTime.now());
  }
}

// ============ PROJECT CLASS ============
class Project {
  String name;
  String description;
  String? technologies;
  String? projectUrl;

  Project({
    required this.name,
    required this.description,
    this.technologies,
    this.projectUrl,
  });

  factory Project.empty() {
    return Project(name: '', description: '');
  }
}

// ============ CERTIFICATION CLASS ============
class Certification {
  String name;
  String issuer;
  DateTime? issueDate;
  DateTime? expiryDate;
  String? credentialId;
  String? credentialUrl;

  Certification({
    required this.name,
    required this.issuer,
    this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.credentialUrl,
  });

  factory Certification.empty() {
    return Certification(name: '', issuer: '');
  }
}

// ============ LANGUAGE CLASS ============
class Language {
  String name;
  String proficiencyLevel;

  Language({required this.name, required this.proficiencyLevel});

  factory Language.empty() {
    return Language(name: '', proficiencyLevel: '');
  }
}

// ============ SOCIAL LINK MODEL ============
class SocialLinkModel {
  final String id;
  String platform;
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
}

// ============ CUSTOM SECTION MODEL ============
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
}
