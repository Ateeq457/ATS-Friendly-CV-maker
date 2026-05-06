// File: lib/presentation/widgets/form/optimized_experience_section.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/models/cv_data.dart';
import 'optimized_text_field.dart';

class OptimizedExperienceSection extends StatefulWidget {
  final List<Experience> experiences;
  final Function(List<Experience>) onExperiencesChanged;

  const OptimizedExperienceSection({
    super.key,
    required this.experiences,
    required this.onExperiencesChanged,
  });

  @override
  State<OptimizedExperienceSection> createState() =>
      _OptimizedExperienceSectionState();
}

class _OptimizedExperienceSectionState
    extends State<OptimizedExperienceSection> {
  late List<Experience> _localExperiences;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _localExperiences = List.from(widget.experiences);
  }

  // ✅ ADD THIS METHOD - React to parent data changes
  @override
  void didUpdateWidget(OptimizedExperienceSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local data when parent data changes (e.g., dummy data filled)
    if (oldWidget.experiences != widget.experiences) {
      _localExperiences = List.from(widget.experiences);
      // Force rebuild to show new data
      setState(() {});
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onExperiencesChanged(_localExperiences);
    });
  }

  void _addExperience() {
    setState(() {
      _localExperiences.add(Experience.empty());
    });
    _scheduleSave();
  }

  void _updateExperience(int index, Experience updatedExp) {
    setState(() {
      _localExperiences[index] = updatedExp;
    });
    _scheduleSave();
  }

  void _removeExperience(int index) {
    setState(() {
      _localExperiences.removeAt(index);
    });
    _scheduleSave();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Work Experience',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addExperience,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(),
            if (_localExperiences.isEmpty)
              _buildEmptyState()
            else
              ..._localExperiences.asMap().entries.map((entry) {
                return _buildExperienceCard(entry.key, entry.value);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.work_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No experience added yet',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _addExperience,
              child: const Text('Add Experience'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(int index, Experience exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.drag_handle, color: Colors.grey[400]),
            title: Text(
              exp.jobTitle.isEmpty ? 'New Experience' : exp.jobTitle,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeExperience(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                OptimizedTextField(
                  initialValue: exp.jobTitle,
                  label: 'Job Title *',
                  hint: 'Senior Flutter Developer',
                  prefixIcon: Icons.title,
                  onChanged: (value) {
                    _updateExperience(
                      index,
                      Experience(
                        jobTitle: value,
                        company: exp.company,
                        startDate: exp.startDate,
                        endDate: exp.endDate,
                        isCurrent: exp.isCurrent,
                        description: exp.description,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: exp.company,
                  label: 'Company Name *',
                  hint: 'Google / Microsoft / Startup',
                  prefixIcon: Icons.business,
                  onChanged: (value) {
                    _updateExperience(
                      index,
                      Experience(
                        jobTitle: exp.jobTitle,
                        company: value,
                        startDate: exp.startDate,
                        endDate: exp.endDate,
                        isCurrent: exp.isCurrent,
                        description: exp.description,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: exp.isCurrent,
                      onChanged: (value) {
                        _updateExperience(
                          index,
                          Experience(
                            jobTitle: exp.jobTitle,
                            company: exp.company,
                            startDate: exp.startDate,
                            endDate: value == true ? null : exp.endDate,
                            isCurrent: value ?? false,
                            description: exp.description,
                          ),
                        );
                      },
                    ),
                    const Text('I currently work here'),
                  ],
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: exp.description,
                  label: 'Description *',
                  maxLines: 3,
                  onChanged: (value) {
                    _updateExperience(
                      index,
                      Experience(
                        jobTitle: exp.jobTitle,
                        company: exp.company,
                        startDate: exp.startDate,
                        endDate: exp.endDate,
                        isCurrent: exp.isCurrent,
                        description: value,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
