import 'package:bloc/bloc.dart';
import 'package:fitlink/core/services/api_service.dart';
import 'package:meta/meta.dart';
import 'package:fitlink/core/services/coach_service.dart';
//import 'coach_cubit_state.dart';

part 'coach_cubit_state.dart';
class CoachCubitCubit extends Cubit<CoachCubitState> {
  final CoachService apiService;
  CoachCubitCubit(this.apiService) : super(CoachCubitInitial());
  Future<void> getPlayers() async{
    emit(CoachLoading());
    try{
        final players = await apiService.getPlayers();
        emit(CoachSucccess(players));
    }catch(e){
        emit(CoachError(e.toString()));
    }
  }
}
