import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
class ApiService {
  // For a physical Android phone, use your computer's current LAN IP.
  // For the standard Android emulator, use http://10.0.2.2:5000/api
  static const String baseUrl =
      //'http://192.168.0.101:5000/api';
        'http://192.168.1.101:5000/api';

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return _post('/auth/login', {
      'identifier': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String roleId,
  }) async {
    return _post('/auth/register', {
      'username': name,
      'email': email,
      'password': password,
      'roleId':roleId,
    });
  }

  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    final dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception(
        'The server returned an invalid response '
        '(${response.statusCode}).',
      );
    }

    if (decoded is! Map) {
      throw Exception('Unexpected response from server.');
    }

    final result = Map<String, dynamic>.from(decoded);

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        result['message']?.toString() ??
            'Request failed (${response.statusCode}).',
      );
    }

    return result;
  }
  
// Future<Map<String, dynamic>> getPlayerSessions({
//   required String accessToken,
// }) async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/player/sessions'),
//     headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $accessToken',
//     },
//   );

//   final dynamic decoded;

//   try {
//     decoded = jsonDecode(response.body);
//   } on FormatException {
//     throw Exception(
//       'The server returned an invalid response '
//       '(${response.statusCode}).',
//     );
//   }

//   if (decoded is! Map) {
//     throw Exception('Unexpected response from server.');
//   }

//   final result = Map<String, dynamic>.from(decoded);

//   if (response.statusCode < 200 ||
//       response.statusCode >= 300) {
//     throw Exception(
//       result['message']?.toString() ??
//           'Could not load assigned sessions '
//               '(${response.statusCode}).',
//     );
//   }

//   return result;
// }

Future<Map<String, dynamic>> getPlayerSessions({
  required String accessToken,
}) async {
  final token = accessToken.trim();

  if (token.isEmpty) {
    throw Exception(
      'Access token is empty. Please log in again.',
    );
  }

  debugPrint('Assigned sessions: access token exists');

  final response = await http.get(
    Uri.parse('$baseUrl/player/sessions'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  debugPrint(
    'Assigned sessions status: ${response.statusCode}',
  );

  final dynamic decoded;

  try {
    decoded = jsonDecode(response.body);
  } on FormatException {
    throw Exception(
      'Invalid server response (${response.statusCode}).',
    );
  }

  if (decoded is! Map) {
    throw Exception('Unexpected response from server.');
  }

  final result = Map<String, dynamic>.from(decoded);
   debugPrint('ASSIGNED SESSIONS RESPONSE: $result');
  if (response.statusCode < 200 ||
      response.statusCode >= 300) {
    throw Exception(
      result['message']?.toString() ??
          'Could not load assigned sessions '
              '(${response.statusCode}).',
    );
  }

  return result;
}

}