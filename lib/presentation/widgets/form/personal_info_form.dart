// File: lib/presentation/widgets/form/optimized_personal_info_form.dart

import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import 'optimized_text_field.dart';

class OptimizedPersonalInfoForm extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String summary;
  final String title;
  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneChanged;
  final Function(String) onAddressChanged;
  final Function(String) onSummaryChanged;
  final Function(String) onTitleChanged;

  const OptimizedPersonalInfoForm({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.summary,
    this.title = '',
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onAddressChanged,
    required this.onSummaryChanged,
    this.onTitleChanged = _emptyCallback,
  });

  static void _emptyCallback(String value) {}

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
                  Icons.person_outline,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            const SizedBox(height: 8),
            OptimizedTextField(
              initialValue: fullName,
              label: 'Full Name *',
              hint: 'John Doe',
              prefixIcon: Icons.person,
              onChanged: onFullNameChanged,
            ),
            const SizedBox(height: 12),
            OptimizedTextField(
              initialValue: title,
              label: 'Professional Title *',
              hint: 'Senior Flutter Developer',
              prefixIcon: Icons.title,
              onChanged: onTitleChanged,
            ),
            const SizedBox(height: 12),
            OptimizedTextField(
              initialValue: email,
              label: 'Email *',
              hint: 'john.doe@example.com',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              onChanged: onEmailChanged,
            ),
            const SizedBox(height: 12),
            OptimizedTextField(
              initialValue: phone,
              label: 'Phone *',
              hint: '+92 300 1234567',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              onChanged: onPhoneChanged,
            ),
            const SizedBox(height: 12),
            OptimizedTextField(
              initialValue: address,
              label: 'Address',
              hint: 'City, Country',
              prefixIcon: Icons.location_on,
              onChanged: onAddressChanged,
            ),
            const SizedBox(height: 12),
            OptimizedTextField(
              initialValue: summary,
              label: 'Professional Summary',
              hint: 'Write a brief summary of your professional background...',
              maxLines: 4,
              onChanged: onSummaryChanged,
            ),
          ],
        ),
      ),
    );
  }
}
