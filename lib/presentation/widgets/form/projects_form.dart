// File: lib/presentation/widgets/form/optimized_projects_form.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart';
import 'optimized_text_field.dart';

class OptimizedProjectsForm extends StatefulWidget {
  final List<Project> projects;
  final Function(List<Project>) onProjectsChanged;

  const OptimizedProjectsForm({
    super.key,
    required this.projects,
    required this.onProjectsChanged,
  });

  @override
  State<OptimizedProjectsForm> createState() => _OptimizedProjectsFormState();
}

class _OptimizedProjectsFormState extends State<OptimizedProjectsForm> {
  late List<Project> _localProjects;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _localProjects = List.from(widget.projects);
  }
  // File: lib/presentation/widgets/form/optimized_projects_form.dart

  @override
  void didUpdateWidget(OptimizedProjectsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projects != widget.projects) {
      _localProjects = List.from(widget.projects);
      setState(() {});
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onProjectsChanged(_localProjects);
    });
  }

  void _addProject() {
    setState(() {
      _localProjects.add(Project.empty());
    });
    _scheduleSave();
  }

  void _updateProject(int index, Project updated) {
    setState(() {
      _localProjects[index] = updated;
    });
    _scheduleSave();
  }

  void _removeProject(int index) {
    setState(() {
      _localProjects.removeAt(index);
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
                Icon(Icons.code, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Projects',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addProject,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_localProjects.isEmpty)
              _buildEmptyState(context)
            else
              ..._localProjects.asMap().entries.map((entry) {
                return _buildCard(context, entry.key, entry.value);
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
            Icon(Icons.code_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No projects added',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _addProject,
              child: const Text('Add Project'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, Project project) {
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
              project.name.isEmpty ? 'New Project' : project.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeProject(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                OptimizedTextField(
                  initialValue: project.name,
                  label: 'Project Name *',
                  hint: 'E-Commerce App',
                  prefixIcon: Icons.title,
                  onChanged: (value) {
                    _updateProject(
                      index,
                      Project(
                        name: value,
                        description: project.description,
                        technologies: project.technologies,
                        projectUrl: project.projectUrl,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: project.description,
                  label: 'Description *',
                  hint:
                      'Describe what you built, your role, and achievements...',
                  maxLines: 3,
                  onChanged: (value) {
                    _updateProject(
                      index,
                      Project(
                        name: project.name,
                        description: value,
                        technologies: project.technologies,
                        projectUrl: project.projectUrl,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: project.technologies ?? '',
                  label: 'Technologies Used (Optional)',
                  hint: 'Flutter, Firebase, Stripe API',
                  prefixIcon: Icons.code,
                  onChanged: (value) {
                    _updateProject(
                      index,
                      Project(
                        name: project.name,
                        description: project.description,
                        technologies: value.isEmpty ? null : value,
                        projectUrl: project.projectUrl,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: project.projectUrl ?? '',
                  label: 'Project URL (Optional)',
                  hint: 'https://github.com/...',
                  prefixIcon: Icons.link,
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    _updateProject(
                      index,
                      Project(
                        name: project.name,
                        description: project.description,
                        technologies: project.technologies,
                        projectUrl: value.isEmpty ? null : value,
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
