import 'package:flutter/material.dart';

import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/coach/data/model/coach_dashboard_model.dart';

class CoachDashboardHeader extends StatelessWidget {
  const CoachDashboardHeader({super.key, required this.coach});

  final CoachProfileModel coach;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E527E), Color(0xFF153451)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: .08)),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.sports_rounded,
                  color: Color(0xFF9DCEFF), size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coach.username.isEmpty
                        ? 'Coach dashboard'
                        : 'Welcome, ${coach.username}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    coach.email.isEmpty
                        ? 'Your roster and team overview'
                        : coach.email,
                    style: const TextStyle(
                      color: Color(0xFFBDD0E2),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class CoachDashboardContent extends StatelessWidget {
  const CoachDashboardContent({super.key, required this.dashboard});

  final CoachDashboardModel dashboard;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoachDashboardHeader(coach: dashboard.coach),
          const SizedBox(height: 24),
          const _DashboardSectionHeading(
            title: 'Player overview',
            subtitle: 'Roster size and current activity',
          ),
          const SizedBox(height: 14),
          _DashboardMetricGrid(metrics: [
            _MetricData('Total players', '${dashboard.members.total}',
                'Assigned to your roster', Icons.groups_rounded),
            _MetricData('Active players', '${dashboard.members.active}',
                'Currently active', Icons.person_pin_circle_rounded,
                color: const Color(0xFF67D6AC)),
            _MetricData('Inactive players', '${dashboard.members.inactive}',
                'Currently inactive', Icons.person_off_rounded,
                color: const Color(0xFFFFC66D)),
            _MetricData('Activity rate', _percent(dashboard.members.activityRate),
                'Active share of your roster', Icons.trending_up_rounded,
                color: const Color(0xFF9DCEFF)),
          ]),
          const SizedBox(height: 24),
          const _DashboardSectionHeading(
            title: 'Training and performance',
            subtitle: 'Additional metrics will appear as the data becomes available',
          ),
          const SizedBox(height: 14),
          _DashboardMetricGrid(metrics: [
            _MetricData('Workout completion', _percentOrDash(dashboard.training.workoutCompletionRate),
                'Completion rate', Icons.check_circle_outline_rounded),
            _MetricData('Attendance', _percentOrDash(dashboard.training.attendanceRate),
                'Session attendance', Icons.event_available_rounded),
            _MetricData('Upcoming sessions', _intOrDash(dashboard.training.upcomingSessions),
                'Scheduled for your team', Icons.calendar_month_rounded),
            _MetricData('Completed sessions', _intOrDash(dashboard.training.completedSessions),
                'Completed by your team', Icons.task_alt_rounded),
            _MetricData('Players progressing', _intOrDash(dashboard.performance.membersShowingProgress),
                'Showing measurable progress', Icons.show_chart_rounded),
            _MetricData('Personal records', _intOrDash(dashboard.performance.personalRecords),
                'Team records achieved', Icons.emoji_events_outlined),
            _MetricData('Average training time', _duration(dashboard.performance.averageTrainingTime),
                'Across tracked sessions', Icons.timer_outlined),
            _MetricData('Players needing attention', _intOrDash(dashboard.attention.membersNeedingAttention),
                'May benefit from a check-in', Icons.favorite_outline_rounded,
                color: const Color(0xFFFFA68B)),
          ]),
          const SizedBox(height: 24),
          const _DashboardSectionHeading(
            title: 'Wearables',
            subtitle: 'Connected device and activity data',
          ),
          const SizedBox(height: 14),
          _DashboardMetricGrid(metrics: [
            _MetricData('Connected devices', _intOrDash(dashboard.wearable.connectedDevices),
                'Across your roster', Icons.watch_rounded),
            _MetricData('Active devices', _intOrDash(dashboard.wearable.activeDevices),
                'Currently syncing', Icons.sensors_rounded),
            _MetricData('Average steps', _numberOrDash(dashboard.wearable.averageSteps),
                'Per player', Icons.directions_walk_rounded),
            _MetricData('Average heart rate', _numberOrDash(dashboard.wearable.averageHeartRate, suffix: ' bpm'),
                'Across available readings', Icons.favorite_rounded,
                color: const Color(0xFFFF8B9A)),
            _MetricData('Sync success', _percentOrDash(dashboard.wearable.syncSuccessRate),
                'Successful device syncs', Icons.sync_rounded),
          ]),
        ],
      );

  static String _percent(num value) => '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}%';
  static String _percentOrDash(num? value) => value == null ? '—' : _percent(value);
  static String _intOrDash(int? value) => value?.toString() ?? '—';
  static String _numberOrDash(num? value, {String suffix = ''}) =>
      value == null ? '—' : '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}$suffix';
  static String _duration(num? seconds) {
    if (seconds == null) return '—';
    final minutes = (seconds / 60).round();
    if (minutes < 60) return '$minutes min';
    return '${minutes ~/ 60} hr ${minutes % 60} min';
  }
}

class _MetricData {
  const _MetricData(this.label, this.value, this.caption, this.icon,
      {this.color = const Color(0xFF79B8FF)});
  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;
}

class _DashboardMetricGrid extends StatelessWidget {
  const _DashboardMetricGrid({required this.metrics});
  final List<_MetricData> metrics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1000
              ? 4
              : constraints.maxWidth >= 640
                  ? 2
                  : 1;
          const gap = 14.0;
          final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: metrics
                .map((metric) => SizedBox(
                      width: width,
                      child: _DashboardMetricCard(metric: metric),
                    ))
                .toList(),
          );
        },
      );
}

class _DashboardMetricCard extends StatelessWidget {
  const _DashboardMetricCard({required this.metric});
  final _MetricData metric;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 142),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: navyBlueLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: .07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: metric.color.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(metric.icon, size: 20, color: metric.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(metric.label,
                    style: const TextStyle(
                        color: Color(0xFFAAC0D5),
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 14),
            Text(metric.value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.4)),
            const SizedBox(height: 4),
            Text(metric.caption,
                style: const TextStyle(color: Color(0xFF829BB4), fontSize: 11)),
          ],
        ),
      );
}

class _DashboardSectionHeading extends StatelessWidget {
  const _DashboardSectionHeading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: Color(0xFF91A9C0), fontSize: 12)),
        ],
      );
}
