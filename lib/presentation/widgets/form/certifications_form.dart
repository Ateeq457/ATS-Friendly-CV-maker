// File: lib/presentation/widgets/form/optimized_certifications_form.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import 'date_picker_field.dart';
import '../../../data/models/cv_data.dart';
import 'optimized_text_field.dart';

class OptimizedCertificationsForm extends StatefulWidget {
  final List<Certification> certifications;
  final Function(List<Certification>) onCertificationsChanged;

  const OptimizedCertificationsForm({
    super.key,
    required this.certifications,
    required this.onCertificationsChanged,
  });

  @override
  State<OptimizedCertificationsForm> createState() =>
      _OptimizedCertificationsFormState();
}

class _OptimizedCertificationsFormState
    extends State<OptimizedCertificationsForm> {
  late List<Certification> _localCertifications;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _localCertifications = List.from(widget.certifications);
  }

  // ✅ ADD THIS METHOD - React to parent data changes
  @override
  void didUpdateWidget(OptimizedCertificationsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.certifications != widget.certifications) {
      _localCertifications = List.from(widget.certifications);
      setState(() {});
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onCertificationsChanged(_localCertifications);
    });
  }

  void _addCertification() {
    setState(() {
      _localCertifications.add(Certification.empty());
    });
    _scheduleSave();
  }

  void _updateCertification(int index, Certification updated) {
    setState(() {
      _localCertifications[index] = updated;
    });
    _scheduleSave();
  }

  void _removeCertification(int index) {
    setState(() {
      _localCertifications.removeAt(index);
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
                  onPressed: _addCertification,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_localCertifications.isEmpty)
              _buildEmptyState(context)
            else
              ..._localCertifications.asMap().entries.map((entry) {
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
            Icon(Icons.verified_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No certifications added',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _addCertification,
              child: const Text('Add Certification'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, Certification cert) {
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
              onPressed: () => _removeCertification(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                OptimizedTextField(
                  initialValue: cert.name,
                  label: 'Certification Name *',
                  hint: 'Google Associate Android Developer',
                  prefixIcon: Icons.verified,
                  onChanged: (value) {
                    _updateCertification(
                      index,
                      Certification(
                        name: value,
                        issuer: cert.issuer,
                        issueDate: cert.issueDate,
                        expiryDate: cert.expiryDate,
                        credentialId: cert.credentialId,
                        credentialUrl: cert.credentialUrl,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: cert.issuer,
                  label: 'Issuing Organization *',
                  hint: 'Google, Microsoft, Udemy...',
                  prefixIcon: Icons.business,
                  onChanged: (value) {
                    _updateCertification(
                      index,
                      Certification(
                        name: cert.name,
                        issuer: value,
                        issueDate: cert.issueDate,
                        expiryDate: cert.expiryDate,
                        credentialId: cert.credentialId,
                        credentialUrl: cert.credentialUrl,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDateSection(context, cert, index),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: cert.credentialId ?? '',
                  label: 'Credential ID (Optional)',
                  hint: 'ABC-123-XYZ',
                  prefixIcon: Icons.badge,
                  onChanged: (value) {
                    _updateCertification(
                      index,
                      Certification(
                        name: cert.name,
                        issuer: cert.issuer,
                        issueDate: cert.issueDate,
                        expiryDate: cert.expiryDate,
                        credentialId: value.isEmpty ? null : value,
                        credentialUrl: cert.credentialUrl,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                OptimizedTextField(
                  initialValue: cert.credentialUrl ?? '',
                  label: 'Credential URL (Optional)',
                  hint: 'https://...',
                  prefixIcon: Icons.link,
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    _updateCertification(
                      index,
                      Certification(
                        name: cert.name,
                        issuer: cert.issuer,
                        issueDate: cert.issueDate,
                        expiryDate: cert.expiryDate,
                        credentialId: cert.credentialId,
                        credentialUrl: value.isEmpty ? null : value,
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

  Widget _buildDateSection(
    BuildContext context,
    Certification cert,
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
                  _updateCertification(
                    index,
                    Certification(
                      name: cert.name,
                      issuer: cert.issuer,
                      issueDate: date,
                      expiryDate: cert.expiryDate,
                      credentialId: cert.credentialId,
                      credentialUrl: cert.credentialUrl,
                    ),
                  );
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
                  _updateCertification(
                    index,
                    Certification(
                      name: cert.name,
                      issuer: cert.issuer,
                      issueDate: cert.issueDate,
                      expiryDate: date,
                      credentialId: cert.credentialId,
                      credentialUrl: cert.credentialUrl,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
