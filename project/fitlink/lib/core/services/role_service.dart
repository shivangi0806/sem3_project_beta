import 'dart:convert';

import 'package:fitlink/core/model/role.dart';
import 'package:http/http.dart' as http;

/// Calls for the role endpoints under /api/roles.
class RoleService {
  RoleService({
    required this.token,
    http.Client? client,
    this.baseUrl = 'http://localhost:5000/api',
  }) : _client = client ?? http.Client();

  final String token;
  final String baseUrl;
  final http.Client _client;

  String get _rolesUrl => '$baseUrl/roles';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  /// GET /api/roles
  Future<List<Role>> getRoles() async {
    final response = await _client.get(Uri.parse(_rolesUrl), headers: _headers);
    final data = _decodeResponse(response)['data'];
    if (data is! List) {
      throw const FormatException('Expected a list of roles in the response.');
    }
    return data
        .map((item) => Role.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList(growable: false);
  }

  /// GET /api/roles/:roleId
  Future<Role> getRoleById(String roleId) async {
    final response = await _client.get(
      Uri.parse('$_rolesUrl/${Uri.encodeComponent(roleId)}'),
      headers: _headers,
    );
    final data = _decodeResponse(response)['data'];
    if (data is! Map) {
      throw const FormatException('Expected a role object in the response.');
    }
    return Role.fromJson(Map<String, dynamic>.from(data));
  }

  /// POST /api/roles. Privilege IDs are selected from the privileges API.
  Future<Role> createRole({
    required String roleId,
    required String roleName,
    required List<int> privilegesId,
  }) async {
    final response = await _client.post(
      Uri.parse(_rolesUrl),
      headers: _headers,
      body: jsonEncode({
        'roleId': roleId.trim(),
        'roleName': roleName.trim(),
        'privilegesId': privilegesId,
        'isSystemRole': false,
      }),
    );
    final data = _decodeResponse(response)['data'];
    if (data is! Map) {
      throw const FormatException('Expected the created role in the response.');
    }
    return Role.fromJson(Map<String, dynamic>.from(data));
  }

  /// PUT /api/roles/:roleId.
  Future<Role> updateRole({
    required String roleId,
    required String roleName,
    required List<int> privilegesId,
  }) async {
    final response = await _client.put(
      Uri.parse('$_rolesUrl/${Uri.encodeComponent(roleId)}'),
      headers: _headers,
      body: jsonEncode({
        'roleName': roleName.trim(),
        'privilegesId': privilegesId,
      }),
    );
    final data = _decodeResponse(response)['data'];
    if (data is! Map) {
      throw const FormatException('Expected the updated role in the response.');
    }
    return Role.fromJson(Map<String, dynamic>.from(data));
  }

  /// DELETE /api/roles/:roleId.
  Future<void> deleteRole(String roleId) async {
    final response = await _client.delete(
      Uri.parse('$_rolesUrl/${Uri.encodeComponent(roleId)}'),
      headers: _headers,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      dynamic decoded;
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        decoded = null;
      }
      final message = decoded is Map
          ? decoded['message'] ?? decoded['error']
          : null;
      throw Exception(
        message?.toString() ?? 'Request failed (HTTP ${response.statusCode}).',
      );
    }
    if (response.body.trim().isNotEmpty) _decodeResponse(response);
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
