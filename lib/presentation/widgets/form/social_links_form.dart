import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/social_link_model.dart';

class SocialLinksForm extends StatelessWidget {
  final List<SocialLinkModel> socialLinks;
  final VoidCallback onAdd;
  final Function(int, SocialLinkModel) onUpdate;
  final Function(int) onRemove;

  SocialLinksForm({
    super.key,
    required this.socialLinks,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
  });

  final List<Map<String, dynamic>> platforms = [
    {'icon': Icons.link, 'name': 'linkedin', 'label': 'LinkedIn'},
    {'icon': Icons.code, 'name': 'github', 'label': 'GitHub'},
    {'icon': Icons.alternate_email, 'name': 'twitter', 'label': 'Twitter/X'},
    {'icon': Icons.web, 'name': 'portfolio', 'label': 'Portfolio'},
    {'icon': Icons.email, 'name': 'email', 'label': 'Email'},
    {'icon': Icons.phone, 'name': 'phone', 'label': 'Phone'},
  ];

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
                Icon(Icons.share, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Social & Contact Links',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
            if (socialLinks.isEmpty)
              _buildEmptyState(context)
            else
              ...List.generate(socialLinks.length, (index) {
                return _buildCard(context, index, socialLinks[index]);
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
            Icon(Icons.share_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No social links added',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: onAdd, child: const Text('Add Link')),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, SocialLinkModel link) {
    final urlController = TextEditingController(text: link.url);
    String selectedPlatform = link.platform;

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
              link.platform.isEmpty ? 'New Link' : link.platform,
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
                DropdownButtonFormField<String>(
                  value: selectedPlatform.isEmpty ? null : selectedPlatform,
                  decoration: const InputDecoration(
                    labelText: 'Platform *',
                    prefixIcon: Icon(Icons.apps),
                  ),
                  items: platforms.map<DropdownMenuItem<String>>((platform) {
                    return DropdownMenuItem<String>(
                      value: platform['name'] as String,
                      child: Row(
                        children: [
                          Icon(platform['icon'] as IconData, size: 18),
                          const SizedBox(width: 8),
                          Text(platform['label'] as String),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedPlatform = value ?? '';
                    final updated = SocialLinkModel(
                      id: link.id,
                      platform: selectedPlatform,
                      url: link.url,
                    );
                    onUpdate(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL / Handle *',
                    hintText: 'https://linkedin.com/in/username',
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    final updated = SocialLinkModel(
                      id: link.id,
                      platform: link.platform,
                      url: value,
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
