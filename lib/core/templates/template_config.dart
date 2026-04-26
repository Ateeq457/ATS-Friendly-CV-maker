class TemplateConfig {
  final String id;
  final String name;
  final bool supportsPhoto;
  final List<String> sections;

  const TemplateConfig({
    required this.id,
    required this.name,
    this.supportsPhoto = false,
    this.sections = const [
      'header',
      'summary',
      'experience',
      'education',
      'skills',
      'languages',
    ],
  });

  // Predefined templates
  static const usaClassic = TemplateConfig(
    id: 'usa_classic',
    name: 'USA ATS Classic',
    supportsPhoto: false,
  );

  static const modernProfessional = TemplateConfig(
    id: 'modern_professional',
    name: 'Modern Professional',
    supportsPhoto: false,
  );

  static const freshersOnePage = TemplateConfig(
    id: 'freshers_one_page',
    name: 'Freshers One-Page',
    supportsPhoto: false,
  );

  static List<TemplateConfig> get allTemplates => [
    usaClassic,
    modernProfessional,
    freshersOnePage,
  ];
}
