// import 'dart:convert';

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workout/workout.dart';

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

//   String heartRate = '--';
// String steps = '--';
// String calories = '--';
//double? heartRate;
double heartRate=80;
double? steps;
double? calories;

final workout = Workout();


@override
void initState() {
  super.initState();

  workout.stream.listen((reading) {
    debugPrint(
  'WORKOUT READING: ${reading.feature} = ${reading.value}',
); if (reading.feature == WorkoutFeature.heartRate) {
    debugPrint('🔥 HEART RATE RECEIVED: ${reading.value}');
  }
    setState(() {
      if (reading.feature == WorkoutFeature.heartRate) {
        heartRate = reading.value;
      }

      if (reading.feature == WorkoutFeature.steps) {
        steps = reading.value;
      }

      if (reading.feature == WorkoutFeature.calories) {
        calories = reading.value;
      }
    });
  });

  startWorkout();
}
Future<void> startWorkout() async {
  final result = await workout.start(
    exerciseType: ExerciseType.runningTreadmill,
    features: [
      WorkoutFeature.heartRate,
      WorkoutFeature.steps,
      WorkoutFeature.calories,
    ],
    enableGps: false,
  );

  debugPrint('Workout started: $result');
}
// Future<void> startWorkout() async {
//   final result = await workout.start(
//     exerciseType: ExerciseType.runningTreadmill,
//     features: [
//       WorkoutFeature.heartRate,
//     ],
//     enableGps: false,
//   );

//   debugPrint('Workout started: $result');
// }

  Future<void> sendWearableData() async {
    print('SEND BUTTON PRESSED');
    setState(() {
      isSending = true;
      message = 'Sending...';
    });

    try {
      final response = await http.post(
        Uri.parse(
          // phone connection
          'http://10.134.39.38:5000/api/wearable/data',
          // hostel wifi
          //'http://192.168.1.150:5000/api/wearable/data',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
       // body: jsonEncode({
          // 'playerId': 'P001',
          // 'heartRate': 82,
          // 'steps': 4532,
          // 'calories': 210,
          
       // }),
       body: jsonEncode({
  // 'playerId': 'P001',
  // 'heartRate': double.parse(heartRate).round(),
  // 'steps': double.parse(steps).round(),
  // 'calories': double.parse(calories).round(),
          'playerId': 'P001',
          'heartRate': heartRate?.round(),
          'steps': steps?.round(),
          'calories': calories?.round(),
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

                // const Text('❤️  82 BPM'),
                // const Text('👣  4532 steps'),
                // const Text('🔥  210 kcal'),

//                 Text('❤️  $heartRate BPM'),
// Text('👣  $steps steps'),
// Text('🔥  $calories kcal'),

Text('❤️  ${heartRate?.toStringAsFixed(0) ?? '--'} BPM'),
Text('👣  ${steps?.toStringAsFixed(0) ?? '--'} steps'),
Text('🔥  ${calories?.toStringAsFixed(0) ?? '--'} kcal'),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: isSending ||
        heartRate == null ||
        steps == null ||
        calories == null
    ? null : sendWearableData,
                  child: Text(
                    isSending ? 'Sending...' : 'SEND DATA',
                  ),
                ),

                const SizedBox(height: 8),

                Text(message),
                //Text(WorkoutFeature.)
              ],
//               features: [
//   WorkoutFeature.
// ],
            ),
          ),
        ),
      ),
    );
  }
}