import 'package:flutter/material.dart';
import 'package:wearable_app/theme/theme.dart';
import 'dart:async';
import 'dart:convert';
import 'package:workout/workout.dart';
import 'package:http/http.dart' as http;
import 'package:watch_connectivity/watch_connectivity.dart';
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
   final Workout _workout = Workout();
  final WatchConnectivity _watchConnectivity = WatchConnectivity();

  StreamSubscription<dynamic>? _workoutSubscription;
  StreamSubscription<dynamic>? _messageSubscription;



//String _playerId = 'Player ID unavailable';

String? _assignedExerciseName;
int? _assignedSets;
int? _assignedReps;
int? _assignedDurationSeconds;
bool _isWorkoutStarted = false;
bool _isStartingWorkout = false;
//final Workout _workout = Workout();


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

    startWorkout();
    // startWorkout();
  }// @override
  // void dispose() {
  //   _workoutSubscription?.cancel();
  //   //_workoutSubscription?.cancel();
  // _messageSubscription?.cancel();
  //   super.dispose();
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
            // Uri.parse(
            //   'http://10.0.2.2:5000/api/wearable/data',
            // ),
            // for fallback
                          Uri.parse(
                'http://10.0.2.2:5999/api/wearable/data',
              ),
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

  
  
////Listen to assign workout


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
      debugPrint('WATCH RECEIVED MESSAGE: $message');
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
//assigned workout
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
  //     }
//   }
// }

// Future<void> startWorkout() async {
//   debugPrint('START WORKOUT BUTTON PRESSED');

//   if (_isWorkoutStarted || _isStartingWorkout) {
//     debugPrint('Workout already started or starting');
//     return;
//   }

//   setState(() {
//     _isStartingWorkout = true;
//     _message = 'Starting workout...';
//   });

//   try {
//     debugPrint('Checking supported exercise types...');

//     final supportedTypes =
//         await _workout.getSupportedExerciseTypes();

//     debugPrint('SUPPORTED EXERCISES: $supportedTypes');

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
//     debugPrint(
//       'UNSUPPORTED FEATURES: ${result.unsupportedFeatures}',
//     );

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
//       _message = 'Workout failed: $error';
//     });
//   } finally {
//     if (mounted) {
//       setState(() {
//         _isStartingWorkout = false;
//       });
//     }
//   }
// }

//   Future<void> _sendWorkoutData() async {
//     if (_isSending || _steps == null || _calories == null) {
//       return;
//     }

//     setState(() {
//       _isSending = true;
//       _message = 'Sending workout data...';
//     });

//     final recordedAt = DateTime.now().toUtc().toIso8601String();

//     // Temporary fallback until the real heart-rate sensor works.
//     final int bpm = (_heartRate ?? 80).round();

//     final Map<String, dynamic> data = {
//       'playerId': 'P001',
//       'heartRate': bpm,
//       'steps': _steps!.round(),
//       'calories': _calories!.round(),
//       'recordedAt': recordedAt,
//       'syncId': '${recordedAt}_P001',
//     };

//     debugPrint('WORKOUT DATA TO SEND: $data');

//     try {
//       // First attempt: send directly to the backend.
//       // 10.0.2.2 is for an Android emulator reaching the host computer.
//       final response = await http
//           .post(
//             // Uri.parse(
//             //   'http://10.0.2.2:5000/api/wearable/data',
//             // ),
//             // for fallback
//                           Uri.parse(
//                 'http://10.0.2.2:5999/api/wearable/data',
//               ),
//             headers: {
//               'Content-Type': 'application/json',
//             },
//             body: jsonEncode(data),
//           )
//           .timeout(const Duration(seconds: 5));

//       debugPrint('BACKEND STATUS: ${response.statusCode}');
//       debugPrint('BACKEND RESPONSE: ${response.body}');

//       // if (response.statusCode >= 200 &&
//       //     response.statusCode < 300) {
//       //   if (!mounted) return;
//       //   setState(() {
//       //     _message = 'Sent directly to dashboard!';
//       //   });
//       //   return;
//       // }
//       if (response.statusCode >= 200 &&
//     response.statusCode < 300) {
//   debugPrint('WORKOUT UPLOAD SUCCESSFUL');

//   if (mounted) {
//     setState(() {
//       _message = 'Data synced successfully!';
//     });
//   }
//   return;
// }

//       // The server responded, so this is an API/server error,
//       // not necessarily a connectivity failure.
//       if (!mounted) return;
//       setState(() {
//         _message = 'Backend rejected data: ${response.statusCode}';
//       });
//     } on TimeoutException catch (error) {
//       debugPrint('BACKEND TIMEOUT: $error');
//       await _sendToPhone(data);
//     } on http.ClientException catch (error) {
//       debugPrint('BACKEND CONNECTION ERROR: $error');
//       await _sendToPhone(data);
//     } catch (error) {
//       debugPrint('BACKEND REQUEST ERROR: $error');
//       await _sendToPhone(data);
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSending = false;
//         });
//       }
//     }
//   }

  // Future<void> _sendToPhone(Map<String, dynamic> data) async {
  //   if (mounted) {
  //     setState(() {
  //       _message = 'Backend unavailable. Trying phone...';
  //     });
  //   }

  //   try {
  //     await _watchConnectivity.sendMessage({
  //       'type': 'workout_sync',
  //       ...data,
  //     });

  //     debugPrint('WORKOUT MESSAGE SENT TO PHONE');

  //     if (!mounted) return;
  //     setState(() {
  //       _message = 'Sent to phone. Sync from phone when online.';
  //     });
  //   } catch (error) {
  //     debugPrint('PHONE FALLBACK FAILED: $error');

  //     if (!mounted) return;
  //     setState(() {
  //       _message = 'Could not send to phone. Retry required.';
  //     });
  //   }
  // }

   

  //@override
  
  
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: navyBlueMid,
  //     body: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               children: [
  //                 Icon(Icons.monitor_heart, color: accentBlue),
  //                 Text(
  //                   '${(_heartRate ?? 80).round()} BPM'
  //                   '${_heartRate == null ? ' *' : ''}',
  //                   style: const TextStyle(
  //                     fontSize: 11,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Icon(Icons.directions_walk, color: accentBlue),
  //                 Text(
  //                   '${_steps?.round() ?? '--'} steps',
  //                   style: const TextStyle(
  //                     fontSize: 11,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Icon(
  //                   Icons.local_fire_department,
  //                   color: accentBlue,
  //                 ),
  //                 Text(
  //                   '${_calories?.round() ?? '--'} kcal',
  //                   style: const TextStyle(
  //                     fontSize: 11,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 6),
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: !_isWorkoutStarted ||
  //                         _isSending ||
  //                         _steps == null ||
  //                         _calories == null
  //                     ? null
  //                     : _sendWorkoutData,
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: accentBlue,
  //                   foregroundColor: Colors.white,
  //                   padding: const EdgeInsets.symmetric(vertical: 6),
  //                   minimumSize: const Size(0, 32),
  //                 ),
  //                 child: Text(
  //                   _isSending ? 'SENDING...' : 'SEND',
  //                   style: const TextStyle(fontSize: 11),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               _message,
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(
  //                 fontSize: 9,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ],
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monitor_heart, color: accentBlue, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${(_heartRate ?? 80).round()} BPM'
                    '${_heartRate == null ? ' *' : ''}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_walk, color: accentBlue, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${_steps?.round() ?? '--'} steps',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: accentBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_calories?.round() ?? '--'} kcal',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                    minimumSize: const Size(0, 34),
                  ),
                  child: Text(
                    _isSending ? 'SENDING...' : 'SEND',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  }