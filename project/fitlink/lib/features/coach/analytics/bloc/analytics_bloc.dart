import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/analytics_model.dart';
import '../services/analytics_service.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc(this._service) : super(const AnalyticsInitial()) {
    on<AnalyticsReportRequested>(_onReportRequested);
    on<AnalyticsReportCleared>((event, emit) {
      _requestGeneration++;
      _log('Report cleared; pending older requests will be ignored.');
      emit(const AnalyticsInitial());
    });
  }

  final AnalyticsService _service;
  int _requestGeneration = 0;

  Future<void> _onReportRequested(
    AnalyticsReportRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    final generation = ++_requestGeneration;
    _log('Request #$generation received (period=${event.period}, '
        'startDate=${event.startDate ?? 'default'}, endDate=${event.endDate ?? 'default'}, '
        'timezone=${event.timezone}, groupBy=${event.groupBy ?? 'default'}).');
    emit(const AnalyticsLoading());
    _log('Request #$generation state: Loading.');
    try {
      final response = await _service.getPlayerReport(
        token: event.token,
        playerId: event.playerId,
        period: event.period,
        startDate: event.startDate,
        endDate: event.endDate,
        timezone: event.timezone,
        groupBy: event.groupBy,
      );
      if (generation != _requestGeneration) {
        _log('Request #$generation completed after a newer selection; ignoring stale data.');
        return;
      }
      final report = AnalyticsModel.fromJson(response);
      _log('Request #$generation state: Success for player ${report.playerId}.');
      emit(AnalyticsSuccess(analyticsModel: report));
    } catch (error, stackTrace) {
      if (generation != _requestGeneration) {
        _log('Request #$generation failed after a newer selection; ignoring stale error: $error');
        return;
      }
      _log('Request #$generation state: Error; $error\n$stackTrace');
      emit(AnalyticsError(error.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[AnalyticsBloc] $message');
  }

  @override
  Future<void> close() {
    _service.dispose();
    return super.close();
  }
}
