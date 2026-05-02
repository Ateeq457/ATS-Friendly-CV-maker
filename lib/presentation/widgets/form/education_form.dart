import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart'; // ✅ Import from cv_data

class EducationForm extends StatelessWidget {
  final List<Education> educations; // ✅ Changed from EducationModel
  final VoidCallback onAddEducation;
  final Function(int, Education) onUpdateEducation; // ✅ Changed
  final Function(int) onRemoveEducation;

  const EducationForm({
    super.key,
    required this.educations,
    required this.onAddEducation,
    required this.onUpdateEducation,
    required this.onRemoveEducation,
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
                Icon(Icons.school, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Education',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddEducation,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (educations.isEmpty)
              _buildEmptyState(context)
            else
              ...List.generate(educations.length, (index) {
                return _buildEducationCard(context, index, educations[index]);
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
              onPressed: onAddEducation,
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
              onPressed: () => onRemoveEducation(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Degree *',
                    hintText: 'BS Computer Science',
                    prefixIcon: Icon(Icons.verified),
                  ),
                  controller: TextEditingController(text: education.degree)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: education.degree.length),
                    ),
                  onChanged: (value) {
                    final updated = Education(
                      degree: value,
                      institution: education.institution,
                      startDate: education.startDate,
                      endDate: education.endDate,
                      gpa: education.gpa,
                    );
                    onUpdateEducation(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Institution *',
                    hintText: 'University of Example',
                    prefixIcon: Icon(Icons.business),
                  ),
                  controller: TextEditingController(text: education.institution)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: education.institution.length),
                    ),
                  onChanged: (value) {
                    final updated = Education(
                      degree: education.degree,
                      institution: value,
                      startDate: education.startDate,
                      endDate: education.endDate,
                      gpa: education.gpa,
                    );
                    onUpdateEducation(index, updated);
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
                        final updated = Education(
                          degree: education.degree,
                          institution: education.institution,
                          startDate: education.startDate,
                          endDate: value == true ? null : DateTime.now(),
                          gpa: education.gpa,
                        );
                        onUpdateEducation(index, updated);
                      },
                    ),
                    const Text('I currently study here'),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Grade (Optional)',
                    hintText: '3.8 / 4.0, A+, First Class...',
                    prefixIcon: Icon(Icons.star),
                  ),
                  controller: TextEditingController(text: education.gpa ?? '')
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: (education.gpa ?? '').length),
                    ),
                  onChanged: (value) {
                    final updated = Education(
                      degree: education.degree,
                      institution: education.institution,
                      startDate: education.startDate,
                      endDate: education.endDate,
                      gpa: value.isEmpty ? null : value,
                    );
                    onUpdateEducation(index, updated);
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
                        final updated = Education(
                          degree: education.degree,
                          institution: education.institution,
                          startDate: date,
                          endDate: education.endDate,
                          gpa: education.gpa,
                        );
                        onUpdateEducation(index, updated);
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
                        final updated = Education(
                          degree: education.degree,
                          institution: education.institution,
                          startDate: education.startDate,
                          endDate: date,
                          gpa: education.gpa,
                        );
                        onUpdateEducation(index, updated);
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
                  final updated = Education(
                    degree: education.degree,
                    institution: education.institution,
                    startDate: date,
                    endDate: education.endDate,
                    gpa: education.gpa,
                  );
                  onUpdateEducation(index, updated);
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
