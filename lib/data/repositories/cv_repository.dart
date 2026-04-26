import 'package:android_cv_maker/data/models/education_model.dart';
import 'package:android_cv_maker/data/models/experience_model.dart';
import 'package:android_cv_maker/data/models/personal_info_model.dart';
import 'package:android_cv_maker/data/models/language_model.dart';
import 'package:android_cv_maker/data/models/certification_model.dart';
import 'package:android_cv_maker/data/models/project_model.dart';
import 'package:android_cv_maker/data/models/social_link_model.dart';
import 'package:android_cv_maker/data/models/custom_section_model.dart';

import '../local/cv_storage.dart';
import '../models/cv_data_model.dart';

class CVRepository {
  final CVStorage _storage = CVStorage();

  Future<void> saveCV(CVDataModel cvData) async {
    try {
      await _storage.saveCVData(cvData);
      print('CV saved successfully: ${cvData.id}');
    } catch (e) {
      print('Error saving CV: $e');
      rethrow;
    }
  }

  Future<CVDataModel?> loadCV() async {
    try {
      return await _storage.loadCVData();
    } catch (e) {
      print('Error loading CV: $e');
      return null;
    }
  }

  Future<void> clearCV() async {
    try {
      await _storage.clearCVData();
      print('CV data cleared successfully');
    } catch (e) {
      print('Error clearing CV: $e');
      rethrow;
    }
  }

  Future<bool> _needsMigration(CVDataModel cv) async {
    // Check for missing new fields
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

  Future<CVDataModel> _migrateData(CVDataModel oldData) async {
    print('Migrating old CV data to new structure...');

    final migratedData = CVDataModel(
      id: oldData.id,
      personalInfo: oldData.personalInfo,
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
      lastUpdated: DateTime.now(),
      selectedTemplateId: oldData.selectedTemplateId,
    );

    await saveCV(migratedData);
    print('Migration complete');
    return migratedData;
  }

  List<LanguageModel> _getDefaultLanguages() {
    return [
      LanguageModel(id: 'lang1', name: 'English', proficiencyLevel: 'Fluent'),
      LanguageModel(id: 'lang2', name: 'Urdu', proficiencyLevel: 'Native'),
    ];
  }

  List<CertificationModel> _getDefaultCertifications() {
    return [
      CertificationModel(
        id: 'cert1',
        name: 'Flutter Development Bootcamp',
        organization: 'Udemy',
        issueDate: DateTime(2023, 6),
      ),
      CertificationModel(
        id: 'cert2',
        name: 'Google Associate Android Developer',
        organization: 'Google',
        issueDate: DateTime(2022, 12),
      ),
    ];
  }

  List<ProjectModel> _getDefaultProjects() {
    return [
      ProjectModel(
        id: 'proj1',
        name: 'E-Commerce App',
        description:
            'A fully functional e-commerce app with payment integration',
        technologies: 'Flutter, Firebase, Stripe',
        projectUrl: 'https://github.com/johndoe/ecommerce',
      ),
      ProjectModel(
        id: 'proj2',
        name: 'Portfolio Website',
        description: 'Personal portfolio website showcasing work',
        technologies: 'Flutter Web, HTML, CSS',
        projectUrl: 'https://johndoe.dev',
      ),
    ];
  }

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

  Future<CVDataModel> getSampleCV() async {
    try {
      final existing = await loadCV();
      if (existing != null) {
        if (await _needsMigration(existing)) {
          return await _migrateData(existing);
        }
        print('Returning existing CV data');
        return existing;
      }
      print('Creating fresh sample CV for new user');
      return _createFreshSample();
    } catch (e) {
      print('Error in getSampleCV: $e');
      return _createFreshSample();
    }
  }

  CVDataModel _createFreshSample() {
    return CVDataModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      personalInfo: PersonalInfoModel(
        fullName: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+92 300 1234567',
        address: 'Karachi, Pakistan',
        summary:
            'Experienced Flutter developer with 5+ years of experience building high-quality mobile applications.',
      ),
      experiences: [
        ExperienceModel(
          id: 'exp1',
          jobTitle: 'Senior Flutter Developer',
          companyName: 'Tech Solutions',
          startDate: DateTime(2022, 1),
          isCurrent: true,
          description:
              'Leading mobile app development team, implementing clean architecture and state management solutions.',
        ),
        ExperienceModel(
          id: 'exp2',
          jobTitle: 'Mobile Developer',
          companyName: 'Startup Inc',
          startDate: DateTime(2019, 6),
          endDate: DateTime(2021, 12),
          isCurrent: false,
          description:
              'Developed cross-platform applications using Flutter and React Native.',
        ),
      ],
      educations: [
        EducationModel(
          id: 'edu1',
          degree: 'BS Computer Science',
          institution: 'University of Karachi',
          startDate: DateTime(2015, 9),
          endDate: DateTime(2019, 6),
          grade: '3.8 GPA',
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
      lastUpdated: DateTime.now(),
      selectedTemplateId: 'usa_classic',
    );
  }

  CVDataModel getDemoCV() {
    return CVDataModel(
      id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
      personalInfo: PersonalInfoModel(
        fullName: 'Jane Smith',
        email: 'jane.smith@example.com',
        phone: '+44 20 7946 0123',
        address: 'London, UK',
        summary:
            'Creative designer with 8+ years of experience in UI/UX design.',
      ),
      experiences: [
        ExperienceModel(
          id: 'demo_exp1',
          jobTitle: 'Lead Product Designer',
          companyName: 'Creative Agency',
          startDate: DateTime(2021, 3),
          isCurrent: true,
          description: 'Leading design team for major client projects.',
        ),
      ],
      educations: [
        EducationModel(
          id: 'demo_edu1',
          degree: 'BA in Design',
          institution: 'Central Saint Martins',
          startDate: DateTime(2010, 9),
          endDate: DateTime(2014, 6),
          grade: 'First Class Honours',
        ),
      ],
      skills: ['Figma', 'Adobe XD', 'Sketch', 'UI Design', 'UX Research'],
      languages: [
        LanguageModel(
          id: 'demo_lang1',
          name: 'English',
          proficiencyLevel: 'Native',
        ),
        LanguageModel(
          id: 'demo_lang2',
          name: 'French',
          proficiencyLevel: 'Intermediate',
        ),
      ],
      certifications: [],
      projects: [],
      socialLinks: [],
      customSections: [],
      lastUpdated: DateTime.now(),
      selectedTemplateId: 'modern_executive',
    );
  }
}
