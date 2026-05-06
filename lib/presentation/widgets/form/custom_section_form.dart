// File: lib/presentation/widgets/form/optimized_custom_sections_form.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart';
import 'optimized_text_field.dart';

class OptimizedCustomSectionsForm extends StatefulWidget {
  final List<CustomSectionModel> sections;
  final Function(List<CustomSectionModel>) onSectionsChanged;

  const OptimizedCustomSectionsForm({
    super.key,
    required this.sections,
    required this.onSectionsChanged,
  });

  @override
  State<OptimizedCustomSectionsForm> createState() =>
      _OptimizedCustomSectionsFormState();
}

class _OptimizedCustomSectionsFormState
    extends State<OptimizedCustomSectionsForm> {
  late List<CustomSectionModel> _localSections;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _localSections = _deepCopySections(widget.sections);
  }

  List<CustomSectionModel> _deepCopySections(
    List<CustomSectionModel> sections,
  ) {
    return sections
        .map(
          (section) => CustomSectionModel(
            id: section.id,
            title: section.title,
            entries: section.entries
                .map(
                  (entry) => CustomSectionEntry(
                    id: entry.id,
                    title: entry.title,
                    description: entry.description,
                    date: entry.date,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }
  // File: lib/presentation/widgets/form/optimized_custom_sections_form.dart

  @override
  void didUpdateWidget(OptimizedCustomSectionsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sections != widget.sections) {
      _localSections = _deepCopySections(widget.sections);
      setState(() {});
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSectionsChanged(_localSections);
    });
  }

  void _addSection() {
    setState(() {
      _localSections.add(CustomSectionModel.empty());
    });
    _scheduleSave();
  }

  void _removeSection(int index) {
    setState(() {
      _localSections.removeAt(index);
    });
    _scheduleSave();
  }

  void _updateSectionTitle(int index, String title) {
    setState(() {
      _localSections[index].title = title;
    });
    _scheduleSave();
  }

  void _addEntry(int sectionIndex) {
    setState(() {
      _localSections[sectionIndex].entries.add(CustomSectionEntry.empty());
    });
    _scheduleSave();
  }

  void _updateEntry(
    int sectionIndex,
    int entryIndex,
    String title,
    String description,
    String? date,
  ) {
    setState(() {
      _localSections[sectionIndex].entries[entryIndex].title = title;
      _localSections[sectionIndex].entries[entryIndex].description =
          description;
      _localSections[sectionIndex].entries[entryIndex].date = date;
    });
    _scheduleSave();
  }

  void _removeEntry(int sectionIndex, int entryIndex) {
    setState(() {
      _localSections[sectionIndex].entries.removeAt(entryIndex);
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
                Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Custom Sections',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addSection,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),

            if (_localSections.isEmpty)
              _buildEmptyState(context)
            else
              ..._localSections.asMap().entries.map((entry) {
                return _buildSectionCard(context, entry.key, entry.value);
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
            Icon(Icons.add_circle_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No custom sections added',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _addSection,
              child: const Text('Add Section'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    int sectionIndex,
    CustomSectionModel section,
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
            title: OptimizedTextField(
              initialValue: section.title,
              label: 'Section Title *',
              hint: 'e.g., Awards, Publications',
              prefixIcon: Icons.title,
              onChanged: (value) => _updateSectionTitle(sectionIndex, value),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeSection(sectionIndex),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...section.entries.asMap().entries.map((entry) {
                  return _buildEntryCard(
                    context,
                    sectionIndex,
                    entry.key,
                    entry.value,
                  );
                }),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _addEntry(sectionIndex),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Entry'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    int sectionIndex,
    int entryIndex,
    CustomSectionEntry entry,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OptimizedTextField(
                  initialValue: entry.title,
                  label: 'Title *',
                  hint: 'Award name...',
                  prefixIcon: Icons.title,
                  onChanged: (value) => _updateEntry(
                    sectionIndex,
                    entryIndex,
                    value,
                    entry.description,
                    entry.date,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.red),
                onPressed: () => _removeEntry(sectionIndex, entryIndex),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OptimizedTextField(
            initialValue: entry.description,
            label: 'Description *',
            maxLines: 2,
            onChanged: (value) => _updateEntry(
              sectionIndex,
              entryIndex,
              entry.title,
              value,
              entry.date,
            ),
          ),
          const SizedBox(height: 8),
          OptimizedTextField(
            initialValue: entry.date ?? '',
            label: 'Date (Optional)',
            hint: 'e.g., 2023, Jan 2023 - Present',
            prefixIcon: Icons.calendar_today,
            onChanged: (value) => _updateEntry(
              sectionIndex,
              entryIndex,
              entry.title,
              entry.description,
              value.isEmpty ? null : value,
            ),
          ),
        ],
      ),
    );
  }
}
