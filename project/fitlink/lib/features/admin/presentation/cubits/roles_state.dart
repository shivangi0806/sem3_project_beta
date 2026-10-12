import 'package:fitlink/core/model/role.dart';

abstract class RolesState {}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesLoaded extends RolesState {
  RolesLoaded(
    List<Role> roles, {
    this.searchQuery = '',
    this.systemFilter,
  }) : roles = List.unmodifiable(roles);

  final List<Role> roles;
  final String searchQuery;
  final bool? systemFilter;
}

class RolesError extends RolesState {
  RolesError(this.message);
  final String message;
}
