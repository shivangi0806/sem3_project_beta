import 'package:fitlink/features/coach/cubit/coach_roster_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitlink/features/coach/widgets/container.dart';
import 'package:fitlink/features/coach/bloc/wearable_bloc.dart';
import 'package:fitlink/features/coach/bloc/wearable_event.dart';
import 'package:fitlink/features/coach/bloc/wearable_state.dart';
import 'package:fitlink/core/services/wearable_service.dart';

class CoachDashboardScreenSection extends StatelessWidget {
  CoachDashboardScreenSection({super.key});
  final WearableService service = WearableService();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachRosterCubit, CoachRosterState>(
      builder: (context, rosterState) {
        if (rosterState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (rosterState.roster.isEmpty) {
          return const Center(child: Text('No players available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: rosterState.roster.map((player) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: BlocProvider(
                  key: ValueKey(player.playerId),
                  create: (context) => WearableBloc(
                    wearableService: service,
                    //context.read<WearableService>(),
                  )..add(GetWearableMultipleDataEvent(player.playerId)),
                  child: PlayerWearableSection(
                    playerId: player.playerId,
                    playerName: player.username,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class PlayerWearableSection extends StatelessWidget {
  final String playerId;
  final String playerName;

  const PlayerWearableSection({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WearableBloc, WearableState>(
      builder: (context, state) {
        if (state is WearableLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state is WearableError) {
          return Card(
            child: ListTile(
              title: Text(playerName),
              subtitle: Text(state.message),
              trailing: IconButton(
                onPressed: () {
                  context.read<WearableBloc>().add(
                    GetWearableMultipleDataEvent(playerId),
                  );
                },
                icon: const Icon(Icons.refresh),
              ),
            ),
          );
        }

        if (state is WearableDataLoaded) {
          final records = state.wearableData;

          if (records.isEmpty) {
            return _emptyState();
          }

          // Sort newest execution first.
          final sortedRecords =
              records
                  .whereType<Map>()
                  .map((record) => Map<String, dynamic>.from(record))
                  .toList()
                ..sort((a, b) {
                  final dateA =
                      DateTime.tryParse('${a['startedAt'] ?? ''}') ??
                      DateTime(1970);

                  final dateB =
                      DateTime.tryParse('${b['startedAt'] ?? ''}') ??
                      DateTime(1970);

                  return dateB.compareTo(dateA);
                });

          final latest = sortedRecords.first;
          final metrics = Map<String, dynamic>.from(
            latest['metrics'] is Map ? latest['metrics'] : {},
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main player dashboard card
              DashboardContainer(
                name: playerName,
                playerId: playerId,
                bpm: '${metrics['averageHeartRateBpm'] ?? 0}',
                steps: '${metrics['steps'] ?? 0}',
                calories: '${metrics['calories'] ?? 0}',
                width: MediaQuery.sizeOf(context).width - 32,
                height: 450,
                child: const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              // Execution history heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wearable Execution History',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${sortedRecords.length} Records',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // All execution records
              ...sortedRecords.map((record) {
                return _executionCard(record);
              }),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _executionCard(Map<String, dynamic> record) {
    final metrics = record['metrics'] is Map
        ? Map<String, dynamic>.from(record['metrics'])
        : <String, dynamic>{};

    final startedAt = DateTime.tryParse('${record['startedAt'] ?? ''}');

    final formattedDate = startedAt == null
        ? 'Date unavailable'
        : '${startedAt.day}/${startedAt.month}/${startedAt.year}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.watch, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${record['executionId'] ?? 'Execution'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const Divider(),

            Wrap(
              spacing: 16,
              runSpacing: 10,
              children: [
                _metric('Steps', '${metrics['steps'] ?? 0}'),
                _metric('Calories', '${metrics['calories'] ?? 0} kcal'),
                _metric(
                  'Heart Rate',
                  '${metrics['averageHeartRateBpm'] ?? 0} BPM',
                ),
                _metric('Distance', '${metrics['distanceMeters'] ?? 0} m'),
                _metric('Duration', '${metrics['durationSeconds'] ?? 0} sec'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) {
    return SizedBox(
      width: 105,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.watch_off_outlined),
        title: Text(playerName),
        subtitle: const Text('No wearable execution records available'),
      ),
    );
  }
}
