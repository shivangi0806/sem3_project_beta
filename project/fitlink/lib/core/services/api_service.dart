import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:5000/api";
  
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

//   Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//   }) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/auth/login"),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "email": email,
//         "password": password,
//       }),
//     );

//     return jsonDecode(response.body);
//   }

Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse("$baseUrl/auth/login"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );
  
  print("STATUS CODE: ${response.statusCode}");
  print("RESPONSE BODY: ${response.body}");

  return jsonDecode(response.body);
}
Future<Map<String, dynamic>> getUsers() async {
  final response = await http.get(
    Uri.parse("$baseUrl/users"),
    headers: {
      "Content-Type": "application/json",
    },
  );

  print("USERS STATUS CODE: ${response.statusCode}");
  print("USERS RESPONSE BODY: ${response.body}");

  return jsonDecode(response.body);
}
 }
