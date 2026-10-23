import 'package:fitlink/core/model/user.dart';
import 'package:fitlink/core/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit({required String token, UserService? service})
      : _service = service ?? UserService(token: token),
        super(UsersInitial());

  final UserService _service;
  final List<User> _users = [];
  String _searchQuery = '';
  String? _roleFilter;
  bool? _activeFilter;

  Future<void> loadUsers() async {
    if (_service.token.isEmpty) {
      emit(UsersError('Please sign in to view users.'));
      return;
    }

    emit(UsersLoading());
    try {
      final users = await _service.getUsers();
      _users
        ..clear()
        ..addAll(users);
      _emitLoaded();
    } catch (error) {
      emit(UsersError(_messageFrom(error)));
    }
  }

  /// Fetches one user from GET /users/:userId for the detail view.
  Future<User> getUserDetails(String userId) {
    return _service.getUserById(userId.trim());
  }

  void searchUsers(String query) {
    _searchQuery = query;
    _emitLoaded();
  }

  void filterByRole(String? roleId) {
    _roleFilter = roleId;
    _emitLoaded();
  }

  void filterByStatus(bool? isActive) {
    _activeFilter = isActive;
    _emitLoaded();
  }

  void _emitLoaded() {
    final query = _searchQuery.trim().toLowerCase();
    final visibleUsers = _users.where((user) {
      final matchesQuery = query.isEmpty ||
          user.username.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.userId.toLowerCase().contains(query) ||
          user.roleId.toLowerCase().contains(query);
      final matchesRole = _roleFilter == null || user.roleId == _roleFilter;
      final matchesStatus = _activeFilter == null ||
          user.isActive == _activeFilter;
      return matchesQuery && matchesRole && matchesStatus;
    }).toList(growable: false);

    final roles = _users
        .map((user) => user.roleId)
        .where((roleId) => roleId.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    emit(
      UsersLoaded(
        visibleUsers,
        availableRoles: roles,
        searchQuery: _searchQuery,
        roleFilter: _roleFilter,
        activeFilter: _activeFilter,
      ),
    );
  }

  String _messageFrom(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  Future<void> close() {
    _service.close();
    return super.close();
  }
}
