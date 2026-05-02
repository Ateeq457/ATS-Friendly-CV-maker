import 'package:flutter/material.dart';

import '../local/cv_storage.dart';
import '../models/cv_data.dart'; // ✅ CVModel (if needed)
// Note: All model classes are now in cv_data.dart, so no separate imports needed!

class CVRepository {
  final CVStorage _storage = CVStorage();

  // ✅ Changed CVDataModel to CVData
  Future<void> saveCV(CVData cvData) async {
    try {
      await _storage.saveCVData(cvData);
      debugPrint('CV saved successfully');
    } catch (e) {
      debugPrint('Error saving CV: $e');
      rethrow;
    }
  }

  // ✅ Changed CVDataModel to CVData
  Future<CVData?> loadCV() async {
    try {
      return await _storage.loadCVData(null);
    } catch (e) {
      debugPrint('Error loading CV: $e');
      return null;
    }
  }

  Future<void> clearCV() async {
    try {
      await _storage.clearCVData();
      debugPrint('CV data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing CV: $e');
      rethrow;
    }
  }

  // ✅ Updated to use CVData
  Future<bool> _needsMigration(CVData cv) async {
    if (cv.certifications.isEmpty && cv.skills.isNotEmpty) {
      return true;
    }
    if (cv.projects.isEmpty && cv.skills.isNotEmpty) {
      return true;
    }
    if (cv.socialLinks.isEmpty && cv.skills.isNotEmpty) {
      return true;
    }
    if (cv.customSections.isEmpty && cv.skills.isNotEmpty) {
      return true;
    }
    return false;
  }

  // ✅ Updated to use CVData
  Future<CVData> _migrateData(CVData oldData) async {
    debugPrint('Migrating old CV data to new structure...');

    final migratedData = CVData(
      fullName: oldData.fullName,
      title: oldData.title,
      email: oldData.email,
      phone: oldData.phone,
      location: oldData.location,
      linkedin: oldData.linkedin,
      github: oldData.github,
      summary: oldData.summary,
      experiences: oldData.experiences,
      educations: oldData.educations,
      skills: oldData.skills,
      languages: oldData.languages.isEmpty
          ? _getDefaultLanguages()
          : oldData.languages,
      certifications: oldData.certifications.isEmpty
          ? _getDefaultCertifications()
          : oldData.certifications,
      projects: oldData.projects.isEmpty
          ? _getDefaultProjects()
          : oldData.projects,
      socialLinks: oldData.socialLinks.isEmpty
          ? _getDefaultSocialLinks()
          : oldData.socialLinks,
      customSections: oldData.customSections.isEmpty
          ? []
          : oldData.customSections,
    );

    await saveCV(migratedData);
    debugPrint('Migration complete');
    return migratedData;
  }

  // ✅ Using Language from cv_data.dart
  List<Language> _getDefaultLanguages() {
    return [
      Language(name: 'English', proficiencyLevel: 'Fluent'),
      Language(name: 'Urdu', proficiencyLevel: 'Native'),
    ];
  }

  // ✅ Using Certification from cv_data.dart
  List<Certification> _getDefaultCertifications() {
    return [
      Certification(
        name: 'Flutter Development Bootcamp',
        issuer: 'Udemy',
        issueDate: DateTime(2023, 6),
      ),
      Certification(
        name: 'Google Associate Android Developer',
        issuer: 'Google',
        issueDate: DateTime(2022, 12),
      ),
    ];
  }

  // ✅ Using Project from cv_data.dart
  List<Project> _getDefaultProjects() {
    return [
      Project(
        name: 'E-Commerce App',
        description:
            'A fully functional e-commerce app with payment integration',
        technologies: 'Flutter, Firebase, Stripe',
        projectUrl: 'https://github.com/johndoe/ecommerce',
      ),
      Project(
        name: 'Portfolio Website',
        description: 'Personal portfolio website showcasing work',
        technologies: 'Flutter Web, HTML, CSS',
        projectUrl: 'https://johndoe.dev',
      ),
    ];
  }

  // ✅ Using SocialLinkModel from cv_data.dart
  List<SocialLinkModel> _getDefaultSocialLinks() {
    return [
      SocialLinkModel(
        id: 'social1',
        platform: 'linkedin',
        url: 'https://linkedin.com/in/johndoe',
      ),
      SocialLinkModel(
        id: 'social2',
        platform: 'github',
        url: 'https://github.com/johndoe',
      ),
      SocialLinkModel(
        id: 'social3',
        platform: 'twitter',
        url: 'https://twitter.com/johndoe',
      ),
    ];
  }

  // ✅ Updated to use CVData
  Future<CVData> getSampleCV() async {
    try {
      final existing = await loadCV();
      if (existing != null) {
        if (await _needsMigration(existing)) {
          return await _migrateData(existing);
        }
        debugPrint('Returning existing CV data');
        return existing;
      }
      debugPrint('Creating fresh sample CV for new user');
      return _createFreshSample();
    } catch (e) {
      debugPrint('Error in getSampleCV: $e');
      return _createFreshSample();
    }
  }

  // ✅ Updated to use CVData
  CVData _createFreshSample() {
    return CVData(
      fullName: 'John Doe',
      title: 'Flutter Developer',
      email: 'john.doe@example.com',
      phone: '+92 300 1234567',
      location: 'Karachi, Pakistan',
      linkedin: '',
      github: '',
      summary:
          'Experienced Flutter developer with 5+ years of experience building high-quality mobile applications.',
      experiences: [
        Experience(
          jobTitle: 'Senior Flutter Developer',
          company: 'Tech Solutions',
          startDate: DateTime(2022, 1),
          isCurrent: true,
          description:
              'Leading mobile app development team, implementing clean architecture and state management solutions.',
        ),
        Experience(
          jobTitle: 'Mobile Developer',
          company: 'Startup Inc',
          startDate: DateTime(2019, 6),
          endDate: DateTime(2021, 12),
          isCurrent: false,
          description:
              'Developed cross-platform applications using Flutter and React Native.',
        ),
      ],
      educations: [
        Education(
          degree: 'BS Computer Science',
          institution: 'University of Karachi',
          startDate: DateTime(2015, 9),
          endDate: DateTime(2019, 6),
          gpa: '3.8 GPA',
        ),
      ],
      skills: [
        'Flutter',
        'Dart',
        'Firebase',
        'REST API',
        'Git',
        'Provider',
        'GetX',
      ],
      languages: _getDefaultLanguages(),
      certifications: _getDefaultCertifications(),
      projects: _getDefaultProjects(),
      socialLinks: _getDefaultSocialLinks(),
      customSections: [],
    );
  }

  // ✅ Updated to use CVData
  CVData getDemoCV() {
    return CVData(
      fullName: 'Jane Smith',
      title: 'Lead Product Designer',
      email: 'jane.smith@example.com',
      phone: '+44 20 7946 0123',
      location: 'London, UK',
      linkedin: '',
      github: '',
      summary: 'Creative designer with 8+ years of experience in UI/UX design.',
      experiences: [
        Experience(
          jobTitle: 'Lead Product Designer',
          company: 'Creative Agency',
          startDate: DateTime(2021, 3),
          isCurrent: true,
          description: 'Leading design team for major client projects.',
        ),
      ],
      educations: [
        Education(
          degree: 'BA in Design',
          institution: 'Central Saint Martins',
          startDate: DateTime(2010, 9),
          endDate: DateTime(2014, 6),
          gpa: 'First Class Honours',
        ),
      ],
      skills: ['Figma', 'Adobe XD', 'Sketch', 'UI Design', 'UX Research'],
      languages: [
        Language(name: 'English', proficiencyLevel: 'Native'),
        Language(name: 'French', proficiencyLevel: 'Intermediate'),
      ],
      certifications: [],
      projects: [],
      socialLinks: [],
      customSections: [],
    );
  }
}
