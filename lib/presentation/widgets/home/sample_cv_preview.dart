import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../widgets/shared/animated_card.dart';

class SampleCVPreview extends StatelessWidget {
  final VoidCallback onViewSample;

  const SampleCVPreview({super.key, required this.onViewSample});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.paddingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'See what you\'ll create',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Professional CV that gets you noticed',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          AnimatedCard(
            onTap: onViewSample,
            child: Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(DesignSystem.radiusXLarge),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignSystem.radiusXLarge),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.15),
                            Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.08),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.description, size: 64),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Theme.of(
                              context,
                            ).scaffoldBackgroundColor.withOpacity(0.95),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: ElevatedButton.icon(
                        onPressed: onViewSample,
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('View Sample CV'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
  