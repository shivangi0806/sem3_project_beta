part of 'coach_cubit_cubit.dart';

@immutable
abstract class CoachCubitState {}

final class CoachCubitInitial extends CoachCubitState {}

class CoachInitial extends CoachCubitState{}

class CoachLoading extends CoachCubitState{}
class CoachSucccess extends CoachCubitState{
  final List<dynamic> players;
  CoachSucccess(this.players);
}
class CoachError extends CoachCubitState {
  final String message;

  CoachError(this.message);
}