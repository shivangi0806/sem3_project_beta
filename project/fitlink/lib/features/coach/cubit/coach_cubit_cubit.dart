import 'package:bloc/bloc.dart';
import 'package:fitlink/core/services/coach_service.dart';
import 'package:fitlink/features/coach/data/model/coach_dashboard_model.dart';

part 'coach_cubit_state.dart';

class CoachCubitCubit extends Cubit<CoachCubitState> {
  final CoachService apiService;

  CoachCubitCubit(this.apiService) : super(CoachCubitInitial());

  // Fetch coach dashboard
  Future<void> getDashboardData({required String token}) async {
    emit(CoachLoading());

    try {
      final dashboard = await apiService.getDashboard(token: token);

      emit(CoachDashboardSuccessState(data: dashboard));
    } on CoachApiException catch (e) {
      emit(CoachError(e.message));
    } catch (e) {
      emit(CoachError(e.toString()));
    }
  }

  // Fetch coach players
  Future<void> getPlayers({
    required String token,
    int page = 1,
    int limit = 20,
    String? search,
    String? sport,
    bool? isActive,
  }) async {
    emit(CoachLoading());

    try {
      final response = await apiService.getPlayers(
        token: token,
        page: page,
        limit: limit,
        search: search,
        sport: sport,
        isActive: isActive,
      );

      emit(CoachPlayersSuccessState(data: response));
    } on CoachApiException catch (e) {
      emit(CoachError(e.message));
    } catch (e) {
      emit(CoachError(e.toString()));
    }
  }

  // Fetch player statistics
  Future<void> getPlayerStatistics({required String token}) async {
    emit(CoachLoading());

    try {
      final response = await apiService.getPlayerStatistics(token: token);

      emit(CoachPlayerStatisticsSuccessState(data: response));
    } on CoachApiException catch (e) {
      emit(CoachError(e.message));
    } catch (e) {
      emit(CoachError(e.toString()));
    }
  }

  // Fetch sport distribution
  Future<void> getSportDistribution({required String token}) async {
    emit(CoachLoading());

    try {
      final response = await apiService.getSportDistribution(token: token);

      emit(CoachSportDistributionSuccessState(data: response));
    } on CoachApiException catch (e) {
      emit(CoachError(e.message));
    } catch (e) {
      emit(CoachError(e.toString()));
    }
  }

  // Search available players
  Future<void> searchPlayers({
    required String token,
    required String query,
  }) async {
    emit(CoachLoading());

    try {
      final response = await apiService.searchPlayers(
        token: token,
        query: query,
      );

      emit(CoachSearchPlayersSuccessState(data: response));
    } on CoachApiException catch (e) {
      emit(CoachError(e.message));
    } catch (e) {
      emit(CoachError(e.toString()));
    }
  }

  // Add player to coach roster
  Future<void> addPlayer({
    required String token,
    required String userId,
  }) async {
    emit(CoachLoading());

    try {
      final response = await apiService.addPlayer(token: token, userId: userId);

      emit(CoachAddPlayerSuccessState(data: response));
    } on CoachApiException catch (e) {
      emit(CoachError(e.message));
    } catch (e) {
      emit(CoachError(e.toString()));
    }
  }

  // Remove player from coach roster
  Future<void> removePlayer({
    required String token,
    required String playerId,
  }) async {
    emit(CoachLoading());

    try {
      final response = await apiService.removePlayer(
        token: token,
        playerId: playerId,
      );

      emit(CoachRemovePlayerSuccessState(data: response));
    } on CoachApiException catch (e) {
      emit(CoachError(e.message));
    } catch (e) {
      emit(CoachError(e.toString()));
    }
  }
}
