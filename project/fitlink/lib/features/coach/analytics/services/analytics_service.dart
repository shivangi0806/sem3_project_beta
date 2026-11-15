
import 'dart:convert';

import 'package:fitlink/core/services/api_service.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  AnalyticsService({
    required this.token,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String token;
  final http.Client _client;
  final ApiService _api = ApiService();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> getPlayerReport({
    required String playerId,
    required String period,
    String timezone = 'Asia/Kolkata',
  }) async {
    final uri = Uri.parse(
      '${_api.baseUrl}/analytics/players/${Uri.encodeComponent(playerId)}/report',
    ).replace(
      queryParameters: {
        'period': period,
        'timezone': timezone,
      },
    );

    final response = await _client.get(
      uri,
      headers: _headers,
    );

    final body = jsonDecode(response.body);

    final result = body is Map<String, dynamic>
        ? body
        : <String, dynamic>{'data': body};

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AnalyticsApiException(
        response.statusCode,
        result['message']?.toString() ??
            'Could not load player analytics',
      );
    }

    return result;
  }

  void dispose() {
    _client.close();
  }
}

class AnalyticsApiException implements Exception {
  const AnalyticsApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}
