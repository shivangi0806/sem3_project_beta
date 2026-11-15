
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
class WatchPairingService {
  static const String _watchIdKey = 'fitlink_watch_id';
  static const String _deviceKeyKey = 'fitlink_device_key';

  static String _generateHex(int byteCount) {
    final random = Random.secure();

    return List.generate(
      byteCount,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  static Future<Map<String, String>> getWatchIdentity() async {
    final prefs = await SharedPreferences.getInstance();

    String? watchId = prefs.getString(_watchIdKey);
    String? deviceKey = prefs.getString(_deviceKeyKey);

    if (watchId == null || deviceKey == null) {
      watchId = 'FITLINK-WATCH-${_generateHex(8)}';
      deviceKey = _generateHex(32);

      await prefs.setString(_watchIdKey, watchId);
      await prefs.setString(_deviceKeyKey, deviceKey);
    }

    return {
      'watchId': watchId,
      'deviceKey': deviceKey,
    };
  }
  static Future<bool> registerWatch() async {
  final identity = await getWatchIdentity();

  final url = Uri.parse(
    'http://10.0.2.2:5000/api/wearable/pairing/register',
  );

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'watchId': identity['watchId'],
        'deviceKey': identity['deviceKey'],
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      return true;
    }

    throw Exception(data['message'] ?? 'Watch registration failed');
  } catch (e) {
    throw Exception('Could not register watch: $e');
  }
}
static Future<String> generatePairingQR() async {
  final identity = await getWatchIdentity();

  final url = Uri.parse(
    'http://10.0.2.2:5000/api/wearable/pairing/generate',
  );

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'watchId': identity['watchId'],
      'deviceKey': identity['deviceKey'],
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode >= 200 &&
      response.statusCode < 300 &&
      data['success'] == true) {
    return data['qrData'];
  }

  throw Exception(data['message'] ?? 'QR generation failed');
}
}
