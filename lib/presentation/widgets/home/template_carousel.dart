import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/template_model.dart';
import '../../widgets/shared/animated_card.dart';
import 'template_card.dart'; // ✅ Reusing TemplateCard

class TemplateCarousel extends StatelessWidget {
  final Function(TemplateModel) onTemplateTap;
  final Function(TemplateModel) onPreviewTap; // ✅ Added preview callback
  final VoidCallback onSeeAll;
  final List<TemplateModel> templates;

  const TemplateCarousel({
    super.key,
    required this.onTemplateTap,
    required this.onPreviewTap, // ✅ Required
    required this.onSeeAll,
    required this.templates,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.paddingLarge,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Templates',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  'See all',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 185, // ✅ Same as RecommendedTemplatesCarousel
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: DesignSystem.paddingLarge,
            ),
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
        ),
      ],
    );
  }
}
