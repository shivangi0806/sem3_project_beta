import 'package:fitlink/core/model/role.dart';
import 'package:fitlink/core/model/privilege.dart';

abstract class RolesState {}

class RolesInitial extends RolesState {}

class RolesLoading extends RolesState {}

class RolesLoaded extends RolesState {
  RolesLoaded(
    List<Role> roles, {
    List<Privilege> privileges = const [],
    this.searchQuery = '',
    this.systemFilter,
  }) : roles = List.unmodifiable(roles),
       privileges = List.unmodifiable(privileges);

  final List<Role> roles;
  final List<Privilege> privileges;
  final String searchQuery;
  final bool? systemFilter;
}

class RolesError extends RolesState {
  RolesError(this.message);
  final String message;
}
