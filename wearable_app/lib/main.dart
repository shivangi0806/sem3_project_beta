// // import 'dart:convert';

// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:wearable_app/watch_connection_test.dart';
// import 'package:workout/workout.dart';
// import 'watch_connection_test.dart';

// void main() {
//   runApp(const FitLinkWatchApp());
// }

// class FitLinkWatchApp extends StatelessWidget {
//   const FitLinkWatchApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'FitLink Watch',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const WatchConnectionTest(),
//       //const WatchHomePage(),
//     );
//   }
// }

// class WatchHomePage extends StatefulWidget {
//   const WatchHomePage({super.key});

//   @override
//   State<WatchHomePage> createState() => _WatchHomePageState();
// }

// class _WatchHomePageState extends State<WatchHomePage> {
//   bool isSending = false;
//   String message = '';

// //   String heartRate = '--';
// // String steps = '--';
// // String calories = '--';
// //double? heartRate;
// //double heartRate=80;
// double? heartRate;
// double? steps;
// double? calories;

// final workout = Workout();


// @override
// void initState() {
//   super.initState();

//   workout.stream.listen((reading) {
//     debugPrint(
//   'WORKOUT READING: ${reading.feature} = ${reading.value}',
// ); if (reading.feature == WorkoutFeature.heartRate) {
//     debugPrint('🔥 HEART RATE RECEIVED: ${reading.value}');
//   }
//     setState(() {
//       if (reading.feature == WorkoutFeature.heartRate) {
//         heartRate = reading.value;
//       }

//       if (reading.feature == WorkoutFeature.steps) {
//         steps = reading.value;
//       }

//       if (reading.feature == WorkoutFeature.calories) {
//         calories = reading.value;
//       }
//     });
//   });

//   startWorkout();
// // super.initState();

// //   workout.stream.listen((reading) {
// //     debugPrint(
// //       'WORKOUT READING: ${reading.feature} = ${reading.value}',
// //     );

// //     if (!mounted) return;

// //     setState(() {
// //       if (reading.feature == WorkoutFeature.heartRate) {
// //         heartRate = reading.value;
// //       }

// //       if (reading.feature == WorkoutFeature.steps) {
// //         steps = reading.value;
// //       }

// //       if (reading.feature == WorkoutFeature.calories) {
// //         calories = reading.value;
// //       }
// //     });
// //   });

// //   startWorkout();
//  }

// // Future<void> startWorkout() async {
// //   final result = await workout.start(
// //     exerciseType: ExerciseType.runningTreadmill,
// //     features: [
// //       WorkoutFeature.heartRate,
// //       WorkoutFeature.steps,
// //       WorkoutFeature.calories,
// //     ],
// //     enableGps: false,
// //   );

// //   debugPrint('Workout started: $result');
// // }
// Future<void> startWorkout() async {
//   try {
//     debugPrint('Checking supported exercise types...');

//     final supportedTypes =
//         await workout.getSupportedExerciseTypes();

//     debugPrint('SUPPORTED EXERCISES: $supportedTypes');

//     final result = await workout.start(
//       exerciseType: ExerciseType.runningTreadmill,
//       features: [
//         WorkoutFeature.heartRate,
//         WorkoutFeature.steps,
//         WorkoutFeature.calories,
//       ],
//       enableGps: false,
//     );

//     debugPrint('WORKOUT START RESULT: $result');
//     debugPrint('UNSUPPORTED FEATURES: ${result.unsupportedFeatures}');

//     if (result.unsupportedFeatures.isNotEmpty) {
//       debugPrint(
//         'Some requested workout features are unsupported.',
//       );
//     }
//   } catch (e, stackTrace) {
//     debugPrint('WORKOUT START ERROR: $e');
//     debugPrint('$stackTrace');
//   }
// }
// // Future<void> startWorkout() async {
// //   final result = await workout.start(
// //     exerciseType: ExerciseType.runningTreadmill,
// //     features: [
// //       WorkoutFeature.heartRate,
// //     ],
// //     enableGps: false,
// //   );

// //   debugPrint('Workout started: $result');
// // }
// //changing
// //   Future<void> sendWearableData() async {
// //     print('SEND BUTTON PRESSED');
// //     setState(() {
// //       isSending = true;
// //       message = 'Sending...';
// //     });

// //     try {
// //       final response = await http.post(
// //         Uri.parse(
// //           // phone connection
// //           //'http://10.134.39.38:5000/api/wearable/data',
// //           // hostel wifi
// //           'http://192.168.1.150:5000/api/wearable/data',
// //         ),
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //        // body: jsonEncode({
// //           // 'playerId': 'P001',
// //           // 'heartRate': 82,
// //           // 'steps': 4532,
// //           // 'calories': 210,
          
// //        // }),
// //        body: jsonEncode({
// //   // 'playerId': 'P001',
// //   // 'heartRate': double.parse(heartRate).round(),
// //   // 'steps': double.parse(steps).round(),
// //   // 'calories': double.parse(calories).round(),
// //           'playerId': 'P001',
// //           'heartRate': heartRate?.round(),
// //           'steps': steps?.round(),
// //           'calories': calories?.round(),
// // }),
// //       );

// //       if (response.statusCode == 200) {
// //         setState(() {
// //           message = 'Data sent!';
// //         });

// //         print('SERVER RESPONSE: ${response.body}');
// //       } else {
// //         setState(() {
// //           message = 'Failed: ${response.statusCode}';
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         message = 'Error sending data';
// //       });
        
// //       print('SEND ERROR: $e');
// //     } finally {
// //       setState(() {
// //         isSending = false;
// //       });
// //     }
// //   }
//  Future<void> sendWearableData() async {
//   print('1. SEND BUTTON PRESSED');

//   setState(() {
//     isSending = true;
//     message = 'Sending...';
//   });

//   try {
//     print('2. STARTING HTTP REQUEST');

//     final response = await http.post(
//       Uri.parse(
//        // 'http://192.168.1.150:5000/api/wearable/data',
//        'http://10.0.2.2:5000/api/wearable/data',
//       ),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'playerId': 'P001',
//         'heartRate': heartRate!.round(),
//         'steps': steps?.round(),
//         'calories': calories?.round(),
//       }),
//     );

//     print('3. RESPONSE RECEIVED');
//     print('STATUS: ${response.statusCode}');
//     print('BODY: ${response.body}');

//     if (response.statusCode == 200) {
//       setState(() {
//         message = 'Data sent!';
//       });
//     } else {
//       setState(() {
//         message = 'Failed: ${response.statusCode}';
//       });
//     }
//   } catch (e) {
//     print('4. SEND ERROR: $e');

//     setState(() {
//       message = 'Error sending data';
//     });
//   } finally {
//     print('5. REQUEST FINISHED');

//     setState(() {
//       isSending = false;
//     });
//   }
// } 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'FITLINK',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 const Text('P001'),

//                 const SizedBox(height: 12),

//                 // const Text('❤️  82 BPM'),
//                 // const Text('👣  4532 steps'),
//                 // const Text('🔥  210 kcal'),

// //                 Text('❤️  $heartRate BPM'),
// // Text('👣  $steps steps'),
// // Text('🔥  $calories kcal'),

// Text('❤️  ${heartRate?.toStringAsFixed(0) ?? '--'} BPM'),
// Text('👣  ${steps?.toStringAsFixed(0) ?? '--'} steps'),
// Text('🔥  ${calories?.toStringAsFixed(0) ?? '--'} kcal'),

//                 const SizedBox(height: 16),

//                 ElevatedButton(
//                   onPressed: isSending ||
//         heartRate == null ||
//         steps == null ||
//         calories == null
//     ? null : sendWearableData,
//                   child: Text(
//                     isSending ? 'Sending...' : 'SEND DATA',
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 Text(message),
//                 //Text(WorkoutFeature.)
//               ],
// //               features: [
// //   WorkoutFeature.
// // ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:wearable_app/theme/theme.dart';
import 'package:workout/workout.dart';
import 'package:wearable_app/screen/workout_screen.dart';

import 'watch_pairing_service.dart';
import 'screen/watch_pairing_screen.dart';

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
 
 
String? _assignedExerciseName;
int? _assignedSets;
int? _assignedReps;
int? _assignedDurationSeconds;

 bool _isWorkoutStarted = false;
bool _isStartingWorkout = false;
final Workout _workout = Workout();
String _message="DATA";

final WatchConnectivity _watchConnectivity = WatchConnectivity();
StreamSubscription<dynamic>? _messageSubscription;
Future<void> testWatchPairing() async {
  try {
    final registered =
        await WatchPairingService.registerWatch();

    if (registered) {
      final qrData =
          await WatchPairingService.generatePairingQR();

      debugPrint('PAIRING QR DATA: $qrData');
    }
  } catch (e) {
    debugPrint('PAIRING ERROR: $e');
  }
}
//   Future<void> startWorkout() async {
//     try {
//       debugPrint(
//   'ALL PACKAGE EXERCISE TYPES: '
//   '${ExerciseType.values.map((e) => e.name).join(', ')}',
// );

// final supportedTypes =
//     await _workout.getSupportedExerciseTypes();

// debugPrint('SUPPORTED BY THIS WATCH: $supportedTypes');
//       final result = await _workout.start(
//         exerciseType:
//          ExerciseType.runningTreadmill,
//         features: [
//           WorkoutFeature.heartRate,
//           WorkoutFeature.steps,
//           WorkoutFeature.calories,
//         ],
//         enableGps: false,
//       );

//       debugPrint('WORKOUT START RESULT: $result');
//       debugPrint('UNSUPPORTED FEATURES: ${result.unsupportedFeatures}');
//     } catch (error, stackTrace) {
//       debugPrint('WORKOUT START ERROR: $error');
//       debugPrintStack(stackTrace: stackTrace);

//       if (!mounted) return;
//       setState(() {
//         _message = 'Could not start workout tracking';
//       });
//     }
//   }
// Future<void> startWorkout() async {
//   if (!_isWorkoutStarted ||
//     _isSending ||
//     _steps == null ||
//     _calories == null) {
//   return;
// }
//   if (_isWorkoutStarted || _isStartingWorkout) return;

//   setState(() {
//     _isStartingWorkout = true;
//     _message = 'Starting workout...';
//   });

//   try {
//     final result = await _workout.start(
//       exerciseType: ExerciseType.runningTreadmill,
//       features: [
//         WorkoutFeature.heartRate,
//         WorkoutFeature.steps,
//         WorkoutFeature.calories,
//       ],
//       enableGps: false,
//     );

//     debugPrint('WORKOUT START RESULT: $result');
//     debugPrint('UNSUPPORTED FEATURES: ${result.unsupportedFeatures}');

//     if (!mounted) return;

//     setState(() {
//       _isWorkoutStarted = true;
//       _message = 'Workout started! Collecting readings...';
//     });
//   } catch (error, stackTrace) {
//     debugPrint('WORKOUT START ERROR: $error');
//     debugPrintStack(stackTrace: stackTrace);

//     if (!mounted) return;

//     setState(() {
//       _message = 'Could not start workout tracking';
//     });
//   } finally {
//     if (mounted) {
//       setState(() {
//         _isStartingWorkout = false;
//       });
//     }
//   }
// }


@override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: navyBlueMid,
//     body: SafeArea(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             'FITLINK',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,color: Colors.white
//             ),
//           ),
//           const Text('P001'),
//           const SizedBox(height:3),
      
//       Text(
//         _assignedExerciseName ?? 'No exercise assigned',
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
      
//       if (_assignedExerciseName != null) ...[
//         Text(
//           'Sets: ${_assignedSets ?? '-'}  '
//           'Reps: ${_assignedReps ?? '-'}',
//           style: const TextStyle(
//             fontSize: 10,
//             color: Colors.white,
//           ),
//         ),
      
//         if (_assignedDurationSeconds != null)
//           Text(
//             'Duration: ${_assignedDurationSeconds}s',
//             style: const TextStyle(
//       fontSize: 10,
//       color: Colors.white,
//             ),
//           ),
//       ],
      
//       const SizedBox(height: 8),
//           const SizedBox(height: 8),
//           SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           onPressed: _isWorkoutStarted || _isStartingWorkout
//       ? null
//       : startWorkout,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: accentBlue,
//             padding: const EdgeInsets.symmetric(vertical: 8),
//           ),
//           child: Text(
//             _isStartingWorkout
//         ? 'STARTING...'
//         : _isWorkoutStarted
//             ? 'WORKOUT STARTED'
//             : 'START WORKOUT',
//             style: const TextStyle(
//       fontSize: 12,
//       color: Colors.white,
//             ),
//           ),
//         ),
//       ),
      
//       const SizedBox(height: 8),
      
//           Text(
//             '❤️ ${(_heartRate ?? 80).round()} BPM'
//             '${_heartRate == null ? ' *' : ''}',
//             style: const TextStyle(fontSize: 12,color: Colors.white ),
            
//           ),
//           Text(
//             '👣 ${_steps?.round() ?? '--'} steps',
//             style: const TextStyle(fontSize: 12,color: Colors.white),
//           ),
//           Text(
//             '🔥 ${_calories?.round() ?? '--'} kcal',
//             style: const TextStyle(fontSize: 12,color: Colors.white),
//           ),
      
//           const SizedBox(height: 10),
      
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _isSending ||
//                       _steps == null ||
//                       _calories == null
//                   ? null
//                   : _sendWorkoutData,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 8,
//                 ),backgroundColor: accentBlue
//               ),
//               child: Text(
//                 _isSending ? 'Sending...' : 'SEND',
//                 style: const TextStyle(fontSize: 12,color: Colors.white),
//               ),
//             ),
//           ),
      
//           const SizedBox(height: 6),
      
//           Flexible(
//             child: SingleChildScrollView(
//               child: Text(
//                 _message,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 10,color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Center(
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.all(12),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const Text(
  //                 'FITLINK',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text('P001'),
  //               const SizedBox(height: 16),
  //               Text(
  //                 '❤️ ${(_heartRate ?? 80).round()} BPM'
  //                 '${_heartRate == null ? ' *' : ''}',
  //               ),
  //               Text('👣 ${_steps?.round() ?? '--'} steps'),
  //               Text('🔥 ${_calories?.round() ?? '--'} kcal'),
  //               const SizedBox(height: 16),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: _isSending ||
  //                           _steps == null ||
  //                           _calories == null
  //                       ? null
  //                       : _sendWorkoutData,
  //                   child: Text(
  //                     _isSending ? 'Sending...' : 'SEND',
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 _message,
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(fontSize: 11),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
@override
void initState() {
  super.initState();

  debugPrint('WATCH HOME INITIALIZED');

  _messageSubscription = _watchConnectivity.messageStream.listen(
    (message) {
      debugPrint('MESSAGE RECEIVED ON WATCH: $message');

      if (message is! Map) {
        debugPrint('Invalid message format');
        return;
      }

      final data = Map<String, dynamic>.from(message);

      if (data['type'] != 'start_workout') {
        debugPrint('Ignoring message type: ${data['type']}');
        return;
      }

      final exerciseName =
          data['exerciseName']?.toString();

      if (exerciseName == null || exerciseName.isEmpty) {
        debugPrint('Exercise name missing');
        return;
      }

      if (!mounted) return;

      setState(() {
        _assignedExerciseName = exerciseName;
        _assignedSets = int.tryParse('${data['sets']}');
        _assignedReps = int.tryParse('${data['reps']}');
        _assignedDurationSeconds =
            int.tryParse('${data['durationSeconds']}');
      });

      debugPrint('ASSIGNED WORKOUT RECEIVED: $exerciseName');
      debugPrint('SETS: $_assignedSets');
      debugPrint('REPS: $_assignedReps');
      debugPrint('DURATION: $_assignedDurationSeconds');
    },
    onError: (error) {
      debugPrint('WATCH MESSAGE ERROR: $error');
    },
  );
}
@override
void dispose() {
  _messageSubscription?.cancel();
  super.dispose();
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: navyBlueMid,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'FITLINK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

        

            const SizedBox(height: 10),

            Text(
              _assignedExerciseName ?? 'No exercise assigned',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            if (_assignedExerciseName != null) ...[
              Text(
                'Sets: ${_assignedSets ?? '-'}  '
                'Reps: ${_assignedReps ?? '-'}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),

              if (_assignedDurationSeconds != null)
                Text(
                  'Duration: ${_assignedDurationSeconds}s',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
            ],

      //       const SizedBox(height: 6),
      //       ElevatedButton(onPressed:(){ Navigator.push(context,
      // MaterialPageRoute(
      //   builder: (context) => WorkoutScreen(),), 
      //   );},child: Text("Start Workout")),

            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: ,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: accentBlue,
            //       foregroundColor: Colors.white,
            //       padding: const EdgeInsets.symmetric(vertical: 6),
            //       minimumSize: const Size(0, 32),
            //     ),
            //     child: Text(
            //       _isStartingWorkout
            //           ? 'STARTING...'
            //           : _isWorkoutStarted
            //               ? 'WORKOUT STARTED'
            //               : 'START WORKOUT',
            //       style: const TextStyle(fontSize: 11),
            //     ),
            //   ),
            // ),



            const SizedBox(height: 6),


             SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                 onPressed: 
                _isStartingWorkout || _isWorkoutStarted
                    ? null
                    : (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkoutScreen()
                
                      ));
                    }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  minimumSize: const Size(0, 32),
                  
                ),
                child: Text(
                  _isStartingWorkout
                      ? 'STARTING...'
                      : _isWorkoutStarted
                          ? 'WORKOUT STARTED'
                          : 'START WORKOUT',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),

const SizedBox(height: 8),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WatchPairingScreen(),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: accentBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 4),
      minimumSize: const Size(0, 32),
    ),
    child: const Text('PAIR WATCH'),
  ),
),


       ] )
      ),
    ),
  );
}

}
