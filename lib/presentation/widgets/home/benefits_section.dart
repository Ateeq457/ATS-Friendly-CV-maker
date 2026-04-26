import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/template_model.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final benefits = TemplateModel.getBenefits();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignSystem.paddingLarge),
      padding: const EdgeInsets.all(DesignSystem.paddingXLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.05),
            Theme.of(context).colorScheme.secondary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignSystem.radiusXLarge),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why choose us?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(benefits.length, (index) {
              return Expanded(
                child: Column(
                  children: [
                    Icon(
                      benefits[index].icon,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      benefits[index].title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      benefits[index].description,
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
