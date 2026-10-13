import 'package:fitlink/features/admin/data/model/admin_activity_log.dart';

abstract class AdminActivityState {}

class AdminActivityInitial extends AdminActivityState {}

class AdminActivityLoading extends AdminActivityState {}

class AdminActivityLoaded extends AdminActivityState {
  AdminActivityLoaded(
    List<ActivityLog> logs, {
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  }) : logs = List.unmodifiable(logs);

  final List<ActivityLog> logs;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;
}

class AdminActivityError extends AdminActivityState {
  AdminActivityError(this.message);
  final String message;
}
