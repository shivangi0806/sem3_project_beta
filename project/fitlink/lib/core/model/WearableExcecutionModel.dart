class WearableExecutionModel {
  final String id;
  final String executionId;
  final String sessionId;
  final String playerId;
  final String source;
  final String batchId;
  final DateTime startedAt;
  final DateTime endedAt;
  final WearableMetrics metrics;
  final DateTime receivedAt;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WearableExecutionModel({
    required this.id,
    required this.executionId,
    required this.sessionId,
    required this.playerId,
    required this.source,
    required this.batchId,
    required this.startedAt,
    required this.endedAt,
    required this.metrics,
    required this.receivedAt,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WearableExecutionModel.fromJson(Map<String, dynamic> json) {
    return WearableExecutionModel(
      id: json['_id'] ?? '',
      executionId: json['executionId'] ?? '',
      sessionId: json['sessionId'] ?? '',
      playerId: json['playerId'] ?? '',
      source: json['source'] ?? '',
      batchId: json['batchId'] ?? '',
      startedAt: DateTime.parse(json['startedAt']),
      endedAt: DateTime.parse(json['endedAt']),
      metrics: WearableMetrics.fromJson(json['metrics'] ?? {}),
      receivedAt: DateTime.parse(json['receivedAt']),
      version: json['__v'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'executionId': executionId,
      'sessionId': sessionId,
      'playerId': playerId,
      'source': source,
      'batchId': batchId,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
      'metrics': metrics.toJson(),
      'receivedAt': receivedAt.toIso8601String(),
      '__v': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class WearableMetrics {
  final int durationSeconds;
  final int steps;
  final double calories;
  final double distanceMeters;
  final double averageHeartRateBpm;
  final double maxHeartRateBpm;

  const WearableMetrics({
    required this.durationSeconds,
    required this.steps,
    required this.calories,
    required this.distanceMeters,
    required this.averageHeartRateBpm,
    required this.maxHeartRateBpm,
  });

  factory WearableMetrics.fromJson(Map<String, dynamic> json) {
    return WearableMetrics(
      durationSeconds: (json['durationSeconds'] ?? 0).toInt(),
      steps: (json['steps'] ?? 0).toInt(),
      calories: (json['calories'] ?? 0).toDouble(),
      distanceMeters: (json['distanceMeters'] ?? 0).toDouble(),
      averageHeartRateBpm: (json['averageHeartRateBpm'] ?? 0).toDouble(),
      maxHeartRateBpm: (json['maxHeartRateBpm'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'durationSeconds': durationSeconds,
      'steps': steps,
      'calories': calories,
      'distanceMeters': distanceMeters,
      'averageHeartRateBpm': averageHeartRateBpm,
      'maxHeartRateBpm': maxHeartRateBpm,
    };
  }
}
