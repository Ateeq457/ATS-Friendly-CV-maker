import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart'; // ✅ Changed import

class LanguagesForm extends StatelessWidget {
  final List<Language> languages; // ✅ Changed from LanguageModel
  final VoidCallback onAddLanguage;
  final Function(int, Language) onUpdateLanguage; // ✅ Changed
  final Function(int) onRemoveLanguage;

  const LanguagesForm({
    super.key,
    required this.languages,
    required this.onAddLanguage,
    required this.onUpdateLanguage,
    required this.onRemoveLanguage,
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
                Icon(Icons.language, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Languages',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddLanguage,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (languages.isEmpty)
              _buildEmptyState(context)
            else
              ...List.generate(languages.length, (index) {
                return _buildLanguageCard(context, index, languages[index]);
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
            Icon(Icons.language, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No languages added yet',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onAddLanguage,
              child: const Text('Add Language'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    int index,
    Language language,
  ) {
    final proficiencyLevels = ['Basic', 'Intermediate', 'Fluent', 'Native'];

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
              language.name.isEmpty ? 'New Language' : language.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              language.proficiencyLevel.isEmpty
                  ? 'Select level'
                  : language.proficiencyLevel,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => onRemoveLanguage(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    hintText: 'English, Urdu, Arabic...',
                    prefixIcon: Icon(Icons.translate),
                  ),
                  controller: TextEditingController(text: language.name)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: language.name.length),
                    ),
                  onChanged: (value) {
                    final updated = Language(
                      name: value,
                      proficiencyLevel: language.proficiencyLevel,
                    );
                    onUpdateLanguage(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: language.proficiencyLevel.isEmpty
                      ? null
                      : language.proficiencyLevel,
                  decoration: const InputDecoration(
                    labelText: 'Proficiency Level',
                    prefixIcon: Icon(Icons.star),
                  ),
                  items: proficiencyLevels.map((level) {
                    return DropdownMenuItem(value: level, child: Text(level));
                  }).toList(),
                  onChanged: (value) {
                    final updated = Language(
                      name: language.name,
                      proficiencyLevel: value ?? '',
                    );
                    onUpdateLanguage(index, updated);
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
