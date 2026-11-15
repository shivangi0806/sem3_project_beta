import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitlink/core/services/coach_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._coachService) : super(const DashboardInitial()) {
    on<DashboardRequested>(_onDashboardRequested);
  }

  final CoachService _coachService;

  Future<void> _onDashboardRequested(
    DashboardRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    try {
      final dashboard = await _coachService.getDashboard(token: event.token);
      emit(DashboardSuccess(dashboard: dashboard));
    } catch (error) {
      emit(DashboardError(error.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<void> close() {
    _coachService.dispose();
    return super.close();
  }
}
