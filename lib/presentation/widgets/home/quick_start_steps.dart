import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/template_model.dart';

class QuickStartSteps extends StatelessWidget {
  const QuickStartSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = TemplateModel.getQuickSteps();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.paddingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How it works',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length, (index) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        steps[index].icon,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      steps[index].title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[index].description,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
