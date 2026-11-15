
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:fitlink/core/services/api_service.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  AnalyticsService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final ApiService _api = ApiService();

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> getPlayerReport({
    required String token,
    required String playerId,
    required String period,
    String? startDate,
    String? endDate,
    String timezone = 'Asia/Kolkata',
    String? groupBy,
  }) async {
    final uri = Uri.parse(
      '${_api.baseUrl}/analytics/players/${Uri.encodeComponent(playerId)}/report',
    ).replace(
      queryParameters: {
        'period': period,
        'timezone': timezone,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (groupBy != null) 'groupBy': groupBy,
      },
    );

    final stopwatch = Stopwatch()..start();
    _log('GET ${uri.path} started (period=$period, timezone=$timezone, '
        'startDate=${startDate ?? 'default'}, endDate=${endDate ?? 'default'}, '
        'groupBy=${groupBy ?? 'default'}).');

    late final http.Response response;
    try {
      response = await _client.get(uri, headers: _headers(token));
    } catch (error, stackTrace) {
      stopwatch.stop();
      _log('GET ${uri.path} failed before receiving a response after '
          '${stopwatch.elapsedMilliseconds}ms: $error\n$stackTrace');
      rethrow;
    }
    stopwatch.stop();
    _log('GET ${uri.path} completed with HTTP ${response.statusCode} '
        'in ${stopwatch.elapsedMilliseconds}ms.');

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      _log('GET ${uri.path} returned invalid JSON.');
      throw AnalyticsApiException(response.statusCode, 'The analytics service returned an invalid response.');
    }

    final result = decoded is Map
        ? Map<String, dynamic>.from(decoded)
        : <String, dynamic>{'data': decoded};

    if (response.statusCode < 200 || response.statusCode >= 300 || result['success'] == false) {
      _log('GET ${uri.path} reported an API error: '
          '${result['error'] ?? result['message'] ?? response.statusCode}.');
      throw AnalyticsApiException(
        response.statusCode,
        result['message']?.toString() ?? result['error']?.toString() ??
            'Could not load player analytics',
      );
    }

    if (result['data'] is! Map) {
      _log('GET ${uri.path} response is missing the report data object.');
      throw const FormatException('The analytics response did not contain a report.');
    }

    final report = Map<String, dynamic>.from(result['data'] as Map);
    _log('Report data received. Sections: ${report.keys.join(', ')}.');

    return result;
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[AnalyticsService] $message');
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
