
import '../../../core/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccessState extends AuthState {
  final UserSession user;
  final String message;

  AuthLoginSuccessState({
    required this.user,
    required this.message,
  });
}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({required this.message});
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}