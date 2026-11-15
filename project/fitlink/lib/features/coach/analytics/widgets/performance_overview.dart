import 'package:flutter/material.dart';

import 'analytics_container.dart';
import 'metric_card.dart';

class PerformanceOverview extends StatelessWidget {
  final String totalSteps;
  final String distance;
  final String calories;
  final String duration;

  const PerformanceOverview({
    super.key,
    required this.totalSteps,
    required this.distance,
    required this.calories,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AnalyticsContainer(
      title: 'Performance Overview',
      icon: Icons.insights_rounded,
      child: SizedBox(
        child: Column(children: [
          Expanded(child: Row(children: [
            Expanded(child: MetricCard(title: 'Total Steps', value: totalSteps, icon: Icons.directions_walk)),
            const SizedBox(width: 10),
            Expanded(child: MetricCard(title: 'Calories', value: calories, icon: Icons.local_fire_department, iconColor: Colors.orange)),
          ])),
          const SizedBox(height: 10),
          Expanded(child: Row(children: [
            Expanded(child: MetricCard(title: 'Distance (m)', value: distance, icon: Icons.route_rounded, iconColor: const Color(0xFF21C5C0))),
            const SizedBox(width: 10),
            Expanded(child: MetricCard(title: 'Duration (s)', value: duration, icon: Icons.timer, iconColor: Colors.green)),
          ])),
        ]),
      ),
    );
  }
}
