import 'package:flutter/foundation.dart';

@immutable
sealed class DashboardEvent {
  const DashboardEvent();
}

final class DashboardRequested extends DashboardEvent {
  const DashboardRequested({required this.token});

  final String token;
}
