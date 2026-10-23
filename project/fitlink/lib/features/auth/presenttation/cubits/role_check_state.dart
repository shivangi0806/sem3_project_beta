import 'package:fitlink/core/model/role.dart';

abstract class RoleCheckState {}

class RoleCheckInitial extends RoleCheckState {}

class RoleCheckLoading extends RoleCheckState {}

class RoleCheckResolved extends RoleCheckState {
  RoleCheckResolved(this.role);
  final Role role;
}

class RoleCheckError extends RoleCheckState {
  RoleCheckError(this.message);
  final String message;
}
