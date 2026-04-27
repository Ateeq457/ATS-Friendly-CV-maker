import 'dart:typed_data';

class CVData {
  // Personal Info
  String fullName;
  String title;
  String email;
  String phone;
  String location;
  String linkedin;
  String github;
  String summary;
  Uint8List? photoBytes;

  // Sections
  List<Experience> experiences;
  List<Education> educations;
  List<String> skills;
  List<Project> projects;
  List<Certification> certifications;
  List<Language> languages;

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
  });

  // Empty constructor for new CV
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

  // Sample data for testing
  factory CVData.sample() {
    return CVData(
      fullName: 'ATEEQ UR REHMAN',
      title: 'Flutter Developer | Frontend Engineer',
      email: 'ateeqofficial2404@gmail.com',
      phone: '+92 317 5614346',
      location: '',
      linkedin: 'linkedin.com/in/ateeq-ur-rehman-7b866235b',
      github: '',
      summary:
          'Motivated Flutter Developer with 1 year of hands-on experience building cross-platform mobile applications using Flutter, Dart, and REST APIs including 6 months of professional internship experience at a software firm. Proven ability to deliver end-to-end solutions from responsive UI design to API integration and deployment.',
      experiences: [
        Experience(
          jobTitle: 'Flutter Developer Intern',
          company: 'Flexwave Technology — Onsite',
          startDate: 'Jan 2024',
          endDate: 'Jun 2024',
          isCurrent: false,
          description:
              '• Developed and deployed responsive, high-performance mobile UIs using Flutter and Dart\n• Integrated 10+ RESTful API endpoints enabling real-time data synchronization\n• Built a reusable Flutter widget library reducing development time by approximately 30%\n• Optimized UI rendering and app performance through lazy loading and efficient state management\n• Collaborated with backend engineers to design data contracts',
        ),
        Experience(
          jobTitle: 'Freelance Flutter Developer',
          company: 'Self-Employed — Remote',
          startDate: '2023',
          endDate: 'Present',
          isCurrent: true,
          description:
              '• Designed and delivered 4+ end-to-end Flutter applications for independent clients\n• Architected scalable application structures tailored to client requirements\n• Managed full project lifecycle from requirements gathering through deployment',
        ),
      ],
      educations: [
        Education(
          degree: 'BS in Software Engineering',
          institution: 'Abbottabad University of Science and Technology',
          startDate: '',
          endDate: '',
          gpa: 'Expected: 2027',
        ),
      ],
      skills: [
        'Dart',
        'Python',
        'JavaScript',
        'Flutter',
        'FastAPI',
        'Provider',
        'Riverpod',
        'REST APIs',
        'JSON',
        'Firebase',
        'Git',
        'GitHub',
        'Postman',
      ],
      projects: [
        Project(
          name: 'Hotel Booking Application',
          description:
              'Built a fully functional hotel booking mobile app with real-time availability, booking workflows, and dynamic data fetched via REST API integration.',
          technologies: 'Flutter, Dart, REST APIs',
        ),
        Project(
          name: 'AI Smart Billing Assistant',
          description:
              'Developed an AI-assisted billing system that automated invoice generation and transaction management.',
          technologies: 'Flutter, Dart, AI Logic',
        ),
        Project(
          name: 'Apartment Management System',
          description:
              'Engineered a full-stack management platform for tenant records, billing, and occupancy tracking.',
          technologies: 'Flutter, FastAPI, Python',
        ),
      ],
      certifications: [
        Certification(
          name:
              'Delivered 4+ production-ready Flutter applications including AI-based and full-stack systems',
          issuer: '',
          date: '',
        ),
        Certification(
          name:
              'Completed 6-month professional internship with hands-on experience in API integration',
          issuer: '',
          date: '',
        ),
        Certification(
          name:
              'Developed AI-assisted billing system demonstrating practical implementation of intelligent automation',
          issuer: '',
          date: '',
        ),
      ],
      languages: [
        Language(name: 'English', proficiency: 'Fluent'),
        Language(name: 'Urdu', proficiency: 'Native'),
      ],
    );
  }

  // ✅ To JSON
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
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'skills': skills,
      'projects': projects.map((p) => p.toJson()).toList(),
      'certifications': certifications.map((c) => c.toJson()).toList(),
      'languages': languages.map((l) => l.toJson()).toList(),
    };
  }

  // ✅ From JSON
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
              ?.map((e) => Experience.fromJson(e))
              .toList() ??
          [],
      educations:
          (json['educations'] as List?)
              ?.map((e) => Education.fromJson(e))
              .toList() ??
          [],
      skills: List<String>.from(json['skills'] ?? []),
      projects:
          (json['projects'] as List?)
              ?.map((p) => Project.fromJson(p))
              .toList() ??
          [],
      certifications:
          (json['certifications'] as List?)
              ?.map((c) => Certification.fromJson(c))
              .toList() ??
          [],
      languages:
          (json['languages'] as List?)
              ?.map((l) => Language.fromJson(l))
              .toList() ??
          [],
    );
  }
}

// ✅ Experience with JSON
class Experience {
  String jobTitle;
  String company;
  String startDate;
  String endDate;
  bool isCurrent;
  String description;

  Experience({
    required this.jobTitle,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrent': isCurrent,
      'description': description,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      jobTitle: json['jobTitle'] ?? '',
      company: json['company'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      isCurrent: json['isCurrent'] ?? false,
      description: json['description'] ?? '',
    );
  }

  static Experience empty() {
    return Experience(
      jobTitle: '',
      company: '',
      startDate: '',
      endDate: '',
      isCurrent: false,
      description: '',
    );
  }
}

// ✅ Education with JSON
class Education {
  String degree;
  String institution;
  String startDate;
  String endDate;
  String? gpa;

  Education({
    required this.degree,
    required this.institution,
    required this.startDate,
    required this.endDate,
    this.gpa,
  });

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'startDate': startDate,
      'endDate': endDate,
      'gpa': gpa,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      gpa: json['gpa'],
    );
  }

  static Education empty() {
    return Education(
      degree: '',
      institution: '',
      startDate: '',
      endDate: '',
      gpa: null,
    );
  }
}

// ✅ Project with JSON
class Project {
  String name;
  String description;
  String technologies;

  Project({
    required this.name,
    required this.description,
    required this.technologies,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      technologies: json['technologies'] ?? '',
    );
  }

  static Project empty() {
    return Project(name: '', description: '', technologies: '');
  }
}

// ✅ Certification with JSON
class Certification {
  String name;
  String issuer;
  String date;

  Certification({required this.name, required this.issuer, required this.date});

  Map<String, dynamic> toJson() {
    return {'name': name, 'issuer': issuer, 'date': date};
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'] ?? '',
      issuer: json['issuer'] ?? '',
      date: json['date'] ?? '',
    );
  }

  static Certification empty() {
    return Certification(name: '', issuer: '', date: '');
  }
}

// ✅ Language with JSON
class Language {
  String name;
  String proficiency;

  Language({required this.name, required this.proficiency});

  Map<String, dynamic> toJson() {
    return {'name': name, 'proficiency': proficiency};
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'] ?? '',
      proficiency: json['proficiency'] ?? '',
    );
  }

  static Language empty() {
    return Language(name: '', proficiency: '');
  }
}
