import 'dart:convert';
import 'package:fitlink/core/model/WearableExcecutionModel.dart';
import 'package:http/http.dart' as http;

class WearableService {
  static const String baseUrl = 'http://localhost:5000/api';

  // Get all wearable executions for a player
  Future<List<dynamic>> getWearableData(String playerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wearable/data/$playerId'),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['data'] as List<dynamic>;
    }

    throw Exception('Failed to fetch wearable data: ${response.statusCode}');
  }

  // Get latest wearable execution for a player
  Future<WearableExecutionModel> getLatestWearableData(String playerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wearable/data/$playerId/Latest'),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      if (result['success'] == true && result['data'] != null) {
        return WearableExecutionModel.fromJson(
          result['data'] as Map<String, dynamic>,
        );
      }

      throw Exception('No latest wearable data available');
    }

    throw Exception(
      'Failed to fetch latest wearable data: '
      '${response.statusCode}',
    );
  }

  // Send wearable data
  Future<Map<String, dynamic>> sendWearableData({
    required String playerId,
    required int heartRate,
    required int steps,
    required double calories,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'playerId': playerId,
        'heartRate': heartRate,
        'steps': steps,
        'calories': calories,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      'Failed to send wearable data: '
      '${response.statusCode} ${response.body}',
    );
  }
}
