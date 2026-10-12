import 'package:fitlink/core/model/role.dart';
import 'package:fitlink/core/services/role_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'roles_state.dart';

class RolesCubit extends Cubit<RolesState> {
  RolesCubit({required String token, RoleService? service})
      : _service = service ?? RoleService(token: token),
        super(RolesInitial());

  final RoleService _service;
  final List<Role> _allRoles = [];
  String _searchQuery = '';
  bool? _systemFilter;

  Future<void> loadRoles() async {
    if (_service.token.isEmpty) {
      emit(RolesError('Please sign in to view roles.'));
      return;
    }
    emit(RolesLoading());
    try {
      final roles = await _service.getRoles();
      _allRoles
        ..clear()
        ..addAll(roles);
      _emitLoaded();
    } catch (error) {
      emit(RolesError(error.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<Role> getRoleDetails(String roleId) =>
      _service.getRoleById(roleId.trim());

  void searchRoles(String query) {
    _searchQuery = query;
    _emitLoaded();
  }

  void filterBySystem(bool? isSystemRole) {
    _systemFilter = isSystemRole;
    _emitLoaded();
  }

  void _emitLoaded() {
    final query = _searchQuery.trim().toLowerCase();
    final roles = _allRoles.where((role) {
      final matchesQuery = query.isEmpty ||
          role.roleName.toLowerCase().contains(query) ||
          role.roleId.toLowerCase().contains(query) ||
          role.privilegesId.any((id) => id.toString().contains(query));
      return matchesQuery &&
          (_systemFilter == null || role.isSystemRole == _systemFilter);
    }).toList(growable: false);
    emit(RolesLoaded(
      roles,
      searchQuery: _searchQuery,
      systemFilter: _systemFilter,
    ));
  }

  @override
  Future<void> close() {
    _service.close();
    return super.close();
  }
}
