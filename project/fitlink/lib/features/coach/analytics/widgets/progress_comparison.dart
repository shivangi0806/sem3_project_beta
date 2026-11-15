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

String percentageOf(dynamic value) {
  return value == null ? '--' : '$value%';
}

final steps = progress?['steps'];
final calories = progress?['calories'];
final duration = progress?['durationSeconds'];  
    return AnalyticsContainer(
      title: 'Progress Comparison',
      child: SizedBox(
        height: 348,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
  _ProgressMetric(
    title: 'Steps',
    current: valueOf(steps?['current']),
    previous: valueOf(steps?['previous']),
    percentage: percentageOf(steps?['percentage']),
  ),
  _ProgressMetric(
    title: 'Calories',
    current: valueOf(calories?['current']),
    previous: valueOf(calories?['previous']),
    percentage: percentageOf(calories?['percentage']),
  ),
  _ProgressMetric(
    title: 'Duration',
    current: valueOf(duration?['current']),
    previous: valueOf(duration?['previous']),
    percentage: percentageOf(duration?['percentage']),
  ),
],
        ),
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String title;
  final String current;
  final String previous;
  final String percentage;

  const _ProgressMetric({
    required this.title,
    required this.current,
    required this.previous,
    required this.percentage,
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current: $current',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          Text(
            'Previous: $previous',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          Text(
            percentage,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ],
  );

  }
}