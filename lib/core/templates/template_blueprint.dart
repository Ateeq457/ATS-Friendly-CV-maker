class TemplateBlueprint {
  final String id;
  final String name;
  final TemplateLayout layout;
  final List<SectionBlueprint> sections;
  final Map<String, FieldBinding> fieldBindings;

  const TemplateBlueprint({
    required this.id,
    required this.name,
    required this.layout,
    required this.sections,
    required this.fieldBindings,
  });
}

enum TemplateLayout { singleColumn, twoColumn, sidebarLeft, sidebarRight }

class SectionBlueprint {
  final String name;
  final String position; // header, sidebar, main, footer
  final List<String> fields;
  final bool isRepeatable;

  const SectionBlueprint({
    required this.name,
    required this.position,
    required this.fields,
    this.isRepeatable = false,
  });
}

class FieldBinding {
  final String blueprintField;
  final String controllerName;

  const FieldBinding({
    required this.blueprintField,
    required this.controllerName,
  });
}
