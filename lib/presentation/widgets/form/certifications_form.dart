import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/certification_model.dart';
import 'date_picker_field.dart';

class CertificationsForm extends StatelessWidget {
  final List<CertificationModel> certifications;
  final VoidCallback onAdd;
  final Function(int, CertificationModel) onUpdate;
  final Function(int) onRemove;

  const CertificationsForm({
    super.key,
    required this.certifications,
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
                Icon(Icons.verified, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Certifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (certifications.isEmpty)
              _buildEmptyState(context)
            else
              ...List.generate(certifications.length, (index) {
                return _buildCard(context, index, certifications[index]);
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
            Icon(Icons.verified_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No certifications added',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onAdd,
              child: const Text('Add Certification'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, CertificationModel cert) {
    final nameController = TextEditingController(text: cert.name);
    final orgController = TextEditingController(text: cert.organization);
    final credIdController = TextEditingController(
      text: cert.credentialId ?? '',
    );
    final urlController = TextEditingController(text: cert.credentialUrl ?? '');

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
              cert.name.isEmpty ? 'New Certification' : cert.name,
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
                    labelText: 'Certification Name *',
                    hintText: 'Google Associate Android Developer',
                    prefixIcon: Icon(Icons.verified),
                  ),
                  onChanged: (value) {
                    final updated = CertificationModel(
                      id: cert.id,
                      name: value,
                      organization: cert.organization,
                      issueDate: cert.issueDate,
                      expiryDate: cert.expiryDate,
                      credentialId: cert.credentialId,
                      credentialUrl: cert.credentialUrl,
                    );
                    onUpdate(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orgController,
                  decoration: const InputDecoration(
                    labelText: 'Issuing Organization *',
                    hintText: 'Google, Microsoft, Udemy...',
                    prefixIcon: Icon(Icons.business),
                  ),
                  onChanged: (value) {
                    final updated = CertificationModel(
                      id: cert.id,
                      name: cert.name,
                      organization: value,
                      issueDate: cert.issueDate,
                      expiryDate: cert.expiryDate,
                      credentialId: cert.credentialId,
                      credentialUrl: cert.credentialUrl,
                    );
                    onUpdate(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                // ✅ Date fields with labels above
                _buildDateSection(context, cert, index),
                const SizedBox(height: 12),
                TextField(
                  controller: credIdController,
                  decoration: const InputDecoration(
                    labelText: 'Credential ID (Optional)',
                    hintText: 'ABC-123-XYZ',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  onChanged: (value) {
                    final updated = CertificationModel(
                      id: cert.id,
                      name: cert.name,
                      organization: cert.organization,
                      issueDate: cert.issueDate,
                      expiryDate: cert.expiryDate,
                      credentialId: value.isEmpty ? null : value,
                      credentialUrl: cert.credentialUrl,
                    );
                    onUpdate(index, updated);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Credential URL (Optional)',
                    hintText: 'https://...',
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    final updated = CertificationModel(
                      id: cert.id,
                      name: cert.name,
                      organization: cert.organization,
                      issueDate: cert.issueDate,
                      expiryDate: cert.expiryDate,
                      credentialId: cert.credentialId,
                      credentialUrl: value.isEmpty ? null : value,
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

  // ✅ New method for date section with labels above
  Widget _buildDateSection(
    BuildContext context,
    CertificationModel cert,
    int index,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Issue Date',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              DatePickerField(
                label: '',
                initialDate: cert.issueDate ?? DateTime.now(),
                onDateSelected: (date) {
                  final updated = CertificationModel(
                    id: cert.id,
                    name: cert.name,
                    organization: cert.organization,
                    issueDate: date,
                    expiryDate: cert.expiryDate,
                    credentialId: cert.credentialId,
                    credentialUrl: cert.credentialUrl,
                  );
                  onUpdate(index, updated);
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
                'Expiry Date',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              DatePickerField(
                label: '',
                initialDate: cert.expiryDate ?? DateTime.now(),
                onDateSelected: (date) {
                  final updated = CertificationModel(
                    id: cert.id,
                    name: cert.name,
                    organization: cert.organization,
                    issueDate: cert.issueDate,
                    expiryDate: date,
                    credentialId: cert.credentialId,
                    credentialUrl: cert.credentialUrl,
                  );
                  onUpdate(index, updated);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
