/// Typed representation of the analytics report returned by
/// `/api/analytics/players/:playerId/report`.
///
/// [fromJson] accepts either the full `{ success, data }` response envelope
/// or its inner `data` object.
class AnalyticsModel {
  const AnalyticsModel({
    required this.playerId,
    required this.period,
    required this.timezone,
    required this.dataQuality,
    required this.overview,
    required this.activity,
    required this.heartRate,
    required this.duration,
    required this.consistency,
    required this.progress,
    this.startDate,
    this.endDate,
    this.generatedAt,
  });

  final String playerId;
  final String period;
  final String timezone;
  final String? startDate;
  final String? endDate;
  final DateTime? generatedAt;
  final AnalyticsDataQuality dataQuality;
  final AnalyticsOverview overview;
  final AnalyticsActivity activity;
  final AnalyticsHeartRate heartRate;
  final AnalyticsDuration duration;
  final AnalyticsConsistency consistency;
  final AnalyticsProgress progress;

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    final source = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    return AnalyticsModel(
      playerId: _string(source['playerId']),
      period: _string(source['period']),
      startDate: source['startDate']?.toString(),
      endDate: source['endDate']?.toString(),
      timezone: _string(source['timezone']),
      generatedAt: _date(source['generatedAt']),
      dataQuality: AnalyticsDataQuality.fromJson(_map(source['dataQuality'])),
      overview: AnalyticsOverview.fromJson(_map(source['overview'])),
      activity: AnalyticsActivity.fromJson(_map(source['activity'])),
      heartRate: AnalyticsHeartRate.fromJson(_map(source['heartRate'])),
      duration: AnalyticsDuration.fromJson(_map(source['duration'])),
      consistency: AnalyticsConsistency.fromJson(_map(source['consistency'])),
      progress: AnalyticsProgress.fromJson(_map(source['progress'])),
    );
  }

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'period': period,
        'startDate': startDate,
        'endDate': endDate,
        'timezone': timezone,
        'generatedAt': generatedAt?.toIso8601String(),
        'dataQuality': dataQuality.toJson(),
        'overview': overview.toJson(),
        'activity': activity.toJson(),
        'heartRate': heartRate.toJson(),
        'duration': duration.toJson(),
        'consistency': consistency.toJson(),
        'progress': progress.toJson(),
      };
}

class AnalyticsDataQuality {
  const AnalyticsDataQuality({
    required this.boundaryExcludedBatches,
    required this.batchSemantics,
  });

  final int? boundaryExcludedBatches;
  final String batchSemantics;

  factory AnalyticsDataQuality.fromJson(Map<String, dynamic> json) =>
      AnalyticsDataQuality(
        boundaryExcludedBatches: _int(json['boundaryExcludedBatches']),
        batchSemantics: _string(json['batchSemantics']),
      );

  Map<String, dynamic> toJson() => {
        'boundaryExcludedBatches': boundaryExcludedBatches,
        'batchSemantics': batchSemantics,
      };
}

class AnalyticsOverview {
  const AnalyticsOverview({
    this.totalSteps,
    this.totalDistanceMeters,
    this.totalCalories,
    this.totalDurationSeconds,
    this.executionCount,
    this.activeDays,
    this.durationWeightedAverageHeartRateBpm,
    this.highestRecordedBatchMaximumHeartRateBpm,
  });

  final num? totalSteps;
  final num? totalDistanceMeters;
  final num? totalCalories;
  final num? totalDurationSeconds;
  final int? executionCount;
  final int? activeDays;
  final num? durationWeightedAverageHeartRateBpm;
  final num? highestRecordedBatchMaximumHeartRateBpm;

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) =>
      AnalyticsOverview(
        totalSteps: _num(json['totalSteps']),
        totalDistanceMeters: _num(json['totalDistanceMeters']),
        totalCalories: _num(json['totalCalories']),
        totalDurationSeconds: _num(json['totalDurationSeconds']),
        executionCount: _int(json['executionCount']),
        activeDays: _int(json['activeDays']),
        durationWeightedAverageHeartRateBpm:
            _num(json['durationWeightedAverageHeartRateBpm']),
        highestRecordedBatchMaximumHeartRateBpm:
            _num(json['highestRecordedBatchMaximumHeartRateBpm']),
      );

  Map<String, dynamic> toJson() => {
        'totalSteps': totalSteps,
        'totalDistanceMeters': totalDistanceMeters,
        'totalCalories': totalCalories,
        'totalDurationSeconds': totalDurationSeconds,
        'executionCount': executionCount,
        'activeDays': activeDays,
        'durationWeightedAverageHeartRateBpm':
            durationWeightedAverageHeartRateBpm,
        'highestRecordedBatchMaximumHeartRateBpm':
            highestRecordedBatchMaximumHeartRateBpm,
      };
}

class AnalyticsActivity {
  const AnalyticsActivity({required this.groupBy, required this.trends});

  final String groupBy;
  final List<AnalyticsTrend> trends;

  factory AnalyticsActivity.fromJson(Map<String, dynamic> json) =>
      AnalyticsActivity(
        groupBy: _string(json['groupBy']),
        trends: _list(json['trends'])
            .map((item) => AnalyticsTrend.fromJson(item))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'groupBy': groupBy,
        'trends': trends.map((trend) => trend.toJson()).toList(),
      };
}

class AnalyticsTrend {
  const AnalyticsTrend({
    required this.periodStart,
    this.totalSteps,
    this.totalDistanceMeters,
    this.totalCalories,
    this.totalDurationSeconds,
    this.executionCount,
    this.activeDays,
    this.durationWeightedAverageHeartRateBpm,
    this.highestRecordedBatchMaximumHeartRateBpm,
    this.stepsPerMinute,
    this.averageSpeedMetersPerSecond,
    this.averageSpeedKilometersPerHour,
  });

  final String periodStart;
  final num? totalSteps;
  final num? totalDistanceMeters;
  final num? totalCalories;
  final num? totalDurationSeconds;
  final int? executionCount;
  final int? activeDays;
  final num? durationWeightedAverageHeartRateBpm;
  final num? highestRecordedBatchMaximumHeartRateBpm;
  final num? stepsPerMinute;
  final num? averageSpeedMetersPerSecond;
  final num? averageSpeedKilometersPerHour;

  factory AnalyticsTrend.fromJson(Map<String, dynamic> json) => AnalyticsTrend(
        periodStart: _string(json['periodStart']),
        totalSteps: _num(json['totalSteps']),
        totalDistanceMeters: _num(json['totalDistanceMeters']),
        totalCalories: _num(json['totalCalories']),
        totalDurationSeconds: _num(json['totalDurationSeconds']),
        executionCount: _int(json['executionCount']),
        activeDays: _int(json['activeDays']),
        durationWeightedAverageHeartRateBpm:
            _num(json['durationWeightedAverageHeartRateBpm']),
        highestRecordedBatchMaximumHeartRateBpm:
            _num(json['highestRecordedBatchMaximumHeartRateBpm']),
        stepsPerMinute: _num(json['stepsPerMinute']),
        averageSpeedMetersPerSecond: _num(json['averageSpeedMetersPerSecond']),
        averageSpeedKilometersPerHour:
            _num(json['averageSpeedKilometersPerHour']),
      );

  Map<String, dynamic> toJson() => {
        'periodStart': periodStart,
        'totalSteps': totalSteps,
        'totalDistanceMeters': totalDistanceMeters,
        'totalCalories': totalCalories,
        'totalDurationSeconds': totalDurationSeconds,
        'executionCount': executionCount,
        'activeDays': activeDays,
        'durationWeightedAverageHeartRateBpm':
            durationWeightedAverageHeartRateBpm,
        'highestRecordedBatchMaximumHeartRateBpm':
            highestRecordedBatchMaximumHeartRateBpm,
        'stepsPerMinute': stepsPerMinute,
        'averageSpeedMetersPerSecond': averageSpeedMetersPerSecond,
        'averageSpeedKilometersPerHour': averageSpeedKilometersPerHour,
      };
}

class AnalyticsHeartRate {
  const AnalyticsHeartRate({
    this.durationWeightedAverageBpm,
    this.highestRecordedBatchMaximumBpm,
  });

  final num? durationWeightedAverageBpm;
  final num? highestRecordedBatchMaximumBpm;

  factory AnalyticsHeartRate.fromJson(Map<String, dynamic> json) =>
      AnalyticsHeartRate(
        durationWeightedAverageBpm:
            _num(json['durationWeightedAverageBpm']),
        highestRecordedBatchMaximumBpm:
            _num(json['highestRecordedBatchMaximumBpm']),
      );

  Map<String, dynamic> toJson() => {
        'durationWeightedAverageBpm': durationWeightedAverageBpm,
        'highestRecordedBatchMaximumBpm': highestRecordedBatchMaximumBpm,
      };
}

class AnalyticsDuration {
  const AnalyticsDuration({
    this.totalDurationSeconds,
    this.averageExecutionDurationSeconds,
    this.longestExecutionDurationSeconds,
    this.shortestExecutionDurationSeconds,
  });

  final num? totalDurationSeconds;
  final num? averageExecutionDurationSeconds;
  final num? longestExecutionDurationSeconds;
  final num? shortestExecutionDurationSeconds;

  factory AnalyticsDuration.fromJson(Map<String, dynamic> json) =>
      AnalyticsDuration(
        totalDurationSeconds: _num(json['totalDurationSeconds']),
        averageExecutionDurationSeconds:
            _num(json['averageExecutionDurationSeconds']),
        longestExecutionDurationSeconds:
            _num(json['longestExecutionDurationSeconds']),
        shortestExecutionDurationSeconds:
            _num(json['shortestExecutionDurationSeconds']),
      );

  Map<String, dynamic> toJson() => {
        'totalDurationSeconds': totalDurationSeconds,
        'averageExecutionDurationSeconds': averageExecutionDurationSeconds,
        'longestExecutionDurationSeconds': longestExecutionDurationSeconds,
        'shortestExecutionDurationSeconds': shortestExecutionDurationSeconds,
      };
}

class AnalyticsConsistency {
  const AnalyticsConsistency({
    this.activeDays,
    this.executionCount,
    this.activeWeeks,
    this.averageExecutionsPerActiveWeek,
    this.currentStreakDays,
    this.bestStreakDays,
  });

  final int? activeDays;
  final int? executionCount;
  final int? activeWeeks;
  final num? averageExecutionsPerActiveWeek;
  final int? currentStreakDays;
  final int? bestStreakDays;

  factory AnalyticsConsistency.fromJson(Map<String, dynamic> json) =>
      AnalyticsConsistency(
        activeDays: _int(json['activeDays']),
        executionCount: _int(json['executionCount']),
        activeWeeks: _int(json['activeWeeks']),
        averageExecutionsPerActiveWeek:
            _num(json['averageExecutionsPerActiveWeek']),
        currentStreakDays: _int(json['currentStreakDays']),
        bestStreakDays: _int(json['bestStreakDays']),
      );

  Map<String, dynamic> toJson() => {
        'activeDays': activeDays,
        'executionCount': executionCount,
        'activeWeeks': activeWeeks,
        'averageExecutionsPerActiveWeek': averageExecutionsPerActiveWeek,
        'currentStreakDays': currentStreakDays,
        'bestStreakDays': bestStreakDays,
      };
}

class AnalyticsProgress {
  const AnalyticsProgress({
    required this.steps,
    required this.distanceMeters,
    required this.calories,
    required this.durationSeconds,
    required this.durationWeightedAverageHeartRateBpm,
  });

  final AnalyticsProgressMetric steps;
  final AnalyticsProgressMetric distanceMeters;
  final AnalyticsProgressMetric calories;
  final AnalyticsProgressMetric durationSeconds;
  final AnalyticsProgressMetric durationWeightedAverageHeartRateBpm;

  factory AnalyticsProgress.fromJson(Map<String, dynamic> json) =>
      AnalyticsProgress(
        steps: AnalyticsProgressMetric.fromJson(_map(json['steps'])),
        distanceMeters:
            AnalyticsProgressMetric.fromJson(_map(json['distanceMeters'])),
        calories: AnalyticsProgressMetric.fromJson(_map(json['calories'])),
        durationSeconds:
            AnalyticsProgressMetric.fromJson(_map(json['durationSeconds'])),
        durationWeightedAverageHeartRateBpm:
            AnalyticsProgressMetric.fromJson(
                _map(json['durationWeightedAverageHeartRateBpm'])),
      );

  Map<String, dynamic> toJson() => {
        'steps': steps.toJson(),
        'distanceMeters': distanceMeters.toJson(),
        'calories': calories.toJson(),
        'durationSeconds': durationSeconds.toJson(),
        'durationWeightedAverageHeartRateBpm':
            durationWeightedAverageHeartRateBpm.toJson(),
      };
}

class AnalyticsProgressMetric {
  const AnalyticsProgressMetric({this.current, this.previous, this.percentage, this.status});

  final num? current;
  final num? previous;
  final num? percentage;
  final String? status;

  factory AnalyticsProgressMetric.fromJson(Map<String, dynamic> json) =>
      AnalyticsProgressMetric(
        current: _num(json['current']),
        previous: _num(json['previous']),
        percentage: _num(json['percentage']),
        status: json['status']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'current': current,
        'previous': previous,
        'percentage': percentage,
        'status': status,
      };
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

List<Map<String, dynamic>> _list(dynamic value) => value is List
    ? value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList()
    : const [];

String _string(dynamic value) => value?.toString() ?? '';

num? _num(dynamic value) => value is num ? value : num.tryParse('$value');

int? _int(dynamic value) => value is num ? value.toInt() : int.tryParse('$value');

DateTime? _date(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
