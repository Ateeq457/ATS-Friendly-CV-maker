import 'package:flutter/material.dart';
import 'package:android_cv_maker/presentation/screens/template_preview_screen.dart';
import '../../core/constants/design_system.dart';
import '../../data/models/template_model.dart';
import '../widgets/home/template_carousel.dart';
import '../widgets/home/section_header.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'All Templates',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSystem.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Popular',
              action: '',
              onActionTap: null,
            ),
            const SizedBox(height: 12),
            TemplateCarousel(
              templates: TemplateModel.getPopularTemplates(),
              onTemplateTap: (template) =>
                  _navigateToTemplateDetail(context, template),
              onPreviewTap: (template) => _previewTemplate(context, template),
              onSeeAll: () {},
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Recommended for You',
              action: '',
              onActionTap: null,
            ),
            const SizedBox(height: 12),
            TemplateCarousel(
              templates: TemplateModel.getRecommendedTemplates(),
              onTemplateTap: (template) =>
                  _navigateToTemplateDetail(context, template),
              onPreviewTap: (template) => _previewTemplate(context, template),
              onSeeAll: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _previewTemplate(BuildContext context, TemplateModel template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplatePreviewScreen(template: template),
      ),
    );
  }

  void _navigateToTemplateDetail(BuildContext context, TemplateModel template) {
    // Use template - navigate to create CV with this template
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating CV with ${template.name} template...'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
