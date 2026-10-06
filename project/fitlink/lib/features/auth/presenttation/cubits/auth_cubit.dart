
import 'package:fitlink/core/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/api_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService apiService;

  AuthCubit(this.apiService) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final result = await apiService.login(
        email: email,
        password: password,
      );
       print("API RESULT: $result");
      if (result["user"] != null) {
        emit(AuthLoginSuccessState(user: UserSession.fromJson(result), message: result['message']));
     //   emit(AuthSuccess(result["message"] ?? "Login successful"));
      } else {
        emit(AuthError(result["message"] ?? "Login failed"));
      }
    } catch (e) {
       print("LOGIN ERROR: $e");
  emit(AuthError(e.toString()));
     // emit(AuthError("Something went wrong"));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String roleId
  }) async {
    emit(AuthLoading());

    try {
      final result = await apiService.register(
        name: name,
        email: email,
        password: password,
        roleId: roleId
      );

      if (result["user"] != null) {
        emit(AuthSuccess(
          message: result['message'],
          //user: UserSession.fromJson(result)
          //result["message"] ?? "Registration successful",
        ));
      } else {
        emit(AuthError(result["message"] ?? "Registration failed"));
      }
    } catch (e) {
        print("REGISTER ERROR: $e");
      emit(AuthError("Something went wrong"));
    }
  }
}