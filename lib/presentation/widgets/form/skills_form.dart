import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';

class SkillsForm extends StatelessWidget {
  final List<String> skills;
  final Function(String) onAddSkill;
  final Function(String) onRemoveSkill;

  const SkillsForm({
    super.key,
    required this.skills,
    required this.onAddSkill,
    required this.onRemoveSkill,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Skills',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildSkillInput(context),
            const SizedBox(height: 16),
            if (skills.isEmpty)
              _buildEmptyState(context)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => onRemoveSkill(skill),
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.1),
                    deleteIconColor: Colors.grey[600],
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillInput(BuildContext context) {
    final controller = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'e.g., Flutter, Dart, Firebase...',
              prefixIcon: Icon(Icons.add_circle_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                onAddSkill(value.trim());
                controller.clear();
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onAddSkill(controller.text.trim());
                controller.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Add'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.code_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No skills added yet',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Type a skill and press Enter',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
