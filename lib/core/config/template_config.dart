class TemplateConfig {
  final String layoutStyle;
  final String? sidebarPosition;
  final int sidebarWidth;
  final String primaryColor;
  final String secondaryColor;
  final String accentColor;
  final String backgroundColor;
  final String surfaceColor;
  final String textColor;
  final String textLightColor;
  final String headerBackgroundColor;
  final String sidebarBackgroundColor;
  final String headingFont;
  final String bodyFont;
  final int headingSize;
  final int subheadingSize;
  final int bodySize;
  final int smallSize;
  final String photoStyle;
  final String photoPosition;
  final int photoSize;
  final bool photoBorder;
  final String photoBorderColor;
  final String headerStyle;
  final bool showContactInHeader;
  final String contactLayout;
  final String experienceStyle;
  final String skillsStyle;
  final String educationStyle;
  final String certificationsStyle;
  final String spacingPreset;
  final int sectionMargin;
  final int itemMargin;
  final int pagePadding;
  final bool showIcons;
  final bool showDividers;
  final bool showProficiencyLevels;
  final bool showTechnologyTags;

  const TemplateConfig({
    required this.layoutStyle,
    this.sidebarPosition,
    required this.sidebarWidth,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.textLightColor,
    required this.headerBackgroundColor,
    required this.sidebarBackgroundColor,
    required this.headingFont,
    required this.bodyFont,
    required this.headingSize,
    required this.subheadingSize,
    required this.bodySize,
    required this.smallSize,
    required this.photoStyle,
    required this.photoPosition,
    required this.photoSize,
    required this.photoBorder,
    required this.photoBorderColor,
    required this.headerStyle,
    required this.showContactInHeader,
    required this.contactLayout,
    required this.experienceStyle,
    required this.skillsStyle,
    required this.educationStyle,
    required this.certificationsStyle,
    required this.spacingPreset,
    required this.sectionMargin,
    required this.itemMargin,
    required this.pagePadding,
    required this.showIcons,
    required this.showDividers,
    required this.showProficiencyLevels,
    required this.showTechnologyTags,
  });

  bool get isSidebarLeft =>
      layoutStyle == 'sidebar-left' || sidebarPosition == 'left';
  bool get isSidebarRight =>
      layoutStyle == 'sidebar-right' || sidebarPosition == 'right';
  bool get isHeaderCentered => layoutStyle == 'header-centered';
  bool get isSingleColumn => layoutStyle == 'single-column';
  bool get isTwoColumn => layoutStyle == 'two-column';
}
