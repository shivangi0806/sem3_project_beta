import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'analytics_container.dart';

class HeartRateSummary extends StatelessWidget {
  // const HeartRateSummary({super.key});
  final String averageBpm;
  final String maximumBpm;

  const HeartRateSummary({
    super.key,
    required this.averageBpm,
    required this.maximumBpm,
  });

  @override
  Widget build(BuildContext context) {
    return AnalyticsContainer(
      title: 'Heart Rate Summary',
      child: SizedBox(
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               _HeartRateMetric(
  title: 'Average',
  value: '$averageBpm BPM',
),
_HeartRateMetric(
  title: 'Maximum',
  value: '$maximumBpm BPM',
),
              ],
            ),
            const SizedBox(height: 20),
            const Expanded(
  child: Center(
    child: Text(
      'Heart rate trend data unavailable',
      style: TextStyle(color: Colors.white70),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}

class _HeartRateMetric extends StatelessWidget {
  final String title;
  final String value;

  const _HeartRateMetric({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}