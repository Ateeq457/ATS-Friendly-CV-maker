import 'package:flutter/material.dart';
import '../../data/models/template_model.dart';
import '../../core/constants/design_system.dart';

class TemplatePreviewScreen extends StatelessWidget {
  final TemplateModel template;

  const TemplatePreviewScreen({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${template.name} Template'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () {
              // Navigate to create CV with this template
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Creating CV with ${template.name} template...',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(DesignSystem.paddingLarge),
                decoration: BoxDecoration(
                  color: template.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    DesignSystem.radiusXLarge,
                  ),
                  border: Border.all(color: template.color.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(template.icon, size: 80, color: template.color),
                    const SizedBox(height: 24),
                    Text(
                      template.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: template.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: template.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        template.tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        template.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DesignSystem.paddingLarge),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Templates'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    DesignSystem.radiusCircular,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
