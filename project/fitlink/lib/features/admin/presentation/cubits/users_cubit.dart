import 'package:flutter_bloc/flutter_bloc.dart';

import 'users_state.dart';
import 'package:fitlink/core/services/api_service.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial()){
    print("USERS CUBIT CREATED");
    testGetUsers();
  }
  //load etc are remaining

  Future<void> testGetUsers() async {
    final apiService = ApiService();

    try {
      final result = await apiService.getUsers();

      print("GET USERS RESULT: $result");
    } catch (e) {
      print("GET USERS ERROR: $e");
    }
  }
}