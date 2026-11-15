import 'package:flutter/material.dart';

import 'analytics_container.dart';

class ProgressComparison extends StatelessWidget {
  // const ProgressComparison({super.key});
   final Map<String, dynamic>? progress;

  const ProgressComparison({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    String valueOf(dynamic value) {
  return value?.toString() ?? '--';
}

    final metrics = progress?['metrics'] ?? progress;
    final steps = metrics?['steps'];
    final calories = metrics?['calories'];
    final duration = metrics?['durationSeconds'] ?? metrics?['duration'];
    String percentageOf(dynamic value) => value == null ? '—' : '$value%';
    return AnalyticsContainer(
      title: 'Progress Comparison',
      icon: Icons.trending_up_rounded,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
  _ProgressMetric(
    title: 'Steps',
    current: valueOf(steps?['current']),
    previous: valueOf(steps?['previous']),
    percentage: percentageOf(steps?['percentage']),
    status: steps?['status']?.toString(),
  ),
  _ProgressMetric(
    title: 'Calories',
    current: valueOf(calories?['current']),
    previous: valueOf(calories?['previous']),
    percentage: percentageOf(calories?['percentage']),
    status: calories?['status']?.toString(),
  ),
  _ProgressMetric(
    title: 'Duration',
    current: valueOf(duration?['current']),
    previous: valueOf(duration?['previous']),
    percentage: percentageOf(duration?['percentage']),
    status: duration?['status']?.toString(),
  ),
],
        ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String title;
  final String current;
  final String previous;
  final String percentage;
  final String? status;

  const _ProgressMetric({
    required this.title,
    required this.current,
    required this.previous,
    required this.percentage,
    this.status,
  });

  // @override
  // Widget build(BuildContext context) {
    // return 
    // SizedBox(
    //    height: 320,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         title,
    //         style: const TextStyle(
    //           color: Colors.white,
    //           fontSize: 15,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //       const SizedBox(height: 8),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(
    //             'Current: $current',
    //             style: const TextStyle(
    //               color: Colors.white70,
    //               fontSize: 12,
    //             ),
    //           ),
    //           Text(
    //             'Previous: $previous',
    //             style: const TextStyle(
    //               color: Colors.white70,
    //               fontSize: 12,
    //             ),
    //           ),
    //           Text(
    //             percentage,
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 12,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    @override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Wrap(spacing: 12, runSpacing: 5, crossAxisAlignment: WrapCrossAlignment.center, children: [
        Text('Now  $current', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text('Before  $previous', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(status == 'ZERO_BASELINE' ? 'New activity' : status == 'MISSING_DATA' ? 'No comparison' : percentage,
            style: TextStyle(color: status == null || status == 'AVAILABLE' ? const Color(0xFF73D6B2) : const Color(0xFFFFC66D), fontWeight: FontWeight.w700, fontSize: 12)),
      ]),
    ],
  );

  }
}
