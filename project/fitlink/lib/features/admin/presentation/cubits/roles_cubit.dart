import 'package:fitlink/core/model/role.dart';
import 'package:fitlink/core/services/role_service.dart';
import 'package:fitlink/core/model/privilege.dart';
import 'package:fitlink/core/services/privileges_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'roles_state.dart';

class RolesCubit extends Cubit<RolesState> {
  RolesCubit({
    required String token,
    RoleService? service,
    PrvielgesService? privilegesService,
  })
      : _service = service ?? RoleService(token: token),
        _privilegesService = privilegesService ?? PrvielgesService(token: token),
        super(RolesInitial());

  final RoleService _service;
  final PrvielgesService _privilegesService;
  final List<Role> _allRoles = [];
  final List<Privilege> _privileges = [];
  String _searchQuery = '';
  bool? _systemFilter;

  Future<void> loadRoles() async {
    if (_service.token.isEmpty) {
      emit(RolesError('Please sign in to view roles.'));
      return;
    }
    emit(RolesLoading());
    try {
      final results = await Future.wait([
        _service.getRoles(),
        _privilegesService.getPrivileges(),
      ]);
      final roles = results[0] as List<Role>;
      final privileges = results[1] as List<Privilege>;
      _allRoles
        ..clear()
        ..addAll(roles);
      _privileges
        ..clear()
        ..addAll(privileges);
      _emitLoaded();
    } catch (error) {
      emit(RolesError(error.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<Role> getRoleDetails(String roleId) =>
      _service.getRoleById(roleId.trim());

  Future<void> createRole({
    required String roleId,
    required String roleName,
    required List<int> privilegesId,
  }) async {
    await _service.createRole(
      roleId: roleId,
      roleName: roleName,
      privilegesId: privilegesId,
    );
    await loadRoles();
  }

  Future<void> updateRole({
    required String roleId,
    required String roleName,
    required List<int> privilegesId,
  }) async {
    await _service.updateRole(
      roleId: roleId,
      roleName: roleName,
      privilegesId: privilegesId,
    );
    await loadRoles();
  }

  Future<void> deleteRole(String roleId) async {
    await _service.deleteRole(roleId);
    await loadRoles();
  }

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
      privileges: _privileges,
      searchQuery: _searchQuery,
      systemFilter: _systemFilter,
    ));
  }

  @override
  Future<void> close() {
    _service.close();
    _privilegesService.close();
    return super.close();
  }
}
