import 'dart:convert';

import 'package:http/http.dart' as http;

/// Raw API access for GET /api/admin/users/logs.
class AdminActivityService {
  AdminActivityService({
    required this.token,
    http.Client? client,
    this.baseUrl = 'http://localhost:5000/api',
  }) : _client = client ?? http.Client();

  final String token;
  final String baseUrl;
  final http.Client _client;

  Future<Map<String, dynamic>> getUserActionLogs({
    int limit = 50,
    int skip = 0,
  }) async {
    final uri = Uri.parse('$baseUrl/admin/users/logs').replace(
      queryParameters: {'limit': '$limit', 'skip': '$skip'},
    );
    final response = await _client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Request failed (HTTP ${response.statusCode}).');
      }
      throw const FormatException('Invalid activity logs response.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map ? decoded['message'] ?? decoded['error'] : null;
      throw Exception(message?.toString() ?? 'Request failed (HTTP ${response.statusCode}).');
    }
    if (decoded is List) return {'data': decoded};
    if (decoded is! Map) {
      throw const FormatException('Unexpected activity logs response format.');
    }
    final result = Map<String, dynamic>.from(decoded);
    if (result['success'] == false) {
      throw Exception((result['message'] ?? result['error'] ?? 'Activity logs request failed').toString());
    }
    return result;
  }

  void close() => _client.close();
}
