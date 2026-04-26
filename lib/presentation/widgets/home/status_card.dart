import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';

class StatusCard extends StatelessWidget {
  final int draftsCount;
  final int completedCount;

  const StatusCard({
    super.key,
    required this.draftsCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignSystem.radiusXLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusItem(Icons.edit_note, '$draftsCount', 'Drafts'),
          _buildStatusItem(Icons.check_circle, '$completedCount', 'Completed'),
          _buildStatusItem(Icons.access_time, 'Today', 'Last active'),
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
