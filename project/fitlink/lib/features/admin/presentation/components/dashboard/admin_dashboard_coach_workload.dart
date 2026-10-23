import 'package:fitlink/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AdminDashboardCoachWorkload extends StatelessWidget {
  const AdminDashboardCoachWorkload({super.key});

  static const _coaches = [
    _CoachWorkload(name: 'Alex Morgan', sessions: 18, capacity: 24),
    _CoachWorkload(name: 'Jamie Lee', sessions: 14, capacity: 20),
    _CoachWorkload(name: 'Taylor Reed', sessions: 9, capacity: 18),
    _CoachWorkload(name: 'Jordan Kim', sessions: 7, capacity: 16),
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
              'Coach Workload',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sessions scheduled this week',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ..._coaches.map(
              (coach) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _CoachWorkloadRow(coach: coach),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachWorkload {
  final String name;
  final int sessions;
  final int capacity;

  const _CoachWorkload({
    required this.name,
    required this.sessions,
    required this.capacity,
  });
}

class _CoachWorkloadRow extends StatelessWidget {
  final _CoachWorkload coach;

  const _CoachWorkloadRow({required this.coach});

  @override
  Widget build(BuildContext context) {
    final progress = (coach.sessions / coach.capacity).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                coach.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${coach.sessions}/${coach.capacity}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 0.8 ? Colors.orangeAccent : Colors.lightBlueAccent,
            ),
          ),
        ),
      ],
    );
  }
}
