import 'package:equatable/equatable.dart';

abstract class WearableEvent extends Equatable {
  const WearableEvent();

  @override
  List<Object?> get props => [];
}

class GetWearableMultipleDataEvent extends WearableEvent {
  final String playerId;

  const GetWearableMultipleDataEvent(this.playerId);
}

// Fetch all wearable executions
class GetWearableDataEvent extends WearableEvent {
  final String playerId;

  const GetWearableDataEvent(this.playerId);

  @override
  List<Object?> get props => [playerId];
}

// Fetch latest wearable execution
class GetLatestWearableDataEvent extends WearableEvent {
  final String playerId;

  const GetLatestWearableDataEvent(this.playerId);

  @override
  List<Object?> get props => [playerId];
}

// Send wearable data
class SendWearableDataEvent extends WearableEvent {
  final String playerId;
  final int heartRate;
  final int steps;
  final double calories;

  const SendWearableDataEvent({
    required this.playerId,
    required this.heartRate,
    required this.steps,
    required this.calories,
  });

  @override
  List<Object?> get props => [playerId, heartRate, steps, calories];
}
