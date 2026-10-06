import 'api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class CoachService{
static const String baseUrl = "http://localhost:5000/api";
  
  Future<dynamic> getPlayers() async {
    final response = await http.get(
      Uri.parse("$baseUrl/players"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load players");
    }
  }
}