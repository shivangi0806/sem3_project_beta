import 'dart:convert';

import 'package:fitlink/core/model/user.dart';
import 'package:http/http.dart' as http;

/// Read-only calls for the user endpoints documented by Swagger.
class UserService {
  UserService({
    required this.token,
    http.Client? client,
    this.baseUrl = 'http://localhost:5000/api',
  }) : _client = client ?? http.Client();

  final String token;
  final String baseUrl;
  final http.Client _client;

  String get _usersUrl => '$baseUrl/users';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// GET /api/users
  Future<List<User>> getUsers() async {
    final response = await _client.get(
      Uri.parse(_usersUrl),
      headers: _headers,
    );
    final data = _decodeResponse(response)['data'];

    if (data is! List) {
      throw const FormatException('Expected a list of users in the response.');
    }

    return data
        .map((item) => User.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList(growable: false);
  }

  /// GET /api/users/:userId
  Future<User> getUserById(String userId) async {
    final response = await _client.get(
      Uri.parse('$_usersUrl/${Uri.encodeComponent(userId)}'),
      headers: _headers,
    );
    final data = _decodeResponse(response)['data'];

    if (data is! Map) {
      throw const FormatException('Expected a user object in the response.');
    }

    return User.fromJson(Map<String, dynamic>.from(data));
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception('Invalid server response (HTTP ${response.statusCode}).');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map
          ? decoded['message'] ?? decoded['error']
          : null;
      throw Exception(
        message?.toString() ?? 'Request failed (HTTP ${response.statusCode}).',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected server response format.');
    }
    if (decoded['success'] == false) {
      throw Exception(
        (decoded['message'] ?? decoded['error'] ?? 'Request failed').toString(),
      );
    }

    return decoded;
  }

  void close() => _client.close();
}
