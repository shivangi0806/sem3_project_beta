import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/user.dart';
import '../../../core/service/api_service.dart';
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

      if (result['user'] is Map) {
        final session = UserSession.fromJson(result);

        emit(
          AuthLoginSuccessState(
            user: session,
            message: result['message']?.toString() ??
                'Login successful',
          ),
        );
      } else {
        emit(
          AuthError(
            result['message']?.toString() ?? 'Login failed',
          ),
        );
      }
    } catch (e) {
      emit(AuthError(_messageFromError(e)));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final result = await apiService.register(
        name: name,
        email: email,
        password: password,
        roleId: 'ROLE_PLAYER',
      );

      if (result['user'] != null) {
        emit(
          AuthSuccess(
            message: result['message']?.toString() ??
                'Registration successful',
          ),
        );
      } else {
        emit(
          AuthError(
            result['message']?.toString() ??
                'Registration failed',
          ),
        );
      }
    } catch (e) {
      emit(AuthError(_messageFromError(e)));
    }
  }

  void reset() {
    emit(AuthInitial());
  }

  String _messageFromError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}