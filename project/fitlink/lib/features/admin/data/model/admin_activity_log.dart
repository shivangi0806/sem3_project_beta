class ActivityLog {
  final String service;
  final String action;
  final String actor;
  final String details;
  final DateTime timestamp;

  const ActivityLog({
    required this.service,
    required this.action,
    required this.actor,
    required this.details,
    required this.timestamp,
  });
}
