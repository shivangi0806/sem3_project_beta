import 'dart:convert';

import 'package:fitlink/core/services/api_service.dart';
import 'package:http/http.dart' as http;

/// Session API adapter. It returns decoded JSON maps/lists; feature model
/// parsing stays in SessionCubit, matching the project data flow.
class SessionService {
  SessionService({required this.token, http.Client? client})
    : _client = client ?? http.Client();

  final String token;
  final http.Client _client;
  final ApiService _api = ApiService();

  void dispose() => _client.close();

  Uri _uri(String path, [Map<String, String>? query]) => Uri.parse(
    '${_api.baseUrl}$path',
  ).replace(queryParameters: query);

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token.isNotEmpty) 'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final uri = _uri(path, query);
    late http.Response response;
    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: _headers);
        break;
      case 'POST':
        response = await _client.post(
          uri,
          headers: _headers,
          body: jsonEncode(body ?? const <String, dynamic>{}),
        );
        break;
      case 'PATCH':
        response = await _client.patch(
          uri,
          headers: _headers,
          body: jsonEncode(body ?? const <String, dynamic>{}),
        );
        break;
      default:
        throw ArgumentError.value(method, 'method', 'Unsupported HTTP method');
    }

    final decoded = jsonDecode(response.body);
    final result = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'data': decoded};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = result['message']?.toString() ?? 'Request failed';
      throw SessionApiException(response.statusCode, message);
    }
    return result;
  }

  Future<Map<String, dynamic>> getSessions({int page = 1, int limit = 100}) =>
      _send('GET', '/sessions', query: {'page': '$page', 'limit': '$limit'});

  Future<Map<String, dynamic>> getPlayerSessions({int page = 1, int limit = 100}) =>
      _send('GET', '/player/sessions', query: {'page': '$page', 'limit': '$limit'});

  Future<Map<String, dynamic>> getCoachPlayers({int page = 1, int limit = 100}) =>
      _send('GET', '/coach/players', query: {'page': '$page', 'limit': '$limit'});

  Future<Map<String, dynamic>> getWorkouts({int page = 1, int limit = 100}) =>
      _send('GET', '/workouts', query: {'page': '$page', 'limit': '$limit'});

  Future<Map<String, dynamic>> getExercises() => _send('GET', '/exercises');

  Future<Map<String, dynamic>> createWorkout(Map<String, dynamic> payload) =>
      _send('POST', '/workouts', body: payload);

  Future<Map<String, dynamic>> createDraftSession(
    Map<String, dynamic> payload,
  ) => _send('POST', '/sessions', body: payload);

  Future<Map<String, dynamic>> updateSession(
    String sessionId,
    Map<String, dynamic> payload,
  ) => _send('PATCH', '/sessions/${Uri.encodeComponent(sessionId)}', body: payload);

  Future<Map<String, dynamic>> publishSession(String sessionId) =>
      _send('POST', '/sessions/${Uri.encodeComponent(sessionId)}/publish');

  Future<Map<String, dynamic>> cancelSession(String sessionId) =>
      _send('POST', '/sessions/${Uri.encodeComponent(sessionId)}/cancel');

  Future<Map<String, dynamic>> joinSession(String sessionId) =>
      _send('POST', '/sessions/${Uri.encodeComponent(sessionId)}/join');

  Future<Map<String, dynamic>> declineSession(String sessionId) =>
      _send('POST', '/sessions/${Uri.encodeComponent(sessionId)}/decline');

  Future<Map<String, dynamic>> setPlanSyncStatus(
    String sessionId,
    String syncStatus,
  ) => _send(
    'PATCH',
    '/sessions/${Uri.encodeComponent(sessionId)}/sync-status',
    body: {'syncStatus': syncStatus},
  );

  Future<Map<String, dynamic>> startWorkout(
    String sessionId,
    String workoutId,
  ) => _send(
    'POST',
    '/sessions/${Uri.encodeComponent(sessionId)}/workouts/${Uri.encodeComponent(workoutId)}/start',
  );

  Future<Map<String, dynamic>> updateExecution(
    String executionId,
    String action, {
    int? actualDurationSeconds,
  }) => _send(
    'POST',
    '/executions/${Uri.encodeComponent(executionId)}/$action',
    body: {
      if (actualDurationSeconds != null)
        'actualDurationSeconds': actualDurationSeconds,
    },
  );
}

class SessionApiException implements Exception {
  const SessionApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'Session API ($statusCode): $message';
}
