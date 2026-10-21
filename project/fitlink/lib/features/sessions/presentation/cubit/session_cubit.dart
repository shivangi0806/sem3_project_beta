import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitlink/features/sessions/data/models/session_models.dart';
import 'package:fitlink/features/sessions/data/services/session_service.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._service) : super(const SessionInitial());

  final SessionService _service;
  final Map<String, WorkoutExecutionModel> _executionCache = {};

  Future<void> load({bool playerMode = false}) async {
    emit(const SessionLoading());
    try {
      emit(await _fetchData(playerMode: playerMode));
    } catch (error) {
      emit(SessionLoadFailure(_message(error)));
    }
  }

  Future<WorkoutTemplateModel?> createWorkout({
    required String name,
    required int exerciseTypeId,
    String? description,
    int? sets,
    int? reps,
    int? durationSeconds,
  }) async {
    final current = state;
    if (current is! SessionLoaded) return null;
    emit(current.copyWith(actionInProgress: true, clearActionError: true));
    try {
      final result = await _service.createWorkout({
        'name': name.trim(),
        'exerciseTypeId': exerciseTypeId,
        if (description?.trim().isNotEmpty ?? false)
          'description': description!.trim(),
        if (sets != null) 'sets': sets,
        if (reps != null) 'reps': reps,
        if (durationSeconds != null) 'durationSeconds': durationSeconds,
      });
      final workout = WorkoutTemplateModel.fromJson(_object(result['data']));
      final latest = state;
      if (latest is SessionLoaded) {
        emit(latest.copyWith(
          workouts: [workout, ...latest.workouts],
          actionInProgress: false,
        ));
      }
      return workout;
    } catch (error) {
      _setActionError(error);
      return null;
    }
  }

  Future<bool> createAndPublishSession({
    required String name,
    String? description,
    required List<String> playerIds,
    required List<String> workoutIds,
  }) async {
    if (playerIds.isEmpty || workoutIds.isEmpty) {
      _setActionError(
        StateError('Choose at least one player and one workout.'),
      );
      return false;
    }
    final current = state;
    if (current is! SessionLoaded) return false;
    emit(current.copyWith(actionInProgress: true, clearActionError: true));
    try {
      final draftResponse = await _service.createDraftSession({
        'name': name.trim(),
        if (description?.trim().isNotEmpty ?? false)
          'description': description!.trim(),
      });
      final draft = _object(draftResponse['data']);
      final sessionId = draft['sessionId']?.toString() ?? '';
      if (sessionId.isEmpty) {
        throw const FormatException('The API did not return a sessionId.');
      }
      final workoutPayload = workoutIds.indexed
          .map((entry) => {'workoutId': entry.$2, 'order': entry.$1 + 1})
          .toList();
      await _service.updateSession(sessionId, {
        'playerIds': playerIds,
        'workouts': workoutPayload,
      });
      await _service.publishSession(sessionId);
      emit(await _fetchData(playerMode: false));
      return true;
    } catch (error) {
      _setActionError(error);
      return false;
    }
  }

  Future<bool> publishSession(String sessionId) =>
      _changeSessionStatus(sessionId, publish: true);

  Future<bool> joinSession(String sessionId, {bool decline = false}) async {
    final current = state;
    if (current is! SessionLoaded) return false;
    emit(current.copyWith(actionInProgress: true, clearActionError: true));
    try {
      if (decline) {
        await _service.declineSession(sessionId);
      } else {
        await _service.joinSession(sessionId);
      }
      emit(await _fetchData(playerMode: true));
      return true;
    } catch (error) {
      _setActionError(error);
      return false;
    }
  }

  Future<bool> acknowledgePlanSync(String sessionId, String status) async {
    final current = state;
    if (current is! SessionLoaded) return false;
    emit(current.copyWith(actionInProgress: true, clearActionError: true));
    try {
      await _service.setPlanSyncStatus(sessionId, status);
      emit(await _fetchData(playerMode: true));
      return true;
    } catch (error) {
      _setActionError(error);
      return false;
    }
  }

  Future<bool> startWorkout(String sessionId, String workoutId) async {
    final current = state;
    if (current is! SessionLoaded) return false;
    emit(current.copyWith(actionInProgress: true, clearActionError: true));
    try {
      final result = await _service.startWorkout(sessionId, workoutId);
      final execution = WorkoutExecutionModel.fromJson(_object(result['data']));
      _executionCache['$sessionId:$workoutId'] = execution;
      _replaceCachedExecutions();
      return true;
    } catch (error) {
      _setActionError(error);
      return false;
    }
  }

  Future<bool> updateExecution(
    String sessionId,
    String workoutId,
    String action,
  ) async {
    final key = '$sessionId:$workoutId';
    final existing = _executionCache[key];
    if (existing == null) return startWorkout(sessionId, workoutId);
    final current = state;
    if (current is! SessionLoaded) return false;
    emit(current.copyWith(actionInProgress: true, clearActionError: true));
    try {
      final result = await _service.updateExecution(existing.executionId, action);
      _executionCache[key] = WorkoutExecutionModel.fromJson(_object(result['data']));
      if (action == 'complete') {
        emit(await _fetchData(playerMode: true));
      } else {
        _replaceCachedExecutions();
      }
      return true;
    } catch (error) {
      _setActionError(error);
      return false;
    }
  }

  void _replaceCachedExecutions() {
    final current = state;
    if (current is SessionLoaded) {
      emit(current.copyWith(
        executions: Map.unmodifiable(_executionCache),
        actionInProgress: false,
      ));
    }
  }

  Future<bool> cancelSession(String sessionId) =>
      _changeSessionStatus(sessionId, publish: false);

  Future<bool> _changeSessionStatus(
    String sessionId, {
    required bool publish,
  }) async {
    final current = state;
    if (current is! SessionLoaded) return false;
    emit(current.copyWith(actionInProgress: true, clearActionError: true));
    try {
      if (publish) {
        await _service.publishSession(sessionId);
      } else {
        await _service.cancelSession(sessionId);
      }
      emit(await _fetchData(playerMode: false));
      return true;
    } catch (error) {
      _setActionError(error);
      return false;
    }
  }

  Future<SessionLoaded> _fetchData({required bool playerMode}) async {
    if (playerMode) {
      final response = await _service.getPlayerSessions();
      final page = _object(response['data']);
      return SessionLoaded(
        sessions: _list(page['items'])
            .map((json) => TrainingSessionModel.fromJson(json))
            .toList(),
        players: const [],
        workouts: const [],
        exercises: const [],
        isPlayerMode: true,
        executions: Map.unmodifiable(_executionCache),
      );
    }
    final responses = await Future.wait([
      _service.getSessions(),
      _service.getCoachPlayers(),
      _service.getWorkouts(),
      _service.getExercises(),
    ]);
    final sessionPage = _object(responses[0]['data']);
    final playerPage = _object(responses[1]['data']);
    final workoutPage = _object(responses[2]['data']);
    return SessionLoaded(
      sessions: _list(sessionPage['items'])
          .map((json) => TrainingSessionModel.fromJson(json))
          .toList(),
      players: _list(playerPage['players'])
          .map((json) => SessionPlayerModel.fromJson(json))
          .toList(),
      workouts: _list(workoutPage['items'])
          .map((json) => WorkoutTemplateModel.fromJson(json))
          .toList(),
      exercises: _list(responses[3]['data'])
          .map((json) => ExerciseCatalogModel.fromJson(json))
          .toList(),
      isPlayerMode: false,
      executions: Map.unmodifiable(_executionCache),
    );
  }

  void _setActionError(Object error) {
    final current = state;
    if (current is SessionLoaded) {
      emit(current.copyWith(
        actionInProgress: false,
        actionError: _message(error),
      ));
    } else {
      emit(SessionLoadFailure(_message(error)));
    }
  }

  String _message(Object error) {
    final text = error.toString();
    return text.startsWith('Exception: ') ? text.substring(11) : text;
  }

  Map<String, dynamic> _object(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

  List<Map<String, dynamic>> _list(dynamic value) => value is List
      ? value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList()
      : <Map<String, dynamic>>[];

  @override
  Future<void> close() {
    _service.dispose();
    return super.close();
  }
}
