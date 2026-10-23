import 'package:fitlink/features/admin/presentation/components/src/admin_dashboard_card.dart';
import 'package:flutter/material.dart';

class AdminDashboardCardsComponent extends StatelessWidget {
  const AdminDashboardCardsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        AdminDashboardCard(
          title: 'Total Users',
          value: '120',
          icon: Icons.people_alt_outlined,
        ),
        SizedBox(width: 16),
        AdminDashboardCard(
          title: 'Active Users',
          value: '32',
          icon: Icons.person_outline,
        ),
        SizedBox(width: 16),
        AdminDashboardCard(
          title: 'Total Coaches',
          value: '34',
          icon: Icons.sports_outlined,
        ),
        SizedBox(width: 16),
        AdminDashboardCard(
          title: 'Current Users',
          value: '23',
          icon: Icons.person_pin_outlined,
        ),
      ],
    );
  }
}
