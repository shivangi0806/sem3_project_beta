
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
        labelText: 'Period',
        labelStyle: const TextStyle(color: Color(0xFF9DB7D0), fontSize: 12),
        prefixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF79B8FF), size: 18),
        filled: true,
        fillColor: navyBlueMid,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withValues(alpha: .08))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF5090D3), width: 1.4)),
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
