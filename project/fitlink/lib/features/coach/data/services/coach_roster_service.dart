import 'dart:convert';

import 'package:fitlink/core/services/api_service.dart';
import 'package:http/http.dart' as http;

class CoachRosterService {
  CoachRosterService({required this.token, http.Client? client})
    : _client = client ?? http.Client();

  final String token;
  final http.Client _client;
  final ApiService _api = ApiService();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> _decode(http.Response response) async {
    final body = jsonDecode(response.body);
    final result = body is Map<String, dynamic>
        ? body
        : <String, dynamic>{'data': body};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CoachRosterApiException(
        response.statusCode,
        result['message']?.toString() ?? 'Could not complete roster request',
      );
    }
    return result;
  }

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${_api.baseUrl}$path').replace(queryParameters: query);

  Future<Map<String, dynamic>> getRoster() async => _decode(
    await _client.get(_uri('/coach/players', {'limit': '100'}), headers: _headers),
  );

  Future<Map<String, dynamic>> searchPlayers(String query) async => _decode(
    await _client.get(
      _uri('/coach/players/search', {'query': query}),
      headers: _headers,
    ),
  );

  Future<Map<String, dynamic>> addPlayer(String userId) async => _decode(
    await _client.post(
      _uri('/coach/players'),
      headers: _headers,
      body: jsonEncode({'userId': userId}),
    ),
  );

  Future<Map<String, dynamic>> removePlayer(String playerId) async => _decode(
    await _client.delete(
      _uri('/coach/players/${Uri.encodeComponent(playerId)}'),
      headers: _headers,
    ),
  );

  void dispose() => _client.close();
}

class CoachRosterApiException implements Exception {
  const CoachRosterApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;
  @override
  String toString() => message;
}
