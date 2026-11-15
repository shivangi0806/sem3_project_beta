import 'package:flutter/material.dart';

import '../model/analytics_model.dart';
import 'activity_trends.dart';
import 'heart_rate_summary.dart';
import 'performance_overview.dart';
import 'progress_comparison.dart';
import 'training_insights.dart';

class AnalyticsDashboardGrid extends StatelessWidget {
  final AnalyticsModel? analyticsReport;

  static final _sampleReport = AnalyticsModel.fromJson({
    'overview': {
      'totalSteps': 58420,
      'totalDistanceMeters': 42300,
      'totalCalories': 3120,
      'totalDurationSeconds': 10800,
    },
    'activity': {
      'trends': [
        {'totalSteps': 6200},
        {'totalSteps': 8100},
        {'totalSteps': 7400},
        {'totalSteps': 9600},
        {'totalSteps': 8800},
        {'totalSteps': 10200},
        {'totalSteps': 8120},
      ],
    },
    'heartRate': {
      'durationWeightedAverageBpm': 128,
      'highestRecordedBatchMaximumBpm': 176,
    },
    'progress': {
      'metrics': {
        'steps': {'current': 58420, 'previous': 51200, 'percentage': 14, 'status': 'AVAILABLE'},
        'calories': {'current': 3120, 'previous': 2890, 'percentage': 8, 'status': 'AVAILABLE'},
        'durationSeconds': {'current': 10800, 'previous': 9600, 'percentage': 13, 'status': 'AVAILABLE'},
      },
    },
    'duration': {
      'executionCount': 5,
      'averageExecutionDurationSeconds': 2160,
      'longestExecutionDurationSeconds': 3000,
      'shortestExecutionDurationSeconds': 1500,
    },
    'consistency': {
      'activeDays': 5,
      'executionCount': 5,
      'currentStreakDays': 3,
      'bestStreakDays': 8,
    },
  });

  const AnalyticsDashboardGrid({super.key, required this.analyticsReport});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900 ? 2 : 1;
        final gap = 16.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        final report = (analyticsReport ?? _sampleReport).toJson();
        final cards = <Widget>[
          PerformanceOverview(
            totalSteps: report?['overview']?['totalSteps']?.toString() ?? '--',
            distance: report?['overview']?['totalDistanceMeters']?.toString() ?? '--',
            calories: report?['overview']?['totalCalories']?.toString() ?? '--',
            duration: report?['overview']?['totalDurationSeconds']?.toString() ?? '--',
          ),
          ActivityTrends(trends: report?['activity']?['trends'] ?? []),
          HeartRateSummary(
            averageBpm: report?['heartRate']?['durationWeightedAverageBpm']?.toString() ?? '--',
            maximumBpm: report?['heartRate']?['highestRecordedBatchMaximumBpm']?.toString() ?? '--',
          ),
          ProgressComparison(progress: report?['progress']),
          TrainingInsights(
            duration: report?['duration'] is Map ? Map<String, dynamic>.from(report!['duration'] as Map) : null,
            consistency: report?['consistency'] is Map ? Map<String, dynamic>.from(report!['consistency'] as Map) : null,
          ),
        ];
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards.map((card) => SizedBox(width: width, height: 440, child: card)).toList(),
        );
      },
    );
  }
}
