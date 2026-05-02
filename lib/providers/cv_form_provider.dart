import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/cv_data.dart';
import '../data/local/cv_storage.dart';

class CVFormProvider extends ChangeNotifier {
  final CVStorage _storage = CVStorage();

  CVData _cvData = CVData.empty();
  bool _isLoading = false;
  Timer? _debounceTimer;

  CVData get cvData => _cvData;
  bool get isLoading => _isLoading;

  Future<void> loadCV(String? id) async {
    if (id == null) return;
    _isLoading = true;
    notifyListeners();
    final loaded = await _storage.loadCVData(id);
    if (loaded != null) _cvData = loaded;
    _isLoading = false;
    notifyListeners();
  }

  void updateField(String field, String value) {
    switch (field) {
      case 'fullName':
        _cvData.fullName = value;
        break;
      case 'email':
        _cvData.email = value;
        break;
      case 'phone':
        _cvData.phone = value;
        break;
      case 'location':
        _cvData.location = value;
        break;
      case 'summary':
        _cvData.summary = value;
        break;
      case 'title':
        _cvData.title = value;
        break;
    }
    notifyListeners();
    _debouncedAutoSave();
  }

  void addExperience(Experience exp) {
    _cvData.experiences.add(exp);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateExperience(int index, Experience exp) {
    _cvData.experiences[index] = exp;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeExperience(int index) {
    _cvData.experiences.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addEducation(Education edu) {
    _cvData.educations.add(edu);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateEducation(int index, Education edu) {
    _cvData.educations[index] = edu;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeEducation(int index) {
    _cvData.educations.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (!_cvData.skills.contains(skill.trim())) {
      _cvData.skills.add(skill.trim());
      notifyListeners();
      _debouncedAutoSave();
    }
  }

  void removeSkill(String skill) {
    _cvData.skills.remove(skill);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addLanguage(Language lang) {
    _cvData.languages.add(lang);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateLanguage(int index, Language lang) {
    _cvData.languages[index] = lang;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeLanguage(int index) {
    _cvData.languages.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addCertification(Certification cert) {
    _cvData.certifications.add(cert);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateCertification(int index, Certification cert) {
    _cvData.certifications[index] = cert;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeCertification(int index) {
    _cvData.certifications.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addProject(Project proj) {
    _cvData.projects.add(proj);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateProject(int index, Project proj) {
    _cvData.projects[index] = proj;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeProject(int index) {
    _cvData.projects.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addSocialLink(SocialLinkModel link) {
    _cvData.socialLinks.add(link);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateSocialLink(int index, SocialLinkModel link) {
    _cvData.socialLinks[index] = link;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeSocialLink(int index) {
    _cvData.socialLinks.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addCustomSection(CustomSectionModel section) {
    _cvData.customSections.add(section);
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeCustomSection(int index) {
    _cvData.customSections.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateCustomSectionTitle(int index, String title) {
    _cvData.customSections[index].title = title;
    notifyListeners();
    _debouncedAutoSave();
  }

  void addCustomSectionEntry(int sectionIndex) {
    _cvData.customSections[sectionIndex].entries.add(
      CustomSectionEntry.empty(),
    );
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateCustomSectionEntry(
    int sectionIndex,
    int entryIndex,
    String title,
    String description,
    String? date,
  ) {
    final entry = _cvData.customSections[sectionIndex].entries[entryIndex];
    entry.title = title;
    entry.description = description;
    entry.date = date;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeCustomSectionEntry(int sectionIndex, int entryIndex) {
    _cvData.customSections[sectionIndex].entries.removeAt(entryIndex);
    notifyListeners();
    _debouncedAutoSave();
  }

  void _debouncedAutoSave() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      await _storage.saveCVData(_cvData);
    });
  }

  Future<void> forceSave() async {
    _debounceTimer?.cancel();
    await _storage.saveCVData(_cvData);
  }

  void fillDummyData() {
    _cvData = CVData(
      // ========== PERSONAL INFO ==========
      fullName: 'Ateeq Ur Rehman',
      title: 'Senior Flutter Developer',
      email: 'ateeq@example.com',
      phone: '+92 300 1234567',
      location: 'Karachi, Pakistan',
      linkedin: 'linkedin.com/in/ateeq',
      github: 'github.com/ateeq',
      summary:
          'Experienced Flutter developer with 5+ years of experience building high-quality mobile applications. Expert in clean architecture, state management, and API integration. Passionate about creating efficient and scalable solutions.',

      // ========== EXPERIENCES ==========
      experiences: [
        Experience(
          jobTitle: 'Senior Flutter Developer',
          company: 'Tech Solutions Pvt Ltd',
          startDate: DateTime(2022, 1),
          endDate: null,
          isCurrent: true,
          description:
              'Leading mobile app development team of 5 developers. Implemented clean architecture and BLoC pattern. Reduced app crashes by 40% and improved performance by 30%. Successfully delivered 8+ production apps.',
        ),
        Experience(
          jobTitle: 'Flutter Developer',
          company: 'Startup Hub',
          startDate: DateTime(2020, 6),
          endDate: DateTime(2021, 12),
          isCurrent: false,
          description:
              'Developed 3 cross-platform apps from scratch. Integrated REST APIs and Firebase. Achieved 4.8+ rating on app stores. Worked closely with UI/UX designers to implement responsive designs.',
        ),
        Experience(
          jobTitle: 'Junior Developer',
          company: 'Software House',
          startDate: DateTime(2019, 1),
          endDate: DateTime(2020, 5),
          isCurrent: false,
          description:
              'Worked on bug fixes and feature implementation. Collaborated with senior developers to deliver projects on time. Gained experience in Agile methodology and version control.',
        ),
      ],

      // ========== EDUCATIONS ==========
      educations: [
        Education(
          degree: 'MS Computer Science',
          institution: 'NED University',
          startDate: DateTime(2021, 9),
          endDate: DateTime(2023, 6),
          gpa: '3.9/4.0',
        ),
        Education(
          degree: 'BS Software Engineering',
          institution: 'University of Karachi',
          startDate: DateTime(2015, 9),
          endDate: DateTime(2019, 6),
          gpa: '3.7/4.0',
        ),
      ],

      // ========== SKILLS ==========
      skills: [
        'Flutter',
        'Dart',
        'Firebase',
        'REST API',
        'Git',
        'Provider',
        'BLoC',
        'GetX',
        'Riverpod',
        'SQLite',
        'CI/CD',
        'Unit Testing',
        'Agile',
        'Jira',
        'Figma',
      ],

      // ========== LANGUAGES ==========
      languages: [
        Language(name: 'English', proficiencyLevel: 'Fluent'),
        Language(name: 'Urdu', proficiencyLevel: 'Native'),
        Language(name: 'Arabic', proficiencyLevel: 'Intermediate'),
      ],

      // ========== CERTIFICATIONS ==========
      certifications: [
        Certification(
          name: 'Google Associate Android Developer',
          issuer: 'Google',
          issueDate: DateTime(2023, 3),
          expiryDate: null,
          credentialId: 'GAD-12345',
          credentialUrl: 'https://google.com/cert',
        ),
        Certification(
          name: 'Flutter Advanced Course',
          issuer: 'Udemy',
          issueDate: DateTime(2022, 6),
          expiryDate: null,
          credentialId: 'UD-67890',
          credentialUrl: 'https://udemy.com/cert',
        ),
        Certification(
          name: 'Firebase Masterclass',
          issuer: 'Coursera',
          issueDate: DateTime(2022, 1),
          expiryDate: null,
          credentialId: null,
          credentialUrl: null,
        ),
      ],

      // ========== PROJECTS ==========
      projects: [
        Project(
          name: 'E-Commerce App',
          description:
              'A full-featured e-commerce app with product listing, cart, payment integration, and order tracking. Used by 10,000+ users.',
          technologies: 'Flutter, Firebase, Stripe API',
          projectUrl: 'https://github.com/ateeq/ecommerce',
        ),
        Project(
          name: 'AI Chat Assistant',
          description:
              'Chat application with AI-powered responses using OpenAI API. Features voice input and real-time translation.',
          technologies: 'Flutter, OpenAI API, WebSockets',
          projectUrl: 'https://github.com/ateeq/ai-chat',
        ),
        Project(
          name: 'Task Management App',
          description:
              'Productivity app for managing tasks, projects, and team collaboration. Includes notifications and analytics.',
          technologies: 'Flutter, BLoC, Hive, Firebase Cloud Messaging',
          projectUrl: 'https://github.com/ateeq/task-manager',
        ),
      ],

      // ========== SOCIAL LINKS ==========
      socialLinks: [
        SocialLinkModel(
          id: '1',
          platform: 'linkedin',
          url: 'https://linkedin.com/in/ateeq',
        ),
        SocialLinkModel(
          id: '2',
          platform: 'github',
          url: 'https://github.com/ateeq',
        ),
        SocialLinkModel(
          id: '3',
          platform: 'twitter',
          url: 'https://twitter.com/ateeq',
        ),
        SocialLinkModel(
          id: '4',
          platform: 'portfolio',
          url: 'https://ateeq.dev',
        ),
      ],

      // ========== CUSTOM SECTIONS ==========
      customSections: [
        CustomSectionModel(
          id: '1',
          title: '🏆 Achievements',
          entries: [
            CustomSectionEntry(
              id: '1',
              title: 'Best Developer Award 2023',
              description:
                  'Received recognition for outstanding performance and contribution to company projects.',
              date: '2023',
            ),
            CustomSectionEntry(
              id: '2',
              title: 'Hackathon Winner',
              description:
                  'Won first prize in national-level hackathon for innovative healthcare solution.',
              date: '2022',
            ),
          ],
        ),
        CustomSectionModel(
          id: '2',
          title: '🤝 Volunteer Work',
          entries: [
            CustomSectionEntry(
              id: '3',
              title: 'Tech Mentor',
              description:
                  'Mentoring aspiring developers in local coding bootcamp. Conducted workshops on Flutter and Firebase.',
              date: '2023-Present',
            ),
          ],
        ),
      ],

      photoBytes: null,
    );

    notifyListeners();
    forceSave();

    debugPrint('✅ Dummy data filled with all fields!');
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
