// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const FitLinkWatchApp());
}

class FitLinkWatchApp extends StatelessWidget {
  const FitLinkWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitLink Watch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WatchHomePage(),
    );
  }
}

class WatchHomePage extends StatefulWidget {
  const WatchHomePage({super.key});

  @override
  State<WatchHomePage> createState() => _WatchHomePageState();
}

class _WatchHomePageState extends State<WatchHomePage> {
  bool isSending = false;
  String message = '';

  Future<void> sendWearableData() async {
    print('SEND BUTTON PRESSED');
    setState(() {
      isSending = true;
      message = 'Sending...';
    });

    try {
      final response = await http.post(
        Uri.parse(
          'http://10.134.39.38:5000/api/wearable/data',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'playerId': 'P001',
          'heartRate': 82,
          'steps': 4532,
          'calories': 210,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          message = 'Data sent!';
        });

        print('SERVER RESPONSE: ${response.body}');
      } else {
        setState(() {
          message = 'Failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error sending data';
      });

      print('SEND ERROR: $e');
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'FITLINK',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text('P001'),

                const SizedBox(height: 12),

                const Text('❤️  82 BPM'),
                const Text('👣  4532 steps'),
                const Text('🔥  210 kcal'),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: isSending ? null : sendWearableData,
                  child: Text(
                    isSending ? 'Sending...' : 'SEND DATA',
                  ),
                ),

                const SizedBox(height: 8),

                Text(message),
              ],
            ),
          ),
        ),
      ),
    );
  }
}