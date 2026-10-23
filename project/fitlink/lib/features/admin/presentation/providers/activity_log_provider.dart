import 'package:fitlink/features/admin/data/model/admin_activity_log.dart';
import 'package:flutter/foundation.dart';

class ActivityLogStore extends ChangeNotifier {
  ActivityLogStore._();

  static final ActivityLogStore instance = ActivityLogStore._();

  final List<ActivityLog> _logs = [];

  List<ActivityLog> get logs => List.unmodifiable(_logs);

  void record({
    required String service,
    required String action,
    required String actor,
    required String details,
    DateTime? timestamp,
  }) {
    _logs.insert(
      0,
      ActivityLog(
        service: service,
        action: action,
        actor: actor,
        details: details,
        timestamp: timestamp ?? DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void clear() {
    _logs.clear();
    notifyListeners();
  }
}
