  import 'package:flutter/material.dart';

  import 'analytics_container.dart';
  import 'performance_overview.dart';
  import 'activity_trends.dart';
  import 'heart_rate_summary.dart';
  import 'progress_comparison.dart';
  class AnalyticsDashboardGrid extends StatelessWidget {
    // const AnalyticsDashboardGrid({super.key});
    final Map<String, dynamic>? analyticsReport;

    const AnalyticsDashboardGrid({
      super.key,
      required this.analyticsReport,
    });

    @override
    Widget build(BuildContext context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final panelWidth = (constraints.maxWidth - 12) / 2;

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: panelWidth,
                height: 420,
                child: PerformanceOverview(
    totalSteps: analyticsReport?['overview']?['totalSteps']?.toString() ?? '--',
    distance: analyticsReport?['overview']?['totalDistanceMeters']?.toString() ?? '--',
    calories: analyticsReport?['overview']?['totalCalories']?.toString() ?? '--',
    duration: analyticsReport?['overview']?['totalDurationSeconds']?.toString() ?? '--',
  ),
                // child: const PerformanceOverview(
                //   totalSteps: '--',
                //   distance: '--',
                //   calories: '--',
                //   duration: '--',
                // ),
              ),

              // SizedBox(
              //   width: panelWidth,
              //   height: 320,
              //   child: const AnalyticsContainer(
              //     title: 'Activity Trends',
              //     child: Center(
              //       child: Text(
              //         'Activity chart will appear here',
              //         style: TextStyle(color: Colors.white70),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
    width: panelWidth,
    height: 420,
    child:  ActivityTrends(trends: analyticsReport?['activity']?['trends'] ?? [],),
  ),

              // SizedBox(
              //   width: panelWidth,
              //   height: 320,
              //   child: const AnalyticsContainer(
              //     title: 'Heart Rate Summary',
              //     child: Center(
              //       child: Text(
              //         'Heart rate chart will appear here',
              //         style: TextStyle(color: Colors.white70),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
    width: panelWidth,
    height: 420,
    child: HeartRateSummary(
  averageBpm: analyticsReport?['heartRate']?['durationWeightedAverageBpm']?.toString() ?? '--',
  maximumBpm: analyticsReport?['heartRate']?['highestRecordedBatchMaximumBpm']?.toString() ?? '--',
),
  ),
  
              // SizedBox(
              //   width: panelWidth,
              //   height: 320,
              //   child: const AnalyticsContainer(
              //     title: 'Progress Comparison',
              //     child: Center(
              //       child: Text(
              //         'Progress chart will appear here',
              //         style: TextStyle(color: Colors.white70),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
    width: panelWidth,
    height: 420,
    child:  ProgressComparison(
       progress: analyticsReport?['progress'],
    ),
  ),
            ],
          );
        },
      );
    }
  }