import 'package:bloc/bloc.dart';
import 'package:fitlink/core/model/privilege.dart';
import 'package:fitlink/core/services/privileges_service.dart';
import 'package:meta/meta.dart';

part 'prvileges_cubit_state.dart';

class PrvilegesCubitCubit extends Cubit<PrvilegesCubitState> {
  PrvilegesCubitCubit({required String token, PrvielgesService? service})
      : _service = service ?? PrvielgesService(token: token),
        super(PrvilegesCubitInitial());

  final PrvielgesService _service;
  final List<Privilege> _privileges = [];
  String _searchQuery = '';

  Future<void> loadPrivileges() async {
    if (_service.token.isEmpty) {
      emit(PrivilegesErrorState(errorMsg: 'Please sign in to manage privileges.'));
      return;
    }

    emit(PrvilegesLoadingState());
    try {
      final privileges = await _service.getPrivileges();
      _privileges
        ..clear()
        ..addAll(privileges);
      _emitSuccess();
    } catch (error) {
      emit(PrivilegesErrorState(errorMsg: _messageFrom(error)));
    }
  }

  void searchPrivileges(String query) {
    _searchQuery = query;
    _emitSuccess();
  }

  Future<void> addPrivilege({
    required String name,
    required String description,
  }) async {
    emit(PrvilegesLoadingState());
    try {
      final nextId = _privileges.isEmpty
          ? 1
          : _privileges
                  .map((privilege) => privilege.privilegeId)
                  .reduce((a, b) => a > b ? a : b) +
              1;

      await _service.createPrivilege(
        privilegeId: nextId,
        privilegeName: name.trim(),
        description: description.trim(),
      );
      await loadPrivileges();
    } catch (error) {
      emit(PrivilegesErrorState(errorMsg: _messageFrom(error)));
    }
  }

  Future<void> updatePrivilege({
    required int privilegeId,
    required String name,
    required String description,
  }) async {
    emit(PrvilegesLoadingState());
    try {
      await _service.updatePrivilege(
        privilegeId: privilegeId,
        privilegeName: name.trim(),
        description: description.trim(),
      );
      await loadPrivileges();
    } catch (error) {
      emit(PrivilegesErrorState(errorMsg: _messageFrom(error)));
    }
  }

  Future<void> deletePrivilege(int privilegeId) async {
    emit(PrvilegesLoadingState());
    try {
      await _service.deletePrivilege(privilegeId);
      await loadPrivileges();
    } catch (error) {
      emit(PrivilegesErrorState(errorMsg: _messageFrom(error)));
    }
  }

  void _emitSuccess() {
    final query = _searchQuery.trim().toLowerCase();
    final results = query.isEmpty
        ? _privileges
        : _privileges.where((privilege) {
            return privilege.name.toLowerCase().contains(query) ||
                privilege.description.toLowerCase().contains(query);
          }).toList(growable: false);

    emit(PrvilegesSuccessState(data: results, searchQuery: _searchQuery));
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
