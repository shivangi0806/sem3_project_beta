import 'package:fitlink/core/model/user.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  final List<String> availableRoles;
  final String searchQuery;
  final String? roleFilter;
  final bool? activeFilter;

  UsersLoaded(
    List<User> users, {
    required List<String> availableRoles,
    this.searchQuery = '',
    this.roleFilter,
    this.activeFilter,
  })  : users = List.unmodifiable(users),
        availableRoles = List.unmodifiable(availableRoles);
}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}
