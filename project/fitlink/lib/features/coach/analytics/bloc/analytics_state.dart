import 'package:flutter/foundation.dart';
import '../model/analytics_model.dart';

@immutable
sealed class AnalyticsState {
  const AnalyticsState();
}

final class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

final class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

final class AnalyticsSuccess extends AnalyticsState {
  const AnalyticsSuccess({required this.analyticsModel});

  final AnalyticsModel analyticsModel;
}

final class AnalyticsError extends AnalyticsState {
  const AnalyticsError(this.message);
  final String message;
}
