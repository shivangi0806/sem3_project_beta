
import 'package:flutter/material.dart';
import 'package:fitlink/core/theme/app_theme.dart';
class PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  static const List<String> periods = [
    'Today',
    'This Week',
    'This Month',
    'Custom Range',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedPeriod,
      isExpanded: true,
      dropdownColor: const Color(0xFF132F4C),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: 'Analytics Period',
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        filled: true,
        fillColor: navyBlueMid,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: periods.map((period) {
        return DropdownMenuItem<String>(
          value: period,
          child: Text(period),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
