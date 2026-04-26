import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/custom_section_model.dart';

class CustomSectionsForm extends StatefulWidget {
  final List<CustomSectionModel> sections;
  final VoidCallback onAddSection;
  final Function(int) onRemoveSection;
  final Function(int, String) onUpdateSectionTitle;
  final Function(int) onAddEntry;
  final Function(int, int, String, String, String?) onUpdateEntry;
  final Function(int, int) onRemoveEntry;

  const CustomSectionsForm({
    super.key,
    required this.sections,
    required this.onAddSection,
    required this.onRemoveSection,
    required this.onUpdateSectionTitle,
    required this.onAddEntry,
    required this.onUpdateEntry,
    required this.onRemoveEntry,
  });

  @override
  State<CustomSectionsForm> createState() => _CustomSectionsFormState();
}

class _CustomSectionsFormState extends State<CustomSectionsForm> {
  final Map<String, TextEditingController> _controllers = {};

  TextEditingController _getController(String key, String initial) {
    if (_controllers.containsKey(key)) {
      return _controllers[key]!;
    } else {
      final controller = TextEditingController(text: initial);
      _controllers[key] = controller;
      return controller;
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
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
                  onPressed: widget.onAddSection,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),

            if (widget.sections.isEmpty)
              _buildEmptyState(context)
            else
              ...List.generate(widget.sections.length, (index) {
                return _buildSectionCard(
                  context,
                  index,
                  widget.sections[index],
                );
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
              onPressed: widget.onAddSection,
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
    final sectionKey = "section_$sectionIndex";

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
            title: TextField(
              controller: _getController("${sectionKey}_title", section.title),
              decoration: const InputDecoration(
                labelText: 'Section Title *',
                hintText: 'e.g., Awards, Publications',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontWeight: FontWeight.w600),
              onChanged: (value) =>
                  widget.onUpdateSectionTitle(sectionIndex, value),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => widget.onRemoveSection(sectionIndex),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...List.generate(section.entries.length, (entryIndex) {
                  return _buildEntryCard(
                    context,
                    sectionIndex,
                    entryIndex,
                    section.entries[entryIndex],
                  );
                }),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => widget.onAddEntry(sectionIndex),
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
    final keyBase = "s${sectionIndex}_e${entryIndex}";

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
                child: TextField(
                  controller: _getController("${keyBase}_title", entry.title),
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'Award name...',
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (value) => widget.onUpdateEntry(
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
                onPressed: () => widget.onRemoveEntry(sectionIndex, entryIndex),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _getController("${keyBase}_desc", entry.description),
            decoration: const InputDecoration(labelText: 'Description *'),
            maxLines: 2,
            onChanged: (value) => widget.onUpdateEntry(
              sectionIndex,
              entryIndex,
              entry.title,
              value,
              entry.date,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _getController("${keyBase}_date", entry.date ?? ''),
            decoration: const InputDecoration(labelText: 'Date (Optional)'),
            onChanged: (value) => widget.onUpdateEntry(
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
