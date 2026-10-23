import 'package:fitlink/features/admin/presentation/components/dashboard/admin_dashboard_cards_component.dart';
import 'package:fitlink/features/admin/presentation/components/dashboard/admin_dashboard_coach_workload.dart';
import 'package:fitlink/features/admin/presentation/components/dashboard/admin_dashboard_recent_activity.dart';
import 'package:fitlink/features/admin/presentation/components/dashboard/admin_dashboard_session_overview.dart';
import 'package:fitlink/features/admin/presentation/components/dashboard/admin_dashboard_user_growth_cart.dart';
import 'package:fitlink/features/admin/presentation/components/dashboard/admin_dashboard_workout_completion.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreenComponent extends StatelessWidget {
  const AdminDashboardScreenComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: const [
                    AdminDashboardCardsComponent(),
                    SizedBox(height: 24),
                    AdminDashboardUserGrowthCart(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminDashboardSessionOverview(
                data: const [
                  {'title': 'Total Sessions', 'value': '24'},
                  {'title': 'Completed Sessions', 'value': '18'},
                ],
              ),
              const SizedBox(width: 24),
              AdminDashboardWorkoutCompletion(
                data: [
                  WorkoutCompletionData(
                    title: '75%',
                    value: '75',
                    radius: 70,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WorkoutCompletionData(
                    title: '',
                    value: '25',
                    radius: 70,
                    color: Colors.white24,
                    style: const TextStyle(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminDashboardCoachWorkload(),
              SizedBox(width: 24),
              AdminDashboardRecentActivity(),
            ],
          ),
        ],
      ),
    );
  }
}
