import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
class WearableService {
  //static const String baseUrl = 'http://localhost:5000/api';
  // static const String baseUrl = 'http://192.168.0.101:5000/api';
  static const String baseUrl = 'http://192.168.1.101:5000/api';

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
//  Future<Map<String, dynamic>> sendWearableData({
//     required String playerId,
//     required int heartRate,
//     required int steps,
//     required double calories,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/wearable/data'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'playerId': playerId,
//         'heartRate': heartRate,
//         'steps': steps,
//         'calories': calories,
//       }),
//     );

//     if (response.statusCode >= 200 &&
//         response.statusCode < 300) {
//       return jsonDecode(response.body) as Map<String, dynamic>;
//     }

//     throw Exception(
//       'Failed to send wearable data: '
//       '${response.statusCode} ${response.body}',
//     );
//   }
Future<Map<String, dynamic>> sendWearableData({
  required String playerId,
  required int heartRate,
  required int steps,
  required double calories,
}) async {
  final url = Uri.parse('$baseUrl/wearable/data');

  final body = {
    'playerId': playerId,
    'heartRate': heartRate,
    'steps': steps,
    'calories': calories,
  };

  debugPrint('SYNC URL: $url');
  debugPrint('SYNC BODY: ${jsonEncode(body)}');

  try {
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    debugPrint('SYNC STATUS: ${response.statusCode}');
    debugPrint('SYNC RESPONSE: ${response.body}');

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      'HTTP ${response.statusCode}: ${response.body}',
    );
  } catch (error) {
    debugPrint('SYNC ERROR: $error');
    rethrow;
  }
}
}