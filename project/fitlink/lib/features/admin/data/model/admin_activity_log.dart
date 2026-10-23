class ActivityLog {
  final String id;
  final String service;
  final String action;
  final String actor;
  final String details;
  final DateTime? timestamp;

  const ActivityLog({
    this.id = '',
    required this.service,
    required this.action,
    required this.actor,
    required this.details,
    required this.timestamp,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    final actorValue = _first(json, const [
      'actor', 'performedBy', 'user', 'userName', 'username', 'email',
    ]);
    final service = _text(_first(json, const [
      'service', 'serviceName', 'module', 'source', 'resource', 'entity', 'category',
    ]));
    final action = _text(_first(json, const [
      'action', 'actionType', 'event', 'activity', 'operation', 'type',
    ]));
    final details = _text(_first(json, const [
          'details', 'description', 'message', 'target', 'resourceName',
          'targetName', 'targetId', 'resourceId',
        ]))
        .trim();

    return ActivityLog(
      id: _text(_first(json, const ['id', '_id', 'logId'])),
      service: service.isEmpty ? 'Admin' : service,
      action: action.isEmpty ? 'Activity recorded' : action,
      actor: _text(actorValue).isEmpty ? 'System' : _text(actorValue),
      details: details.isEmpty ? 'No additional details.' : details,
      timestamp: _date(_first(json, const [
        'timestamp', 'createdAt', 'date', 'time', 'performedAt',
      ])),
    );
  }

  static dynamic _first(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) return value;
    }
    return null;
  }

  static String _text(dynamic value) {
    if (value == null) return '';
    if (value is Map) {
      for (final key in const ['name', 'username', 'email', 'userId', 'id', '_id', 'title']) {
        final nested = value[key];
        if (nested != null && nested.toString().trim().isNotEmpty) {
          return nested.toString();
        }
      }
      return '';
    }
    if (value is List) return value.map(_text).where((item) => item.isNotEmpty).join(', ');
    return value.toString();
  }

  static DateTime? _date(dynamic value) {
    if (value is DateTime) return value;
    if (value is num) {
      final milliseconds = value > 1000000000000 ? value.toInt() : (value * 1000).toInt();
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
