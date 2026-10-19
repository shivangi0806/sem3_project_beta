
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:watch_connectivity/watch_connectivity.dart';

// class WatchConnectionScreen extends StatefulWidget {
//   const WatchConnectionScreen({super.key});

//   @override
//   State<WatchConnectionScreen> createState() =>
//       _WatchConnectionScreenState();
// }

// class _WatchConnectionScreenState
//     extends State<WatchConnectionScreen> {
//   final WatchConnectivity _watchConnectivity = WatchConnectivity();

//   StreamSubscription<dynamic>? _messageSubscription;

//   String _status = 'Waiting for watch message...';
//   Map<String, dynamic>? _receivedMessage;

//   @override
//   void initState() {
//     super.initState();

//     _messageSubscription =
//         _watchConnectivity.messageStream.listen(
//       (message) {
//         if (!mounted) return;

//         setState(() {
//           _receivedMessage = Map<String, dynamic>.from(message);
//           _status = 'Message received successfully!';
//         });

//         debugPrint('WATCH MESSAGE RECEIVED: $message');
//       },
//       onError: (error) {
//         debugPrint('WATCH MESSAGE ERROR: $error');
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _messageSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('FitLink Watch Connection'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _status,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text('Latest watch message:'),
//             const SizedBox(height: 12),
//             SelectableText(
//               _receivedMessage?.toString() ??
//                   'No message received yet.',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:player_app/services/wearable_service.dart';

class WatchConnectionScreen extends StatefulWidget {
  const WatchConnectionScreen({super.key});

  @override
  State<WatchConnectionScreen> createState() =>
      _WatchConnectionScreenState();
}

class _WatchConnectionScreenState
    extends State<WatchConnectionScreen> {
  final WatchConnectivity _watchConnectivity = WatchConnectivity();
  final WearableService _wearableService = WearableService();

  StreamSubscription<dynamic>? _messageSubscription;

  String _status = 'Waiting for watch workout data...';
  Map<String, dynamic>? _receivedMessage;

  // Workout readings waiting to be uploaded.
  final List<Map<String, dynamic>> _pendingWorkouts = [];

  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();

    _messageSubscription =
        _watchConnectivity.messageStream.listen(
      _handleWatchMessage,
      onError: (error) {
        debugPrint('WATCH MESSAGE ERROR: $error');

        if (!mounted) return;
        setState(() {
          _status = 'Error receiving watch data.';
        });
      },
    );
  }

  void _handleWatchMessage(dynamic message) {
    if (message is! Map) {
      debugPrint('Invalid watch message: $message');
      return;
    }

    final incoming = Map<String, dynamic>.from(message);
    debugPrint('WATCH MESSAGE RECEIVED: $incoming');

    if (!mounted) return;

    // Ignore connection tests for workout syncing.
    if (incoming['type'] != 'workout_sync') {
      setState(() {
        _receivedMessage = incoming;
        _status = 'Watch message received (not workout data).';
      });
      return;
    }

    // Validate the fields before accepting the workout.
    if (incoming['playerId'] is! String ||
        incoming['heartRate'] is! num ||
        incoming['steps'] is! num ||
        incoming['calories'] is! num) {
      setState(() {
        _status = 'Workout message is missing valid data.';
        _receivedMessage = incoming;
      });
      return;
    }

    // Avoid adding the same message twice when it has a syncId.
    final syncId = incoming['syncId'];
    final alreadyPending = syncId is String &&
        _pendingWorkouts.any(
          (item) => item['syncId'] == syncId,
        );

    setState(() {
      _receivedMessage = incoming;

      if (!alreadyPending) {
        _pendingWorkouts.add(incoming);
      }

      _status = alreadyPending
          ? 'Workout already waiting to sync.'
          : 'Workout received! Ready to sync.';
    });
  }

  Future<void> _syncNow() async {
    if (_isSyncing || _pendingWorkouts.isEmpty) return;

    setState(() {
      _isSyncing = true;
      _status = 'Syncing workout data...';
    });

    int syncedCount = 0;

    try {
      while (_pendingWorkouts.isNotEmpty) {
        final workout = _pendingWorkouts.first;

        try {
          final result = await _wearableService.sendWearableData(
            playerId: workout['playerId'] as String,
            heartRate: (workout['heartRate'] as num).round(),
            steps: (workout['steps'] as num).round(),
            calories: (workout['calories'] as num).toDouble(),
          );

          debugPrint('PHONE BACKEND RESPONSE: $result');

          if (!mounted) return;

          // Remove the reading only after the API confirms success.
          setState(() {
            _pendingWorkouts.removeAt(0);
            syncedCount++;
          });
        } catch (error) {
          debugPrint('WORKOUT SYNC FAILED: $error');

          if (!mounted) return;

          setState(() {
            _status =
                'Sync failed. $syncedCount uploaded; '
                '${_pendingWorkouts.length} still pending. Try again.';
          });

          return;
        }
      }

      if (!mounted) return;

      setState(() {
        _status = syncedCount == 0
            ? 'No pending workouts.'
            : 'Successfully synced $syncedCount workout(s)!';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _receivedMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitLink Workout Sync'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _status,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: data == null
                      ? const Text('No watch data received yet.')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Latest watch readings',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text('Player ID: ${data['playerId'] ?? '--'}'),
                            Text('Heart rate: ${data['heartRate'] ?? '--'} BPM'),
                            Text('Steps: ${data['steps'] ?? '--'}'),
                            Text('Calories: ${data['calories'] ?? '--'} kcal'),
                            if (data['recordedAt'] != null)
                              Text('Recorded at: ${data['recordedAt']}'),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              Text('Pending workouts: ${_pendingWorkouts.length}'),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSyncing || _pendingWorkouts.isEmpty
                      ? null
                      : _syncNow,
                      
                  child: Text(
                    _isSyncing ? 'Syncing...' : 'SYNC NOW',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
