class SessionWorkoutModel {
  const SessionWorkoutModel({
    required this.workoutId,
    required this.name,
    required this.exerciseType,
    required this.exerciseTypeId,
    required this.order,
    this.sets,
    this.reps,
    this.durationSeconds,
  });

  final String workoutId;
  final String name;
  final String exerciseType;
  final int exerciseTypeId;
  final int order;
  final int? sets;
  final int? reps;
  final int? durationSeconds;

  factory SessionWorkoutModel.fromJson(Map<String, dynamic> json) =>
      SessionWorkoutModel(
        workoutId: '${json['workoutId'] ?? ''}',
        name: '${json['name'] ?? 'Workout'}',
        exerciseType: '${json['exerciseType'] ?? ''}',
        exerciseTypeId: _asInt(json['exerciseTypeId']) ?? 0,
        order: _asInt(json['order']) ?? 1,
        sets: _asInt(json['sets']),
        reps: _asInt(json['reps']),
        durationSeconds: _asInt(json['durationSeconds']),
      );
}

class TrainingSessionModel {
  const TrainingSessionModel({
    required this.sessionId,
    required this.name,
    required this.status,
    required this.playerIds,
    required this.workouts,
    this.description,
    this.scheduledAt,
    this.publishedAt,
    this.participationStatus,
    this.syncStatus,
  });

  final String sessionId;
  final String name;
  final String status;
  final List<String> playerIds;
  final List<SessionWorkoutModel> workouts;
  final String? description;
  final DateTime? scheduledAt;
  final DateTime? publishedAt;
  final String? participationStatus;
  final String? syncStatus;

  factory TrainingSessionModel.fromJson(Map<String, dynamic> json) {
    final rawWorkouts = json['workouts'] as List? ?? const [];
    final rawPlayers = json['playerIds'] as List? ?? const [];
    return TrainingSessionModel(
      sessionId: '${json['sessionId'] ?? ''}',
      name: '${json['name'] ?? 'Untitled session'}',
      status: '${json['status'] ?? 'DRAFT'}',
      playerIds: rawPlayers.map((value) => value.toString()).toList(),
      workouts: rawWorkouts
          .whereType<Map>()
          .map((value) => SessionWorkoutModel.fromJson(
                Map<String, dynamic>.from(value),
              ))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order)),
      description: json['description']?.toString(),
      scheduledAt: DateTime.tryParse('${json['scheduledAt'] ?? ''}'),
      publishedAt: DateTime.tryParse('${json['publishedAt'] ?? ''}'),
      participationStatus: (json['participation'] is Map)
          ? (json['participation'] as Map)['status']?.toString()
          : json['participationStatus']?.toString(),
      syncStatus: (json['participation'] is Map)
          ? (json['participation'] as Map)['syncStatus']?.toString()
          : null,
    );
  }
}

class WorkoutTemplateModel {
  const WorkoutTemplateModel({
    required this.workoutId,
    required this.name,
    required this.exerciseType,
    required this.exerciseTypeId,
    this.description,
    this.sets,
    this.reps,
    this.durationSeconds,
  });

  final String workoutId;
  final String name;
  final String exerciseType;
  final int exerciseTypeId;
  final String? description;
  final int? sets;
  final int? reps;
  final int? durationSeconds;

  factory WorkoutTemplateModel.fromJson(Map<String, dynamic> json) =>
      WorkoutTemplateModel(
        workoutId: '${json['workoutId'] ?? ''}',
        name: '${json['name'] ?? 'Workout'}',
        exerciseType: '${json['exerciseType'] ?? ''}',
        exerciseTypeId: _asInt(json['exerciseTypeId']) ?? 0,
        description: json['description']?.toString(),
        sets: _asInt(json['sets']),
        reps: _asInt(json['reps']),
        durationSeconds: _asInt(json['durationSeconds']),
      );
}

class SessionPlayerModel {
  const SessionPlayerModel({
    required this.playerId,
    this.username,
    this.sport,
  });

  final String playerId;
  final String? username;
  final String? sport;

  factory SessionPlayerModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : const <String, dynamic>{};
    return SessionPlayerModel(
      playerId: '${json['playerId'] ?? ''}',
      username: json['username']?.toString() ??
          user['username']?.toString() ??
          json['name']?.toString(),
      sport: json['sport']?.toString(),
    );
  }
}

class ExerciseCatalogModel {
  const ExerciseCatalogModel({required this.id, required this.name});

  final int id;
  final String name;

  factory ExerciseCatalogModel.fromJson(Map<String, dynamic> json) =>
      ExerciseCatalogModel(
        id: _asInt(json['id']) ?? 0,
        name: '${json['name'] ?? ''}',
      );
}

class WorkoutExecutionModel {
  const WorkoutExecutionModel({
    required this.executionId,
    required this.sessionId,
    required this.workoutId,
    required this.status,
    required this.attempt,
  });

  final String executionId;
  final String sessionId;
  final String workoutId;
  final String status;
  final int attempt;

  factory WorkoutExecutionModel.fromJson(Map<String, dynamic> json) =>
      WorkoutExecutionModel(
        executionId: '${json['executionId'] ?? ''}',
        sessionId: '${json['sessionId'] ?? ''}',
        workoutId: '${json['workoutId'] ?? ''}',
        status: '${json['status'] ?? 'IN_PROGRESS'}',
        attempt: _asInt(json['attempt']) ?? 1,
      );
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value');
}
