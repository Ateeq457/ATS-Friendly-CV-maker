// File: lib/presentation/widgets/form/optimized_social_links_form.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_data.dart';
import 'optimized_text_field.dart';

class OptimizedSocialLinksForm extends StatefulWidget {
  final List<SocialLinkModel> socialLinks;
  final Function(List<SocialLinkModel>) onSocialLinksChanged;

  const OptimizedSocialLinksForm({
    super.key,
    required this.socialLinks,
    required this.onSocialLinksChanged,
  });

  @override
  State<OptimizedSocialLinksForm> createState() =>
      _OptimizedSocialLinksFormState();
}

class _OptimizedSocialLinksFormState extends State<OptimizedSocialLinksForm> {
  late List<SocialLinkModel> _localSocialLinks;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _localSocialLinks = List.from(widget.socialLinks);
  }
  // File: lib/presentation/widgets/form/optimized_social_links_form.dart

  @override
  void didUpdateWidget(OptimizedSocialLinksForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.socialLinks != widget.socialLinks) {
      _localSocialLinks = List.from(widget.socialLinks);
      setState(() {});
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSocialLinksChanged(_localSocialLinks);
    });
  }

  void _addSocialLink() {
    setState(() {
      _localSocialLinks.add(SocialLinkModel.empty());
    });
    _scheduleSave();
  }

  void _updateSocialLink(int index, SocialLinkModel updated) {
    setState(() {
      _localSocialLinks[index] = updated;
    });
    _scheduleSave();
  }

  void _removeSocialLink(int index) {
    setState(() {
      _localSocialLinks.removeAt(index);
    });
    _scheduleSave();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

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
                  onPressed: _addSocialLink,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_localSocialLinks.isEmpty)
              _buildEmptyState(context)
            else
              ..._localSocialLinks.asMap().entries.map((entry) {
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
            Icon(Icons.share_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No social links added',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _addSocialLink,
              child: const Text('Add Link'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, SocialLinkModel link) {
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
              onPressed: () => _removeSocialLink(index),
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
                    final selected = value ?? '';
                    _updateSocialLink(
                      index,
                      SocialLinkModel(
                        id: link.id,
                        platform: selected,
                        url: link.url,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: link.url,
                  label: 'URL / Handle *',
                  hint: 'https://linkedin.com/in/username',
                  prefixIcon: Icons.link,
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    _updateSocialLink(
                      index,
                      SocialLinkModel(
                        id: link.id,
                        platform: link.platform,
                        url: value,
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
