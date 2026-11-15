import 'dart:convert';

import 'package:fitlink/core/services/api_service.dart';
import 'package:fitlink/features/coach/data/model/coach_dashboard_model.dart';
import 'package:http/http.dart' as http;

class CoachService {
  CoachService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final ApiService _api = ApiService();

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${_api.baseUrl}$path').replace(queryParameters: query);

  Map<String, String> _headers(String token, {bool hasBody = false}) => {
        'Accept': 'application/json',
        if (hasBody) 'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> _request({
    required String token,
    required String method,
    required String path,
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final uri = _uri(path, query);
    final headers = _headers(token, hasBody: body != null);
    late final http.Response response;
    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _client.post(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'DELETE':
        response = await _client.delete(uri, headers: headers);
        break;
      default:
        throw ArgumentError.value(method, 'method', 'Unsupported HTTP method');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw CoachApiException(response.statusCode, 'The coach service returned an invalid response.');
    }
    final result = decoded is Map
        ? Map<String, dynamic>.from(decoded)
        : <String, dynamic>{'data': decoded};
    if (response.statusCode < 200 || response.statusCode >= 300 || result['success'] == false) {
      throw CoachApiException(
        response.statusCode,
        result['message']?.toString() ?? result['error']?.toString() ?? 'Could not complete coach request.',
      );
    }
    return result;
  }

  Future<CoachDashboardModel> getDashboard({required String token}) async {
    final response = await _request(
      token: token,
      method: 'GET',
      path: '/coach/dashboard',
    );
    if (response['data'] is! Map) {
      throw const FormatException('The coach dashboard response did not contain dashboard data.');
    }
    return CoachDashboardModel.fromJson(response);
  }

  Future<Map<String, dynamic>> getPlayers({
    required String token,
    int page = 1,
    int limit = 20,
    String? search,
    String? sport,
    bool? isActive,
  }) =>
      _request(
        token: token,
        method: 'GET',
        path: '/coach/players',
        query: {
          'page': '$page',
          'limit': '$limit',
          if (search != null && search.isNotEmpty) 'search': search,
          if (sport != null && sport.isNotEmpty) 'sport': sport,
          if (isActive != null) 'isActive': '$isActive',
        },
      );

  Future<Map<String, dynamic>> getPlayerStatistics({required String token}) =>
      _request(token: token, method: 'GET', path: '/coach/players/statistics');

  Future<Map<String, dynamic>> getSportDistribution({required String token}) =>
      _request(token: token, method: 'GET', path: '/coach/players/sports');

  Future<Map<String, dynamic>> searchPlayers({
    required String token,
    required String query,
  }) =>
      _request(
        token: token,
        method: 'GET',
        path: '/coach/players/search',
        query: {'query': query},
      );

  Future<Map<String, dynamic>> addPlayer({
    required String token,
    required String userId,
  }) =>
      _request(
        token: token,
        method: 'POST',
        path: '/coach/players',
        body: {'userId': userId},
      );

  Future<Map<String, dynamic>> removePlayer({
    required String token,
    required String playerId,
  }) =>
      _request(
        token: token,
        method: 'DELETE',
        path: '/coach/players/${Uri.encodeComponent(playerId)}',
      );

  void dispose() => _client.close();
}

class CoachApiException implements Exception {
  const CoachApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}
