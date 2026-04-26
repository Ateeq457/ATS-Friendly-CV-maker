import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../widgets/shared/animated_card.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onCreateCV;

  const HeroSection({super.key, required this.onCreateCV});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignSystem.paddingXXLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(DesignSystem.radiusXXLarge),
          bottomRight: Radius.circular(DesignSystem.radiusXXLarge),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Build your professional CV',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'ATS-friendly, recruiter approved templates',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AnimatedCard(
            onTap: onCreateCV,
            elevation: 0,
            child: ElevatedButton.icon(
              onPressed: onCreateCV,
              icon: const Icon(Icons.rocket_launch, size: 20),
              label: const Text(
                'Create Your CV',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    DesignSystem.radiusCircular,
                  ),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
