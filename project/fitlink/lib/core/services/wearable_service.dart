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
}
 Future<Map<String, dynamic>> sendWearableData({
    required String playerId,
    required int heartRate,
    required int steps,
    required double calories,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'playerId': playerId,
        'heartRate': heartRate,
        'steps': steps,
        'calories': calories,
      }),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      'Failed to send wearable data: '
      '${response.statusCode} ${response.body}',
    );
  }

}