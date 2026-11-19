import 'package:equatable/equatable.dart';
import 'package:fitlink/core/model/WearableExcecutionModel.dart';

//import '../models/wearable_execution_model.dart';

abstract class WearableState extends Equatable {
  const WearableState();

  @override
  List<Object?> get props => [];
}

class WearableInitial extends WearableState {}

class WearableLoading extends WearableState {}

class WearableDataLoaded extends WearableState {
  final List<dynamic> wearableData;

  const WearableDataLoaded(this.wearableData);

  @override
  List<Object?> get props => [wearableData];
}

class LatestWearableDataLoaded extends WearableState {
  final WearableExecutionModel latestData;

  const LatestWearableDataLoaded(this.latestData);

  @override
  List<Object?> get props => [latestData];
}

class WearableDataSent extends WearableState {
  final Map<String, dynamic> response;

  const WearableDataSent(this.response);

  @override
  List<Object?> get props => [response];
}

class WearableError extends WearableState {
  final String message;

  const WearableError(this.message);

  @override
  List<Object?> get props => [message];
}
