import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/template_model.dart';
import '../../widgets/shared/animated_card.dart';

class TemplateCard extends StatelessWidget {
  final TemplateModel template;
  final VoidCallback onTap;
  final VoidCallback onPreviewTap;
  final double? width;
  final double? height;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onTap,
    required this.onPreviewTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      child: Container(
        width: width ?? 150,
        height: height ?? 175, // ✅ Fixed height to prevent overflow
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
          border: Border.all(color: template.color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Template Preview
            Container(
              height: 95, // ✅ Reduced from 100
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    template.color.withOpacity(0.2),
                    template.color.withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(DesignSystem.radiusLarge),
                  topRight: Radius.circular(DesignSystem.radiusLarge),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 25,
                      height: 3,
                      color: template.color,
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 8,
                    child: Container(
                      width: 40,
                      height: 2,
                      color: template.color.withOpacity(0.5),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 8,
                    child: Icon(template.icon, size: 16, color: template.color),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: template.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        template.tag,
                        style: const TextStyle(
                          fontSize: 6,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onPreviewTap,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: template.color),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(0, 22),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Preview',
                            style: TextStyle(fontSize: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: template.color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(0, 22),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          child: const Text(
                            'Use',
                            style: TextStyle(fontSize: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
