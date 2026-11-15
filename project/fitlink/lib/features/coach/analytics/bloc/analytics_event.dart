import 'package:flutter/foundation.dart';

@immutable
sealed class AnalyticsEvent {
  const AnalyticsEvent();
}

final class AnalyticsReportRequested extends AnalyticsEvent {
  const AnalyticsReportRequested({
    required this.token,
    required this.playerId,
    required this.period,
    this.startDate,
    this.endDate,
    this.timezone = 'Asia/Kolkata',
    this.groupBy,
  });

  final String token;
  final String playerId;
  final String period;
  final String? startDate;
  final String? endDate;
  final String timezone;
  final String? groupBy;
}

final class AnalyticsReportCleared extends AnalyticsEvent {
  const AnalyticsReportCleared();
}
