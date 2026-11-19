import 'package:fitlink/core/services/wearable_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import '../services/wearable_service.dart';
import 'wearable_event.dart';
import 'wearable_state.dart';

class WearableBloc extends Bloc<WearableEvent, WearableState> {
  final WearableService wearableService;

  WearableBloc({required this.wearableService}) : super(WearableInitial()) {
    on<GetWearableDataEvent>(_getWearableData);
    on<GetLatestWearableDataEvent>(_getLatestWearableData);
    on<SendWearableDataEvent>(_sendWearableData);
    on<GetWearableMultipleDataEvent>((event, emit) async {
      emit(WearableLoading());

      try {
        final result = await wearableService.getWearableData(event.playerId);

        emit(WearableDataLoaded(result));
      } catch (e) {
        emit(WearableError(e.toString()));
      }
    });
    // on<GetWearableMultipleDataEvent>(e)
  }

  // Fetch all wearable executions
  Future<void> _getWearableData(
    GetWearableDataEvent event,
    Emitter<WearableState> emit,
  ) async {
    emit(WearableLoading());

    try {
      final data = await wearableService.getWearableData(event.playerId);

      emit(WearableDataLoaded(data));
    } catch (e) {
      emit(WearableError(e.toString()));
    }
  }

  // Fetch latest wearable execution
  Future<void> _getLatestWearableData(
    GetLatestWearableDataEvent event,
    Emitter<WearableState> emit,
  ) async {
    emit(WearableLoading());

    try {
      final data = await wearableService.getLatestWearableData(event.playerId);

      emit(LatestWearableDataLoaded(data));
    } catch (e) {
      emit(WearableError(e.toString()));
    }
  }

  // Send wearable data
  Future<void> _sendWearableData(
    SendWearableDataEvent event,
    Emitter<WearableState> emit,
  ) async {
    emit(WearableLoading());

    try {
      final response = await wearableService.sendWearableData(
        playerId: event.playerId,
        heartRate: event.heartRate,
        steps: event.steps,
        calories: event.calories,
      );

      emit(WearableDataSent(response));
    } catch (e) {
      emit(WearableError(e.toString()));
    }
  }
}
