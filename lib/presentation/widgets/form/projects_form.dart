import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart'; // ✅ Changed import

class ProjectsForm extends StatelessWidget {
  final List<Project> projects; // ✅ Changed from ProjectModel
  final VoidCallback onAdd;
  final Function(int, Project) onUpdate; // ✅ Changed
  final Function(int) onRemove;

  const ProjectsForm({
    super.key,
    required this.projects,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
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
                Icon(Icons.code, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Projects',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (projects.isEmpty)
              _buildEmptyState(context)
            else
              ...List.generate(projects.length, (index) {
                return _buildCard(context, index, projects[index]);
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
            TextButton(onPressed: onAdd, child: const Text('Add Project')),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, Project project) {
    final nameController = TextEditingController(text: project.name);
    final descController = TextEditingController(text: project.description);
    final techController = TextEditingController(
      text: project.technologies ?? '',
    );
    final urlController = TextEditingController(text: project.projectUrl ?? '');

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
              onPressed: () => onRemove(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name *',
                    hintText: 'E-Commerce App',
                    prefixIcon: Icon(Icons.title),
                  ),
                  onChanged: (value) {
                    final updated = Project(
                      name: value,
                      description: project.description,
                      technologies: project.technologies,
                      projectUrl: project.projectUrl,
                    );
                    onUpdate(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    hintText:
                        'Describe what you built, your role, and achievements...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    final updated = Project(
                      name: project.name,
                      description: value,
                      technologies: project.technologies,
                      projectUrl: project.projectUrl,
                    );
                    onUpdate(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: techController,
                  decoration: const InputDecoration(
                    labelText: 'Technologies Used (Optional)',
                    hintText: 'Flutter, Firebase, Stripe API',
                    prefixIcon: Icon(Icons.code),
                  ),
                  onChanged: (value) {
                    final updated = Project(
                      name: project.name,
                      description: project.description,
                      technologies: value.isEmpty ? null : value,
                      projectUrl: project.projectUrl,
                    );
                    onUpdate(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Project URL (Optional)',
                    hintText: 'https://github.com/...',
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    final updated = Project(
                      name: project.name,
                      description: project.description,
                      technologies: project.technologies,
                      projectUrl: value.isEmpty ? null : value,
                    );
                    onUpdate(index, updated);
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
