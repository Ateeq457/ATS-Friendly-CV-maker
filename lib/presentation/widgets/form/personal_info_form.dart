import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';

class PersonalInfoForm extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String summary;
  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneChanged;
  final Function(String) onAddressChanged;
  final Function(String) onSummaryChanged;

  const PersonalInfoForm({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.summary,
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onAddressChanged,
    required this.onSummaryChanged,
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
            TextField(
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                hintText: 'John Doe',
                prefixIcon: Icon(Icons.person),
              ),
              controller: TextEditingController(text: fullName)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: fullName.length),
                ),
              onChanged: onFullNameChanged,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email *',
                hintText: 'john.doe@example.com',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: TextEditingController(text: email)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: email.length),
                ),
              onChanged: onEmailChanged,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Phone *',
                hintText: '+92 300 1234567',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              controller: TextEditingController(text: phone)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: phone.length),
                ),
              onChanged: onPhoneChanged,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'City, Country',
                prefixIcon: Icon(Icons.location_on),
              ),
              controller: TextEditingController(text: address)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: address.length),
                ),
              onChanged: onAddressChanged,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Professional Summary',
                hintText:
                    'Write a brief summary of your professional background...',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              controller: TextEditingController(text: summary)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: summary.length),
                ),
              onChanged: onSummaryChanged,
            ),
          ],
        ),
      ),
    );
  }
}
