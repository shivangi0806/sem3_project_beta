import 'dart:convert';

import 'package:http/http.dart' as http;

/// Loads role definitions so the client can resolve the signed-in user's role.
/// The service deliberately returns API data; role parsing belongs in the Cubit.
class RoleCheckService {
  RoleCheckService({
    required this.token,
    http.Client? client,
    this.baseUrl = 'http://localhost:5000/api',
  }) : _client = client ?? http.Client();

  final String token;
  final String baseUrl;
  final http.Client _client;

  Future<List<Map<String, dynamic>>> getRoles() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/roles'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } on FormatException {
      throw Exception('Invalid server response (HTTP ${response.statusCode}).');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map ? body['message'] ?? body['error'] : null;
      throw Exception(message?.toString() ?? 'Role lookup failed (HTTP ${response.statusCode}).');
    }
    if (body is! Map<String, dynamic> || body['success'] == false) {
      final message = body is Map ? body['message'] ?? body['error'] : null;
      throw Exception(message?.toString() ?? 'Unexpected role response.');
    }

    final data = body['data'];
    if (data is! List) {
      throw const FormatException('Expected a list of roles in the response.');
    }
    return data
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
  }

  void close() => _client.close();
}
