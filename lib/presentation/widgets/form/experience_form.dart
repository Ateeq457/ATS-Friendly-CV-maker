import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart'; // ✅ Changed import

class ExperienceForm extends StatelessWidget {
  final List<Experience> experiences; // ✅ Changed from ExperienceModel
  final VoidCallback onAddExperience;
  final Function(int, Experience) onUpdateExperience; // ✅ Changed
  final Function(int) onRemoveExperience;

  const ExperienceForm({
    super.key,
    required this.experiences,
    required this.onAddExperience,
    required this.onUpdateExperience,
    required this.onRemoveExperience,
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
                Icon(Icons.work_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Work Experience',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddExperience,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (experiences.isEmpty)
              _buildEmptyState(context)
            else
              ...List.generate(experiences.length, (index) {
                return _buildExperienceCard(context, index, experiences[index]);
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
            Icon(Icons.work_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No experience added yet',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onAddExperience,
              child: const Text('Add Experience'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(
    BuildContext context,
    int index,
    Experience experience,
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
              experience.jobTitle.isEmpty
                  ? 'New Experience'
                  : experience.jobTitle,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              experience.company.isEmpty ? 'Add company' : experience.company,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => onRemoveExperience(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Job Title *',
                    hintText: 'Senior Flutter Developer',
                    prefixIcon: Icon(Icons.title),
                  ),
                  controller: TextEditingController(text: experience.jobTitle)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: experience.jobTitle.length),
                    ),
                  onChanged: (value) {
                    final updated = Experience(
                      jobTitle: value,
                      company: experience.company,
                      startDate: experience.startDate,
                      endDate: experience.endDate,
                      isCurrent: experience.isCurrent,
                      description: experience.description,
                    );
                    onUpdateExperience(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    hintText: 'Google / Microsoft / Startup',
                    prefixIcon: Icon(Icons.business),
                  ),
                  controller: TextEditingController(text: experience.company)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: experience.company.length),
                    ),
                  onChanged: (value) {
                    final updated = Experience(
                      jobTitle: experience.jobTitle,
                      company: value,
                      startDate: experience.startDate,
                      endDate: experience.endDate,
                      isCurrent: experience.isCurrent,
                      description: experience.description,
                    );
                    onUpdateExperience(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                _buildDateSection(context, experience, index),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: experience.isCurrent,
                      onChanged: (value) {
                        final updated = Experience(
                          jobTitle: experience.jobTitle,
                          company: experience.company,
                          startDate: experience.startDate,
                          endDate: null,
                          isCurrent: value ?? false,
                          description: experience.description,
                        );
                        onUpdateExperience(index, updated);
                      },
                    ),
                    const Text('I currently work here'),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    hintText:
                        'Describe your responsibilities and achievements...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  controller:
                      TextEditingController(text: experience.description)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: experience.description.length),
                        ),
                  onChanged: (value) {
                    final updated = Experience(
                      jobTitle: experience.jobTitle,
                      company: experience.company,
                      startDate: experience.startDate,
                      endDate: experience.endDate,
                      isCurrent: experience.isCurrent,
                      description: value,
                    );
                    onUpdateExperience(index, updated);
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
    Experience experience,
    int index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!experience.isCurrent)
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
                      initialDate: experience.startDate,
                      onSelected: (date) {
                        final updated = Experience(
                          jobTitle: experience.jobTitle,
                          company: experience.company,
                          startDate: date,
                          endDate: experience.endDate,
                          isCurrent: experience.isCurrent,
                          description: experience.description,
                        );
                        onUpdateExperience(index, updated);
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
                      initialDate: experience.endDate ?? DateTime.now(),
                      onSelected: (date) {
                        final updated = Experience(
                          jobTitle: experience.jobTitle,
                          company: experience.company,
                          startDate: experience.startDate,
                          endDate: date,
                          isCurrent: false,
                          description: experience.description,
                        );
                        onUpdateExperience(index, updated);
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
                initialDate: experience.startDate,
                onSelected: (date) {
                  final updated = Experience(
                    jobTitle: experience.jobTitle,
                    company: experience.company,
                    startDate: date,
                    endDate: experience.endDate,
                    isCurrent: experience.isCurrent,
                    description: experience.description,
                  );
                  onUpdateExperience(index, updated);
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
