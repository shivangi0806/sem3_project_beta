import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // For a physical Android phone, use your computer's current LAN IP.
  // For the standard Android emulator, use http://10.0.2.2:5000/api
  static const String baseUrl =
      //'http://192.168.0.101:5000/api';
        'http://192.168.1.104:5000/api';

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
}