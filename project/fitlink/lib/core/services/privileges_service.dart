import 'dart:convert';

import 'package:fitlink/core/model/privilege.dart';
import 'package:http/http.dart' as http;

class PrvielgesService {
  PrvielgesService({
    required this.token,
    http.Client? client,
    this.baseUrl = 'http://localhost:5000/api',
  }) : _client = client ?? http.Client();

  final String token;
  final String baseUrl;
  final http.Client _client;

  String get _privilegesUrl => '$baseUrl/privileges';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  /// GET /privileges
  Future<List<Privilege>> getPrivileges() async {
    final response = await _client.get(
      Uri.parse(_privilegesUrl),
      headers: _headers,
    );

    final body = _decodeResponse(response);
    final data = body['data'];

    if (data is! List) {
      throw const FormatException('Expected a list of privileges.');
    }

    return data.map((item) {
      return Privilege.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  /// GET /privileges/:privilegeId
  Future<Privilege> getPrivilege(int privilegeId) async {
    final response = await _client.get(
      Uri.parse('$_privilegesUrl/$privilegeId'),
      headers: _headers,
    );

    final body = _decodeResponse(response);
    final data = body['data'];

    if (data is! Map) {
      throw const FormatException('Expected a privilege object.');
    }

    return Privilege.fromJson(Map<String, dynamic>.from(data));
  }

  /// POST /privileges
  Future<Privilege> createPrivilege({
    required int privilegeId,
    required String privilegeName,
    String description = '',
  }) async {
    final response = await _client.post(
      Uri.parse(_privilegesUrl),
      headers: _headers,
      body: jsonEncode({
        'privilegeId': privilegeId,
        'privilegeName': privilegeName,
        'description': description,
      }),
    );

    final body = _decodeResponse(response);
    final data = body['data'];

    if (data is! Map) {
      throw const FormatException(
        'Expected the created privilege in response.',
      );
    }

    return Privilege.fromJson(Map<String, dynamic>.from(data));
  }

  /// PUT /privileges/:privilegeId
  ///
  /// The supplied privilege.routes.js does not currently define this route.
  /// Add a matching PUT route to the backend before calling this method.
  Future<Privilege> updatePrivilege({
    required int privilegeId,
    required String privilegeName,
    String description = '',
  }) async {
    final response = await _client.put(
      Uri.parse('$_privilegesUrl/$privilegeId'),
      headers: _headers,
      body: jsonEncode({
        'privilegeName': privilegeName,
        'description': description,
      }),
    );

    final body = _decodeResponse(response);
    final data = body['data'];

    if (data is! Map) {
      throw const FormatException(
        'Expected the updated privilege in response.',
      );
    }

    return Privilege.fromJson(Map<String, dynamic>.from(data));
  }

  /// DELETE /privileges/:privilegeId
  Future<void> deletePrivilege(int privilegeId) async {
    final response = await _client.delete(
      Uri.parse('$_privilegesUrl/$privilegeId'),
      headers: _headers,
    );

    _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    dynamic decoded;

    if (response.body.trim().isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw Exception(
          'Invalid server response (HTTP ${response.statusCode}).',
        );
      }
    } else {
      decoded = <String, dynamic>{};
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

  void close() {
    _client.close();
  }
}
