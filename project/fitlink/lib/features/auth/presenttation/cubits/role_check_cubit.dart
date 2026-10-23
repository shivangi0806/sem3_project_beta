import 'package:fitlink/core/model/role.dart';
import 'package:fitlink/features/auth/data/role_check_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'role_check_state.dart';

class RoleCheckCubit extends Cubit<RoleCheckState> {
  RoleCheckCubit() : super(RoleCheckInitial());

  Future<void> resolve({
    required String token,
    required String roleId,
  }) async {
    if (token.isEmpty || roleId.trim().isEmpty) {
      emit(RoleCheckError('Your account does not have a valid role. Please contact your team administrator.'));
      return;
    }

    emit(RoleCheckLoading());
    final service = RoleCheckService(token: token);
    try {
      final roleData = await service.getRole(roleId);
      final role = Role.fromJson(roleData);
      if (role.roleId.trim().toLowerCase() != roleId.trim().toLowerCase()) {
        emit(RoleCheckError('Your assigned role could not be found. Please contact your team administrator.'));
        return;
      }
      emit(RoleCheckResolved(role));
    } catch (error) {
      emit(RoleCheckError(error.toString().replaceFirst('Exception: ', '')));
    } finally {
      service.close();
    }
  }
}
