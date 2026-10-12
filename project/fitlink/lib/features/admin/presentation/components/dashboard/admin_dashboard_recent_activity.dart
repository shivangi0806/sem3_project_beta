import 'package:fitlink/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AdminDashboardRecentActivity extends StatelessWidget {
  const AdminDashboardRecentActivity({super.key});

  static const _activities = [
    _Activity(
      icon: Icons.person_add_alt_1,
      title: 'New member registered',
      detail: 'Avery Wilson joined FitLink',
      time: '12 min ago',
    ),
    _Activity(
      icon: Icons.check_circle_outline,
      title: 'Workout completed',
      detail: 'Strength Fundamentals',
      time: '38 min ago',
    ),
    _Activity(
      icon: Icons.event_available_outlined,
      title: 'Session booked',
      detail: 'Personal training with Alex',
      time: '1 hr ago',
    ),
    _Activity(
      icon: Icons.star_outline,
      title: 'Coach review received',
      detail: 'Jamie Lee received a 5-star review',
      time: '3 hrs ago',
    ),
  ];

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
              'Recent Activity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Latest updates from your community',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _activities.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 20, color: Colors.white12),
                itemBuilder: (context, index) {
                  return _ActivityTile(activity: _activities[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Activity {
  final IconData icon;
  final String title;
  final String detail;
  final String time;

  const _Activity({
    required this.icon,
    required this.title,
    required this.detail,
    required this.time,
  });
}

class _ActivityTile extends StatelessWidget {
  final _Activity activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(activity.icon, color: Colors.lightBlueAccent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                activity.detail,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          activity.time,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}
