import 'package:fitlink/features/admin/data/model/admin_activity_log.dart';
import 'package:fitlink/features/admin/data/service/admin_activity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_activity_state.dart';

class AdminActivityCubit extends Cubit<AdminActivityState> {
  AdminActivityCubit({required String token, AdminActivityService? service})
    : _service = service ?? AdminActivityService(token: token),
      super(AdminActivityInitial());

  static const int _pageSize = 50;
  final AdminActivityService _service;
  final List<ActivityLog> _logs = [];

  Future<void> loadRecentActivity() async {
    if (_service.token.isEmpty) {
      emit(AdminActivityError('Please sign in to view recent activity.'));
      return;
    }
    emit(AdminActivityLoading());
    _logs.clear();
    try {
      final response = await _service.getUserActionLogs(limit: _pageSize);
      final rows = _extractRows(response);
      _logs.addAll(rows.map(ActivityLog.fromJson));
      emit(AdminActivityLoaded(_logs, hasMore: rows.length == _pageSize));
    } catch (error) {
      emit(AdminActivityError(_messageFrom(error)));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! AdminActivityLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }
    emit(AdminActivityLoaded(_logs, hasMore: true, isLoadingMore: true));
    try {
      final response = await _service.getUserActionLogs(
        limit: _pageSize,
        skip: _logs.length,
      );
      final rows = _extractRows(response);
      _logs.addAll(rows.map(ActivityLog.fromJson));
      emit(AdminActivityLoaded(_logs, hasMore: rows.length == _pageSize));
    } catch (error) {
      emit(AdminActivityLoaded(
        _logs,
        hasMore: true,
        loadMoreError: _messageFrom(error),
      ));
    }
  }

  List<Map<String, dynamic>> _extractRows(Map<String, dynamic> response) {
    dynamic value = response['data'] ??
        response['logs'] ??
        response['activities'] ??
        response['results'] ??
        response['items'];
    for (var depth = 0; depth < 3 && value is Map; depth++) {
      final map = Map<String, dynamic>.from(value);
      value = map['logs'] ??
          map['items'] ??
          map['results'] ??
          map['activities'] ??
          map['activityLogs'] ??
          map['userLogs'] ??
          map['data'];
    }
    if (value is! List) {
      throw const FormatException('Expected a list of activity logs in the response.');
    }
    return value.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  String _messageFrom(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  Future<void> close() {
    _service.close();
    return super.close();
  }
}
