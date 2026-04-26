import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_model.dart';
import '../../widgets/shared/animated_card.dart';

class ContinueCard extends StatelessWidget {
  final CVModel draft;
  final VoidCallback onContinue;

  const ContinueCard({
    super.key,
    required this.draft,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onContinue,
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.paddingLarge),
        decoration: DesignSystem.cardDecoration(context).copyWith(
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
              ),
              child: Icon(
                Icons.description,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Continue where you left',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    draft.title,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: draft.progress,
                    backgroundColor: Colors.grey[300],
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    DesignSystem.radiusMedium,
                  ),
                ),
                minimumSize: const Size(80, 36),
              ),
              child: const Text('Continue', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
