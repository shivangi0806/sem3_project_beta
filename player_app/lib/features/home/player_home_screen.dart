
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../core/models/user.dart';
// import '../../services/wearable_service.dart';
// import '../auth/cubit/auth_cubit.dart';
// import '../auth/screens/login_screen.dart';

// class PlayerHomeScreen extends StatefulWidget {
//   final UserSession session;

//   const PlayerHomeScreen({
//     super.key,
//     required this.session,
//   });

//   @override
//   State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
// }

// class _PlayerHomeScreenState extends State<PlayerHomeScreen> {
//   final WearableService _wearableService = WearableService();

//   List<dynamic> _records = [];
//   bool _isLoading = false;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _loadWearableData();
//   }

//   Future<void> _loadWearableData() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final playerId = widget.session.user.userId;

//       debugPrint('Fetching wearable data for: $playerId');

//       final records =
//           await _wearableService.getWearableData(playerId);

//       if (!mounted) return;

//       // Sort newest record first.
//       records.sort((a, b) {
//         final dateA = DateTime.tryParse(
//               (a['recordedAt'] ?? '').toString(),
//             ) ??
//             DateTime.fromMillisecondsSinceEpoch(0);

//         final dateB = DateTime.tryParse(
//               (b['recordedAt'] ?? '').toString(),
//             ) ??
//             DateTime.fromMillisecondsSinceEpoch(0);

//         return dateB.compareTo(dateA);
//       });

//       setState(() {
//         _records = records;
//         _isLoading = false;
//       });
//     } catch (e) {
//       debugPrint('WEARABLE FETCH ERROR: $e');

//       if (!mounted) return;

//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   Map<String, dynamic>? get _latestRecord {
//     if (_records.isEmpty) return null;

//     return Map<String, dynamic>.from(_records.first as Map);
//   }

//   String _metricValue(String key, String suffix) {
//     final record = _latestRecord;

//     if (record == null) return 'No data yet';

//     final value = record[key];

//     if (value == null) return 'No data yet';

//     return '$value$suffix';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final player = widget.session.user;

//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1929),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A1929),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'FitLink',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             tooltip: 'Log out',
//             onPressed: () => _logout(context),
//             icon: const Icon(Icons.logout_rounded),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 600),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Text(
//                     'YOUR FITNESS JOURNEY',
//                     style: TextStyle(
//                       color: Color(0xFF75B8FF),
//                       letterSpacing: 1.5,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Welcome, ${player.username}!',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 27,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Track your activity and stay connected.',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 28),

//                   // Player account
//                   _panel(
//                     child: Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 28,
//                           backgroundColor: Color(0xFF294764),
//                           child: Icon(
//                             Icons.person_rounded,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 player.username,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 17,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 player.email,
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Wearable readings
//                   _panel(
//                     child: Column(
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                       children: [
//                         const Row(
//                           children: [
//                             Icon(
//                               Icons.watch_rounded,
//                               color: Color(0xFF75B8FF),
//                               size: 28,
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 'My Wearable',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 14),

//                         if (_isLoading)
//                           const Padding(
//                             padding: EdgeInsets.all(20),
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 color: Color(0xFF75B8FF),
//                               ),
//                             ),
//                           )
//                         else if (_error != null)
//                           Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             children: [
//                               const Icon(
//                                 Icons.error_outline,
//                                 color: Colors.orangeAccent,
//                                 size: 28,
//                               ),
//                               const SizedBox(height: 8),
//                               const Text(
//                                 'Could not load wearable data.',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 _error!,
//                                 style: const TextStyle(
//                                   color: Colors.orangeAccent,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               _syncButton(),
//                             ],
//                           )
//                         else if (_latestRecord == null)
//                           const Text(
//                             'No wearable records found for this player. '
//                             'Send data from your watch, then sync again.',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               height: 1.5,
//                             ),
//                           )
//                         else ...[
//                           const Text(
//                             'Latest recorded activity',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 13,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           const Divider(
//                             color: Color(0xFF294764),
//                           ),
//                           _metric(
//                             icon: Icons.favorite_outline,
//                             label: 'Heart rate',
//                             value: _metricValue('heartRate', ' BPM'),
//                           ),
//                           _metric(
//                             icon: Icons.directions_walk_rounded,
//                             label: 'Steps',
//                             value: _metricValue('steps', ''),
//                           ),
//                           _metric(
//                             icon: Icons.local_fire_department_outlined,
//                             label: 'Calories',
//                             value: _metricValue('calories', ' kcal'),
//                           ),
//                         ],

//                         const SizedBox(height: 16),
//                         if (_error == null) _syncButton(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _syncButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: _isLoading ? null : _loadWearableData,
//         icon: const Icon(Icons.sync_rounded),
//         label: Text(_isLoading ? 'Loading...' : 'Sync Now'),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF75B8FF),
//           foregroundColor: const Color(0xFF0A1929),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _panel({required Widget child}) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF132F4C),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: const Color(0xFF294764),
//         ),
//       ),
//       child: child,
//     );
//   }

//   Widget _metric({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 9),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: const Color(0xFF75B8FF),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white70,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _logout(BuildContext context) {
//     context.read<AuthCubit>().reset();

//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(
//         builder: (_) => const LoginScreen(),
//       ),
//       (route) => false,
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../../core/models/user.dart';
import '../../services/wearable_service.dart';
import '../auth/cubit/auth_cubit.dart';
import '../auth/screens/login_screen.dart';
import 'package:player_app/core/service/api_service.dart';

// import 'dart:async';
// import 'package:watch_connectivity/watch_connectivity.dart';

class PlayerHomeScreen extends StatefulWidget {
  final UserSession session;

  const PlayerHomeScreen({
    super.key,
    required this.session,
  });

  @override
  State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends State<PlayerHomeScreen> {
  final WearableService _wearableService = WearableService();
  final WatchConnectivity _watchConnectivity = WatchConnectivity();

  StreamSubscription<dynamic>? _messageSubscription;

  List<dynamic> _records = [];
  final List<Map<String, dynamic>> _pendingWorkouts = [];
  Map<String, dynamic>? _latestWatchWorkout;
  bool _isLoading = false;
  String? _error;
  String _watchStatus = 'Waiting for watch data';

  final ApiService _apiService = ApiService();

List<dynamic> _assignedSessions = [];
bool _sessionsLoading = false;
String? _sessionsError;

  @override
  void initState() {
    super.initState();

    // Start listening while the dashboard is open.
    debugPrint('PHONE RECEIVER INITIALIZED');

    _messageSubscription = _watchConnectivity.messageStream.listen(
      _handleWatchMessage,
      onError: (error) {
        debugPrint('WATCH MESSAGE ERROR: $error');

        if (mounted) {
          setState(() {
            _watchStatus = 'Watch connection error';
          });
        }
      },
    );

    _loadWearableData();
    _loadAssignedSessions();
  }

Widget _assignedWorkoutsPanel() {
  return _panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.fitness_center_rounded,
              color: Color(0xFF75B8FF),
              size: 26,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Assigned Workouts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (_sessionsLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: Color(0xFF75B8FF),
              ),
            ),
          )
        else if (_sessionsError != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _sessionsError!,
                style: const TextStyle(
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _loadAssignedSessions,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          )
        else if (_assignedSessions.isEmpty)
          const Text(
            'No assigned workouts yet. Your coach must '
            'publish a training session assigned to you.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          )
        else
          ..._assignedSessions.map((rawSession) {
            final session =
                Map<String, dynamic>.from(rawSession as Map);

            final workouts = session['workouts'] is List
                ? session['workouts'] as List
                : <dynamic>[];

            final participation =
                session['participation'] is Map
                    ? Map<String, dynamic>.from(
                        session['participation'] as Map,
                      )
                    : <String, dynamic>{};

            final status =
                (participation['status'] ??
                        session['status'] ??
                        'ASSIGNED')
                    .toString();

            final scheduledAt =
                DateTime.tryParse(
                  (session['scheduledAt'] ?? '').toString(),
                );

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1929),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF294764),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (session['name'] ?? 'Training Session')
                        .toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Status: $status',
                    style: const TextStyle(
                      color: Color(0xFF75B8FF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (scheduledAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Scheduled: ${scheduledAt.toLocal().toString().substring(0, 16)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],

                  if ((session['description'] ?? '')
                      .toString()
                      .trim()
                      .isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      session['description'].toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFF294764)),

                  if (workouts.isEmpty)
                    const Text(
                      'No exercises listed in this session.',
                      style: TextStyle(color: Colors.white70),
                    )
                  else
                    ...workouts.map((rawWorkout) {
                      final workout =
                          Map<String, dynamic>.from(
                        rawWorkout as Map,
                      );

                      final name =
                          (workout['name'] ?? 'Exercise')
                              .toString();

                      final sets = workout['sets'];
                      final reps = workout['reps'];
                      final duration =
                          workout['durationSeconds'];

                      final details = <String>[];

                      if (sets != null) {
                        details.add('$sets sets');
                      }
                      if (reps != null) {
                        details.add('$reps reps');
                      }
                      if (duration != null) {
                        details.add('${duration}s');
                      }
                     
return Padding(
  padding: const EdgeInsets.symmetric(vertical: 8),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(
        Icons.check_circle_outline,
        color: Color(0xFF75B8FF),
        size: 20,
      ),
      const SizedBox(width: 10),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${workout['order'] ?? ''}'
              '${workout['order'] != null ? '. ' : ''}'
              '$name',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (details.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                details.join(' · '),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),

      const SizedBox(width: 4),

      IconButton(
        tooltip: 'Start this workout on watch',
        onPressed: () {
          _sendAssignedWorkout(
            session: session,
            workout: workout,
          );
        },
        icon: const Icon(
          Icons.play_circle_fill_rounded,
          color: Color(0xFF75B8FF),
          size: 30,
        ),
      ),
    ],
  ),
);

                      // return Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 8,
                      //   ),
                      //   child: Row(
                      //     crossAxisAlignment:
                      //         CrossAxisAlignment.start,
                      //     children: [
                      //       const Icon(
                      //         Icons.check_circle_outline,
                      //         color: Color(0xFF75B8FF),
                      //         size: 20,
                      //       ),
                      //       const SizedBox(width: 10),
                      //       Expanded(
                      //         child: Column(
                      //           crossAxisAlignment:
                      //               CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               '${workout['order'] ?? ''}'
                      //               '${workout['order'] != null ? '. ' : ''}'
                      //               '$name',
                      //               style: const TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight:
                      //                     FontWeight.w600,
                      //               ),
                      //             ),
                      //             if (details.isNotEmpty) ...[
                      //               const SizedBox(height: 4),
                      //               Text(
                      //                 details.join(' · '),
                      //                 style: const TextStyle(
                      //                   color: Colors.white70,
                      //                   fontSize: 12,
                      //                 ),
                      //               ),
                      //             ],
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // );
                    }),
                ],
              ),
            );
          }),

        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _sessionsLoading
                ? null
                : _loadAssignedSessions,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh Assigned Workouts'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF75B8FF),
              side: const BorderSide(
                color: Color(0xFF294764),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 13,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _sendAssignedWorkout({
  required Map<String, dynamic> session,
  required Map<String, dynamic> workout,
}) async {
  final exerciseName =
      (workout['name'] ?? 'Exercise').toString();

  try {
    setState(() {
      _watchStatus = 'Sending $exerciseName to watch...';
    });

    await _watchConnectivity.sendMessage({
      'type': 'start_workout',
      'playerId': widget.session.user.userId,
      'sessionId': session['sessionId'],
      'workoutId': workout['workoutId'],
      'exerciseName': exerciseName,
      'exerciseType': workout['exerciseType'],
      'sets': workout['sets'],
      'reps': workout['reps'],
      'durationSeconds': workout['durationSeconds'],
    });

    if (!mounted) return;

    setState(() {
      _watchStatus = '$exerciseName sent to watch.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$exerciseName sent to watch'),
      ),
    );
  } catch (e) {
    debugPrint('SEND ASSIGNED WORKOUT ERROR: $e');

    if (!mounted) return;

    setState(() {
      _watchStatus = 'Could not send exercise to watch.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Could not send workout. Check watch connectivity.',
        ),
      ),
    );
  }
}

  void _handleWatchMessage(dynamic message) {
    debugPrint('WATCH MESSAGE RECEIVED: $message');

    if (message is! Map) {
      debugPrint('Invalid watch message format');
      return;
    }

    final incoming = Map<String, dynamic>.from(message);

    if (incoming['type'] != 'workout_sync') {
      if (mounted) {
        setState(() {
          _watchStatus = 'Received a test message, not workout data';
        });
      }
      return;
    }

    if (incoming['heartRate'] is! num ||
        incoming['steps'] is! num ||
        incoming['calories'] is! num) {
      if (mounted) {
        setState(() {
          _watchStatus = 'Workout data is incomplete';
        });
      }
      return;
    }

    // Use the currently signed-in player's ID.
    incoming['playerId'] = widget.session.user.userId;

    final syncId = incoming['syncId'];

    final alreadyPending = syncId is String &&
        _pendingWorkouts.any(
          (item) => item['syncId'] == syncId,
        );

    if (!mounted) return;

    // setState(() {
    //   if (!alreadyPending) {
    //     _pendingWorkouts.add(incoming);
    //   }

    //   _watchStatus = alreadyPending
    //       ? 'Workout is already waiting to sync'
    //       : 'Workout received! Ready to sync';
    // });
    setState(() {
  // Display the watch data immediately.
  _latestWatchWorkout = incoming;

  // Keep a copy for Sync Now.
  if (!alreadyPending) {
    _pendingWorkouts.add(incoming);
  }

  _watchStatus = 'Watch data received!';
});
  }

  Future<void> _loadWearableData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final playerId = widget.session.user.userId;

      debugPrint('Fetching wearable data for: $playerId');

      final records =
          await _wearableService.getWearableData(playerId);

      records.sort((a, b) {
        final dateA = DateTime.tryParse(
              (a['recordedAt'] ?? '').toString(),
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

        final dateB = DateTime.tryParse(
              (b['recordedAt'] ?? '').toString(),
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

        return dateB.compareTo(dateA);
      });

      if (!mounted) return;

      setState(() {
        _records = records;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('WEARABLE FETCH ERROR: $e');

      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


// Future<void> _loadAssignedSessions() async {
//   if (!mounted) return;

//   setState(() {
//     _sessionsLoading = true;
//     _sessionsError = null;
//   });

//   try {
//     final result = await _apiService.getPlayerSessions(
//       accessToken: widget.session.accessToken,
//     );

//     final items = result['items'];

//     if (items is! List) {
//       throw Exception('Invalid assigned sessions response.');
//     }

//     if (!mounted) return;

//     setState(() {
//       _assignedSessions = items;
//     });
//   } catch (e) {
//     if (!mounted) return;

//     setState(() {
//       _sessionsError = e.toString().replaceFirst(
//         'Exception: ',
//         '',
//       );
//     });
//   } finally {
//     if (mounted) {
//       setState(() {
//         _sessionsLoading = false;
//       });
//     }
//   }
// }

Future<void> _loadAssignedSessions() async {
  if (!mounted) return;

  setState(() {
    _sessionsLoading = true;
    _sessionsError = null;
  });

  try {
    final result = await _apiService.getPlayerSessions(
      accessToken: widget.session.accessToken,
    );

    // The backend response contains: { success: true, data: { items: [...] } }
    final data = result['data'];

    if (data is! Map) {
      throw Exception('Invalid response: missing data.');
    }

    final items = data['items'];

    if (items is! List) {
      throw Exception('Invalid response: items is not a list.');
    }

    if (!mounted) return;

    setState(() {
      _assignedSessions = items;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _sessionsError = e.toString().replaceFirst(
        'Exception: ',
        '',
      );
    });
  } finally {
    if (mounted) {
      setState(() {
        _sessionsLoading = false;
      });
    }
  }
}


  Future<void> _syncNow() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Upload workouts received from the watch.
      while (_pendingWorkouts.isNotEmpty) {
        final workout = _pendingWorkouts.first;

        await _wearableService.sendWearableData(
          playerId: widget.session.user.userId,
          heartRate: (workout['heartRate'] as num).toInt(),
          steps: (workout['steps'] as num).toInt(),
          calories: (workout['calories'] as num).toDouble(),
        );

        // Remove only after the upload succeeds.
        if (!mounted) return;

        setState(() {
          _pendingWorkouts.removeAt(0);
        });
      }

      // Fetch the latest records saved on the backend.
      final playerId = widget.session.user.userId;

      final records =
          await _wearableService.getWearableData(playerId);

      records.sort((a, b) {
        final dateA = DateTime.tryParse(
              (a['recordedAt'] ?? '').toString(),
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

        final dateB = DateTime.tryParse(
              (b['recordedAt'] ?? '').toString(),
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

        return dateB.compareTo(dateA);
      });

      if (!mounted) return;

      setState(() {
        _records = records;
        _isLoading = false;
        _watchStatus = 'Sync complete';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout data synced successfully'),
        ),
      );
    } catch (e) {
      debugPrint('WORKOUT SYNC ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString();
        _watchStatus = 'Sync failed. Pending data retained.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sync failed: $e'),
        ),
      );
    }
  }

  // Map<String, dynamic>? get _latestRecord {
  //   // Show newly received readings before they reach the backend.
  //   if (_pendingWorkouts.isNotEmpty) {
  //     return _pendingWorkouts.last;
  //   }

  //   if (_records.isEmpty) return null;

  //   return Map<String, dynamic>.from(_records.first as Map);
  // }
  Map<String, dynamic>? get _latestRecord {
  return _latestWatchWorkout;
}

  String _metricValue(String key, String suffix) {
    final record = _latestRecord;
    if (record == null || record[key] == null) {
      return 'No data yet';
    }

    return '${record[key]}$suffix';
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.session.user;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1929),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'FitLink',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'YOUR FITNESS JOURNEY',
                    style: TextStyle(
                      color: Color(0xFF75B8FF),
                      letterSpacing: 1.5,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome, ${player.username}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Track your activity and stay connected.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 28),

                  _panel(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFF294764),
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                player.email,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                      
                  _panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.watch_rounded,
                              color: Color(0xFF75B8FF),
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'My Wearable',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 20),
                        _assignedWorkoutsPanel(),

                        Text(
                          _watchStatus,
                          style: const TextStyle(
                            color: Color(0xFF75B8FF),
                            fontSize: 12,
                          ),
                        ),

                        if (_pendingWorkouts.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            '${_pendingWorkouts.length} workout(s) waiting to sync',
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],

                        const SizedBox(height: 14),

                        if (_isLoading && _latestRecord == null)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                color: Color(0xFF75B8FF),
                              ),
                            ),
                          )
                        else if (_error != null &&
                            _latestRecord == null)
                          Text(
                            'Could not load data: $_error',
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                            ),
                          )
                        else if (_latestRecord == null)
                          const Text(
                            'No wearable records yet. Send a workout '
                            'from your watch, then tap Sync Now.',
                            style: TextStyle(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          )
                        else ...[
                          Text(
                            _pendingWorkouts.isNotEmpty
                                ? 'Latest received workout'
                                : 'Latest recorded activity',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(
                            color: Color(0xFF294764),
                          ),
                          _metric(
                            icon: Icons.favorite_outline,
                            label: 'Heart rate',
                            value: _metricValue('heartRate', ' BPM'),
                          ),
                          _metric(
                            icon: Icons.directions_walk_rounded,
                            label: 'Steps',
                            value: _metricValue('steps', ''),
                          ),
                          _metric(
                            icon: Icons.local_fire_department_outlined,
                            label: 'Calories',
                            value: _metricValue('calories', ' kcal'),
                          ),
                        ],

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _syncNow,
                            icon: const Icon(Icons.sync_rounded),
                            label: Text(
                              _isLoading
                                  ? 'Syncing...'
                                  : _pendingWorkouts.isEmpty
                                      ? 'Sync Now'
                                      : 'Sync ${_pendingWorkouts.length} Workout(s)',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF75B8FF),
                              foregroundColor: const Color(0xFF0A1929),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF132F4C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF294764),
        ),
      ),
      child: child,
    );
  }

  Widget _metric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF75B8FF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<AuthCubit>().reset();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}
