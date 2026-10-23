import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/admin/presentation/components/src/session_detail.dart';
import 'package:flutter/material.dart';

class AdminDashboardSessionOverview extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AdminDashboardSessionOverview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: navyBlueLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Session activity at a glance',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 24),
            for (final item in data)
              SessionDetail(
                title: item['title']?.toString() ?? '',
                value: item['value']?.toString() ?? '0',
              ),
          ],
        ),
      ),
    );
  }
}
