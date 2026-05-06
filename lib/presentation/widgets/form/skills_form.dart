// File: lib/presentation/widgets/form/optimized_skills_form.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';

class OptimizedSkillsForm extends StatefulWidget {
  final List<String> skills;
  final Function(List<String>) onSkillsChanged;

  const OptimizedSkillsForm({
    super.key,
    required this.skills,
    required this.onSkillsChanged,
  });

  @override
  State<OptimizedSkillsForm> createState() => _OptimizedSkillsFormState();
}

class _OptimizedSkillsFormState extends State<OptimizedSkillsForm> {
  late List<String> _localSkills;
  final TextEditingController _inputController = TextEditingController();
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _localSkills = List.from(widget.skills);
  }
  // File: lib/presentation/widgets/form/optimized_skills_form.dart

  @override
  void didUpdateWidget(OptimizedSkillsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skills != widget.skills) {
      _localSkills = List.from(widget.skills);
      setState(() {});
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSkillsChanged(_localSkills);
    });
  }

  void _addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (_localSkills.contains(skill.trim())) return;

    setState(() {
      _localSkills.add(skill.trim());
    });
    _scheduleSave();
    _inputController.clear();
  }

  void _removeSkill(String skill) {
    setState(() {
      _localSkills.remove(skill);
    });
    _scheduleSave();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _inputController.dispose();
    super.dispose();
  }

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
            if (_localSkills.isEmpty)
              _buildEmptyState(context)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _localSkills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeSkill(skill),
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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _inputController,
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
                _addSkill(value);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: ElevatedButton(
            onPressed: () {
              if (_inputController.text.trim().isNotEmpty) {
                _addSkill(_inputController.text);
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
