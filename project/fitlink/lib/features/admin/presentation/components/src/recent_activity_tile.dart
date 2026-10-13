import 'package:fitlink/features/admin/data/model/admin_activity_log.dart';
import 'package:flutter/material.dart';

class ActivityLogTile extends StatelessWidget {
  final ActivityLog log;

  const ActivityLogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final color = _serviceColor(log.service);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_serviceIcon(log.service), color: color, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        log.action,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(log.timestamp),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  log.details,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Tag(label: log.service, color: color),
                    _Tag(label: log.actor, color: Colors.white70),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static IconData _serviceIcon(String service) {
    switch (service.toLowerCase()) {
      case 'users':
      case 'user service':
        return Icons.people_outline;
      case 'sessions':
      case 'session service':
        return Icons.event_note_outlined;
      case 'workouts':
      case 'workout service':
        return Icons.fitness_center;
      case 'coaches':
      case 'coach service':
        return Icons.sports_outlined;
      case 'auth':
      case 'authentication':
        return Icons.lock_outline;
      default:
        return Icons.bolt_outlined;
    }
  }

  static Color _serviceColor(String service) {
    switch (service.toLowerCase()) {
      case 'users':
      case 'user service':
        return Colors.lightBlueAccent;
      case 'sessions':
      case 'session service':
        return Colors.orangeAccent;
      case 'workouts':
      case 'workout service':
        return Colors.greenAccent;
      case 'coaches':
      case 'coach service':
        return Colors.purpleAccent;
      case 'auth':
      case 'authentication':
        return Colors.tealAccent;
      default:
        return Colors.white70;
    }
  }

  static String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'Time unavailable';
    final local = timestamp.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.day}/${local.month}/${local.year}  $hour:$minute';
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
