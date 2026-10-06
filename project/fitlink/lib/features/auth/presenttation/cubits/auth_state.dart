import 'package:fitlink/core/model/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
class AuthLoginSuccessState extends AuthState{
final String message;
  final UserSession user;
  AuthLoginSuccessState({required this.user,required this.message});
}
class AuthSuccess extends AuthState {
  String message;
 AuthSuccess({required this.message});
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}