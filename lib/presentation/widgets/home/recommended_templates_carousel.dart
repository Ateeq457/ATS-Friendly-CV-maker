import 'package:flutter/material.dart';
import 'template_card.dart';
import '../../../data/models/template_model.dart';

class RecommendedTemplatesCarousel extends StatelessWidget {
  final List<TemplateModel> templates;
  final Function(TemplateModel) onTemplateTap;
  final Function(TemplateModel) onPreviewTap;

  const RecommendedTemplatesCarousel({
    super.key,
    required this.templates,
    required this.onTemplateTap,
    required this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: TemplateCard(
              template: template,
              onTap: () => onTemplateTap(template),
              onPreviewTap: () => onPreviewTap(template),
            ),
          );
        },
      ),
    );
  }
}
