part of 'coach_cubit_cubit.dart';

abstract class CoachCubitState {}

class CoachCubitInitial extends CoachCubitState {}

class CoachLoading extends CoachCubitState {}

// Dashboard
class CoachDashboardSuccessState extends CoachCubitState {
  final CoachDashboardModel data;

  CoachDashboardSuccessState({required this.data});
}

// Players
class CoachPlayersSuccessState extends CoachCubitState {
  final Map<String, dynamic> data;

  CoachPlayersSuccessState({required this.data});
}

// Player statistics
class CoachPlayerStatisticsSuccessState extends CoachCubitState {
  final Map<String, dynamic> data;

  CoachPlayerStatisticsSuccessState({required this.data});
}

// Sport distribution
class CoachSportDistributionSuccessState extends CoachCubitState {
  final Map<String, dynamic> data;

  CoachSportDistributionSuccessState({required this.data});
}

// Player search
class CoachSearchPlayersSuccessState extends CoachCubitState {
  final Map<String, dynamic> data;

  CoachSearchPlayersSuccessState({required this.data});
}

// Add player
class CoachAddPlayerSuccessState extends CoachCubitState {
  final Map<String, dynamic> data;

  CoachAddPlayerSuccessState({required this.data});
}

// Remove player
class CoachRemovePlayerSuccessState extends CoachCubitState {
  final Map<String, dynamic> data;

  CoachRemovePlayerSuccessState({required this.data});
}

// Error
class CoachError extends CoachCubitState {
  final String message;

  CoachError(this.message);
}
