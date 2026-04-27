import 'package:android_cv_maker/core/templates/template_blueprint.dart';

class TemplateRegistry {
  static final List<TemplateBlueprint> templates = [
    TemplateBlueprint(
      id: 'classic_ats',
      name: 'Classic ATS',
      layout: TemplateLayout.singleColumn,
      sections: [
        SectionBlueprint(
          name: 'header',
          position: 'header',
          fields: ['fullName', 'title', 'email', 'phone', 'location'],
        ),
        SectionBlueprint(
          name: 'summary',
          position: 'main',
          fields: ['summary'],
        ),
        SectionBlueprint(
          name: 'experience',
          position: 'main',
          fields: [
            'jobTitle',
            'company',
            'startDate',
            'endDate',
            'description',
          ],
          isRepeatable: true,
        ),
        SectionBlueprint(name: 'skills', position: 'main', fields: ['skills']),
        SectionBlueprint(
          name: 'education',
          position: 'main',
          fields: ['degree', 'institution', 'year'],
          isRepeatable: true,
        ),
      ],
      fieldBindings: {
        'fullName': FieldBinding(
          blueprintField: 'fullName',
          controllerName: 'fullName',
        ),
        'email': FieldBinding(blueprintField: 'email', controllerName: 'email'),
        // ... rest
      },
    ),
    // Template 2, Template 3...
  ];

  static TemplateBlueprint getById(String id) {
    return templates.firstWhere((t) => t.id == id);
  }
}
