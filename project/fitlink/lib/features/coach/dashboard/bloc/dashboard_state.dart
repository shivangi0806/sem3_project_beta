import 'package:flutter/foundation.dart';
import 'package:fitlink/features/coach/data/model/coach_dashboard_model.dart';

@immutable
sealed class DashboardState {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardSuccess extends DashboardState {
  const DashboardSuccess({required this.dashboard});

  final CoachDashboardModel dashboard;
}

final class DashboardError extends DashboardState {
  const DashboardError(this.message);

  final String message;
}
