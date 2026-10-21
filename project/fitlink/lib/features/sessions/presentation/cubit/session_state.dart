import 'package:fitlink/features/sessions/data/models/session_models.dart';

sealed class SessionState {
  const SessionState();
}

final class SessionInitial extends SessionState {
  const SessionInitial();
}

final class SessionLoading extends SessionState {
  const SessionLoading();
}

final class SessionLoadFailure extends SessionState {
  const SessionLoadFailure(this.message);
  final String message;
}

final class SessionLoaded extends SessionState {
  const SessionLoaded({
    required this.sessions,
    required this.players,
    required this.workouts,
    required this.exercises,
    this.isPlayerMode = false,
    this.actionInProgress = false,
    this.actionError,
    this.executions = const {},
  });

  final List<TrainingSessionModel> sessions;
  final List<SessionPlayerModel> players;
  final List<WorkoutTemplateModel> workouts;
  final List<ExerciseCatalogModel> exercises;
  final bool isPlayerMode;
  final bool actionInProgress;
  final String? actionError;
  final Map<String, WorkoutExecutionModel> executions;

  SessionLoaded copyWith({
    List<TrainingSessionModel>? sessions,
    List<SessionPlayerModel>? players,
    List<WorkoutTemplateModel>? workouts,
    List<ExerciseCatalogModel>? exercises,
    bool? isPlayerMode,
    bool? actionInProgress,
    String? actionError,
    Map<String, WorkoutExecutionModel>? executions,
    bool clearActionError = false,
  }) =>
      SessionLoaded(
        sessions: sessions ?? this.sessions,
        players: players ?? this.players,
        workouts: workouts ?? this.workouts,
        exercises: exercises ?? this.exercises,
        isPlayerMode: isPlayerMode ?? this.isPlayerMode,
        actionInProgress: actionInProgress ?? this.actionInProgress,
        actionError: clearActionError ? null : actionError ?? this.actionError,
        executions: executions ?? this.executions,
      );
}
