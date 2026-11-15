import 'package:flutter/material.dart';

import 'analytics_container.dart';

class TrainingInsights extends StatelessWidget {
  const TrainingInsights({super.key, required this.duration, required this.consistency});

  final Map<String, dynamic>? duration;
  final Map<String, dynamic>? consistency;

  String _value(dynamic value, {String suffix = ''}) => value == null ? '—' : '$value$suffix';

  @override
  Widget build(BuildContext context) => AnalyticsContainer(
        title: 'Training consistency',
        icon: Icons.event_available_rounded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InsightRow(label: 'Active days', value: _value(consistency?['activeDays'])),
            _InsightRow(label: 'Completed sessions', value: _value(consistency?['executionCount'] ?? duration?['executionCount'])),
            _InsightRow(label: 'Current streak', value: _value(consistency?['currentStreakDays'], suffix: ' days')),
            _InsightRow(label: 'Best streak', value: _value(consistency?['bestStreakDays'], suffix: ' days')),
            const Divider(color: Colors.white12, height: 25),
            _InsightRow(label: 'Average session', value: _duration(duration?['averageExecutionDurationSeconds'])),
            _InsightRow(label: 'Longest session', value: _duration(duration?['longestExecutionDurationSeconds'])),
            _InsightRow(label: 'Shortest session', value: _duration(duration?['shortestExecutionDurationSeconds'])),
          ],
        ),
      );

  String _duration(dynamic value) {
    if (value is! num) return '—';
    final minutes = (value / 60).round();
    if (minutes < 60) return '$minutes min';
    return '${minutes ~/ 60} hr ${minutes % 60} min';
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFFAAC0D5), fontSize: 13))),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
      );
}
