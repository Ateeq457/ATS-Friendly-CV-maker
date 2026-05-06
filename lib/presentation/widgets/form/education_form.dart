// File: lib/presentation/widgets/form/optimized_education_form.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart';
import 'optimized_text_field.dart';

class OptimizedEducationForm extends StatefulWidget {
  final List<Education> educations;
  final Function(List<Education>) onEducationsChanged;

  const OptimizedEducationForm({
    super.key,
    required this.educations,
    required this.onEducationsChanged,
  });

  @override
  State<OptimizedEducationForm> createState() => _OptimizedEducationFormState();
}

class _OptimizedEducationFormState extends State<OptimizedEducationForm> {
  late List<Education> _localEducations;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _localEducations = List.from(widget.educations);
  }

  @override
  void didUpdateWidget(OptimizedEducationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.educations != widget.educations) {
      _localEducations = List.from(widget.educations);
      setState(() {});
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onEducationsChanged(_localEducations);
    });
  }

  void _addEducation() {
    setState(() {
      _localEducations.add(Education.empty());
    });
    _scheduleSave();
  }

  void _updateEducation(int index, Education updated) {
    setState(() {
      _localEducations[index] = updated;
    });
    _scheduleSave();
  }

  void _removeEducation(int index) {
    setState(() {
      _localEducations.removeAt(index);
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
                Icon(Icons.school, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Education',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addEducation,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_localEducations.isEmpty)
              _buildEmptyState(context)
            else
              ..._localEducations.asMap().entries.map((entry) {
                return _buildEducationCard(context, entry.key, entry.value);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.school_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No education added yet',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _addEducation,
              child: const Text('Add Education'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard(
    BuildContext context,
    int index,
    Education education,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.drag_handle, color: Colors.grey[400]),
            title: Text(
              education.degree.isEmpty ? 'New Education' : education.degree,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              education.institution.isEmpty
                  ? 'Add institution'
                  : education.institution,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeEducation(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                OptimizedTextField(
                  initialValue: education.degree,
                  label: 'Degree *',
                  hint: 'BS Computer Science',
                  prefixIcon: Icons.verified,
                  onChanged: (value) {
                    _updateEducation(
                      index,
                      Education(
                        degree: value,
                        institution: education.institution,
                        startDate: education.startDate,
                        endDate: education.endDate,
                        gpa: education.gpa,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: education.institution,
                  label: 'Institution *',
                  hint: 'University of Example',
                  prefixIcon: Icons.business,
                  onChanged: (value) {
                    _updateEducation(
                      index,
                      Education(
                        degree: education.degree,
                        institution: value,
                        startDate: education.startDate,
                        endDate: education.endDate,
                        gpa: education.gpa,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDateSection(context, education, index),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: education.endDate == null,
                      onChanged: (value) {
                        _updateEducation(
                          index,
                          Education(
                            degree: education.degree,
                            institution: education.institution,
                            startDate: education.startDate,
                            endDate: value == true ? null : DateTime.now(),
                            gpa: education.gpa,
                          ),
                        );
                      },
                    ),
                    const Text('I currently study here'),
                  ],
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: education.gpa ?? '',
                  label: 'Grade (Optional)',
                  hint: '3.8 / 4.0, A+, First Class...',
                  prefixIcon: Icons.star,
                  onChanged: (value) {
                    _updateEducation(
                      index,
                      Education(
                        degree: education.degree,
                        institution: education.institution,
                        startDate: education.startDate,
                        endDate: education.endDate,
                        gpa: value.isEmpty ? null : value,
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

  Widget _buildDateSection(
    BuildContext context,
    Education education,
    int index,
  ) {
    final isCurrent = education.endDate == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isCurrent)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildDateField(
                      context,
                      initialDate: education.startDate,
                      onSelected: (date) {
                        _updateEducation(
                          index,
                          Education(
                            degree: education.degree,
                            institution: education.institution,
                            startDate: date,
                            endDate: education.endDate,
                            gpa: education.gpa,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End Date',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildDateField(
                      context,
                      initialDate: education.endDate ?? DateTime.now(),
                      onSelected: (date) {
                        _updateEducation(
                          index,
                          Education(
                            degree: education.degree,
                            institution: education.institution,
                            startDate: education.startDate,
                            endDate: date,
                            gpa: education.gpa,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start Date',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              _buildDateField(
                context,
                initialDate: education.startDate,
                onSelected: (date) {
                  _updateEducation(
                    index,
                    Education(
                      degree: education.degree,
                      institution: education.institution,
                      startDate: date,
                      endDate: education.endDate,
                      gpa: education.gpa,
                    ),
                  );
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required DateTime initialDate,
    required Function(DateTime) onSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          onSelected(picked);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              '${initialDate.year}-${initialDate.month.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
