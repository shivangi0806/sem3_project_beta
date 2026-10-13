import 'package:http/http.dart' as http;
import 'dart:convert';
class WearableService {
  static const String baseUrl = 'http://localhost:5000/api';


Future<List<dynamic>> getWearableData(String playerId) async {
  // static const String baseUrl = 
  
  final response = await http.get(
    Uri.parse('$baseUrl/wearable/data/$playerId'),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    return result['data'] as List<dynamic>;
  }

  throw Exception(
    'Failed to fetch wearable data: ${response.statusCode}',
  );
}}