// File: lib/presentation/widgets/form/optimized_languages_form.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart';
import 'optimized_text_field.dart';

class OptimizedLanguagesForm extends StatefulWidget {
  final List<Language> languages;
  final Function(List<Language>) onLanguagesChanged;

  const OptimizedLanguagesForm({
    super.key,
    required this.languages,
    required this.onLanguagesChanged,
  });

  @override
  State<OptimizedLanguagesForm> createState() => _OptimizedLanguagesFormState();
}

class _OptimizedLanguagesFormState extends State<OptimizedLanguagesForm> {
  late List<Language> _localLanguages;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _localLanguages = List.from(widget.languages);
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onLanguagesChanged(_localLanguages);
    });
  }

  void _addLanguage() {
    setState(() {
      _localLanguages.add(Language.empty());
    });
    _scheduleSave();
  }

  void _updateLanguage(int index, Language updated) {
    setState(() {
      _localLanguages[index] = updated;
    });
    _scheduleSave();
  }

  void _removeLanguage(int index) {
    setState(() {
      _localLanguages.removeAt(index);
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
                Icon(Icons.language, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Languages',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addLanguage,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_localLanguages.isEmpty)
              _buildEmptyState(context)
            else
              ..._localLanguages.asMap().entries.map((entry) {
                return _buildLanguageCard(context, entry.key, entry.value);
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
              onPressed: _addLanguage,
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
              onPressed: () => _removeLanguage(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                OptimizedTextField(
                  initialValue: language.name,
                  label: 'Language',
                  hint: 'English, Urdu, Arabic...',
                  prefixIcon: Icons.translate,
                  onChanged: (value) {
                    _updateLanguage(
                      index,
                      Language(
                        name: value,
                        proficiencyLevel: language.proficiencyLevel,
                      ),
                    );
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
                    _updateLanguage(
                      index,
                      Language(
                        name: language.name,
                        proficiencyLevel: value ?? '',
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
