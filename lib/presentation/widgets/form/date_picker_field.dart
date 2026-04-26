import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const DatePickerField({
    super.key,
    required this.label,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ), // ✅ Reduced padding
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Colors.grey[600],
            ), // ✅ Smaller icon
            const SizedBox(width: 4), // ✅ Reduced spacing
            Expanded(
              // ✅ Add Expanded to prevent overflow
              child: Text(
                '${initialDate.year}-${initialDate.month.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12), // ✅ Smaller font
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ), // ✅ Smaller font
            ),
          ],
        ),
      ),
    );
  }
}
