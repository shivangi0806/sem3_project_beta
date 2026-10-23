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
  final Workout _workout = Workout();
  final WatchConnectivity _watchConnectivity = WatchConnectivity();

  StreamSubscription<dynamic>? _workoutSubscription;
  StreamSubscription<dynamic>? _messageSubscription;

String? _assignedExerciseName;
int? _assignedSets;
int? _assignedReps;
int? _assignedDurationSeconds;

//String _playerId = 'Player ID unavailable';
bool _isWorkoutStarted = false;
bool _isStartingWorkout = false;

  bool _isSending = false;
  String _message = 'Collecting workout readings...';

  double? _heartRate;
  double? _steps;
  double? _calories;

  @override
  void initState() {
    super.initState();
    _listenToWorkout();
    _listenForAssignedWorkout();

    //startWorkout();
    // startWorkout();
  }

void _listenForAssignedWorkout() {
  _messageSubscription =
      _watchConnectivity.messageStream.listen(
    (message) {
      debugPrint('WATCH RECEIVED MESSAGE: $message');
      if (message is! Map) return;

      if (message['type'] != 'start_workout') {
  debugPrint('IGNORED MESSAGE TYPE: ${message['type']}');
  return;
}

      debugPrint('ASSIGNED WORKOUT RECEIVED: $message');

      if (!mounted) return;

      setState(() {
      //   _playerId = message['playerId']?.toString()
      // ?? 'Player ID unavailable';
        _assignedExerciseName =
            message['exerciseName']?.toString();

        _assignedSets = int.tryParse(
          message['sets']?.toString() ?? '',
        );

        _assignedReps = int.tryParse(
          message['reps']?.toString() ?? '',
        );

        _assignedDurationSeconds = int.tryParse(
          message['durationSeconds']?.toString() ?? '',
        );

        _message = 'Assigned workout received!';
      });
    },
    onError: (error) {
      debugPrint('ASSIGNMENT MESSAGE ERROR: $error');
    },
  );
}
  void _listenToWorkout() {
    _workoutSubscription = _workout.stream.listen(
      (reading) {
        debugPrint(
          'WORKOUT READING: ${reading.feature} = ${reading.value}',
        );

        if (!mounted) return;

        setState(() {
          if (reading.feature == WorkoutFeature.heartRate) {
            _heartRate = reading.value;
          } else if (reading.feature == WorkoutFeature.steps) {
            _steps = reading.value;
          } else if (reading.feature == WorkoutFeature.calories) {
            _calories = reading.value;
          }
        });
      },
      onError: (error) {
        debugPrint('WORKOUT STREAM ERROR: $error');

        if (!mounted) return;
        setState(() {
          _message = 'Error reading workout data';
        });
      },
    );
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

Future<void> startWorkout() async {
  debugPrint('START WORKOUT BUTTON PRESSED');

  if (_isWorkoutStarted || _isStartingWorkout) {
    debugPrint('Workout already started or starting');
    return;
  }

  setState(() {
    _isStartingWorkout = true;
    _message = 'Starting workout...';
  });

  try {
    debugPrint('Checking supported exercise types...');

    final supportedTypes =
        await _workout.getSupportedExerciseTypes();

    debugPrint('SUPPORTED EXERCISES: $supportedTypes');

    final result = await _workout.start(
      exerciseType: ExerciseType.runningTreadmill,
      features: [
        WorkoutFeature.heartRate,
        WorkoutFeature.steps,
        WorkoutFeature.calories,
      ],
      enableGps: false,
    );

    debugPrint('WORKOUT START RESULT: $result');
    debugPrint(
      'UNSUPPORTED FEATURES: ${result.unsupportedFeatures}',
    );

    if (!mounted) return;

    setState(() {
      _isWorkoutStarted = true;
      _message = 'Workout started! Collecting readings...';
    });
  } catch (error, stackTrace) {
    debugPrint('WORKOUT START ERROR: $error');
    debugPrintStack(stackTrace: stackTrace);

    if (!mounted) return;

    setState(() {
      _message = 'Workout failed: $error';
    });
  } finally {
    if (mounted) {
      setState(() {
        _isStartingWorkout = false;
      });
    }
  }
}

  Future<void> _sendWorkoutData() async {
    if (_isSending || _steps == null || _calories == null) {
      return;
    }

    setState(() {
      _isSending = true;
      _message = 'Sending workout data...';
    });

    final recordedAt = DateTime.now().toUtc().toIso8601String();

    // Temporary fallback until the real heart-rate sensor works.
    final int bpm = (_heartRate ?? 80).round();

    final Map<String, dynamic> data = {
      'playerId': 'P001',
      'heartRate': bpm,
      'steps': _steps!.round(),
      'calories': _calories!.round(),
      'recordedAt': recordedAt,
      'syncId': '${recordedAt}_P001',
    };

    debugPrint('WORKOUT DATA TO SEND: $data');

    try {
      // First attempt: send directly to the backend.
      // 10.0.2.2 is for an Android emulator reaching the host computer.
      final response = await http
          .post(
            Uri.parse(
              'http://10.0.2.2:5000/api/wearable/data',
            ),
            // for fallback
              //             Uri.parse(
              //   'http://10.0.2.2:5999/api/wearable/data',
              // ),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 5));

      debugPrint('BACKEND STATUS: ${response.statusCode}');
      debugPrint('BACKEND RESPONSE: ${response.body}');

      // if (response.statusCode >= 200 &&
      //     response.statusCode < 300) {
      //   if (!mounted) return;
      //   setState(() {
      //     _message = 'Sent directly to dashboard!';
      //   });
      //   return;
      // }
      if (response.statusCode >= 200 &&
    response.statusCode < 300) {
  debugPrint('WORKOUT UPLOAD SUCCESSFUL');

  if (mounted) {
    setState(() {
      _message = 'Data synced successfully!';
    });
  }
  return;
}

      // The server responded, so this is an API/server error,
      // not necessarily a connectivity failure.
      if (!mounted) return;
      setState(() {
        _message = 'Backend rejected data: ${response.statusCode}';
      });
    } on TimeoutException catch (error) {
      debugPrint('BACKEND TIMEOUT: $error');
      await _sendToPhone(data);
    } on http.ClientException catch (error) {
      debugPrint('BACKEND CONNECTION ERROR: $error');
      await _sendToPhone(data);
    } catch (error) {
      debugPrint('BACKEND REQUEST ERROR: $error');
      await _sendToPhone(data);
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _sendToPhone(Map<String, dynamic> data) async {
    if (mounted) {
      setState(() {
        _message = 'Backend unavailable. Trying phone...';
      });
    }

    try {
      await _watchConnectivity.sendMessage({
        'type': 'workout_sync',
        ...data,
      });

      debugPrint('WORKOUT MESSAGE SENT TO PHONE');

      if (!mounted) return;
      setState(() {
        _message = 'Sent to phone. Sync from phone when online.';
      });
    } catch (error) {
      debugPrint('PHONE FALLBACK FAILED: $error');

      if (!mounted) return;
      setState(() {
        _message = 'Could not send to phone. Retry required.';
      });
    }
  }

  @override
  void dispose() {
    _workoutSubscription?.cancel();
    //_workoutSubscription?.cancel();
  _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  
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

            // const Text(
            //   'P001',
            //   style: TextStyle(
            //     fontSize: 10,
            //     color: Colors.white,
            //   ),
            // ),
//             Text(
//   _playerId,
//   textAlign: TextAlign.center,
//   style: const TextStyle(
//     fontSize: 9,
//     color: Colors.white,
//   ),
// ),

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

            const SizedBox(height: 6),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isStartingWorkout || _isWorkoutStarted
                    ? null
                    : startWorkout,
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

            const SizedBox(height: 6),

            Text(
              '❤️ ${(_heartRate ?? 80).round()} BPM'
              '${_heartRate == null ? ' *' : ''}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),

            Text(
              '👣 ${_steps?.round() ?? '--'} steps',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),

            Text(
              '🔥 ${_calories?.round() ?? '--'} kcal',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isWorkoutStarted ||
                        _isSending ||
                        _steps == null ||
                        _calories == null
                    ? null
                    : _sendWorkoutData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  minimumSize: const Size(0, 32),
                ),
                child: Text(
                  _isSending ? 'SENDING...' : 'SEND',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              _message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
