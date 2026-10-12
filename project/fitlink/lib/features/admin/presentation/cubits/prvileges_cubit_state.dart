part of 'prvileges_cubit_cubit.dart';

@immutable
sealed class PrvilegesCubitState {}

final class PrvilegesCubitInitial extends PrvilegesCubitState {}

final class PrvilegesLoadingState extends PrvilegesCubitState {}

final class PrvilegesSuccessState extends PrvilegesCubitState {
  final List<Privilege> data;
  final String searchQuery;

  PrvilegesSuccessState({required List<Privilege> data, this.searchQuery = ''})
    : data = List.unmodifiable(data);

  List<Privilege> get filteredData {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return data;

    return data
        .where((privilege) {
          return privilege.name.toLowerCase().contains(query) ||
              privilege.description.toLowerCase().contains(query) ||
              privilege.category.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }
}

final class PrivilegesErrorState extends PrvilegesCubitState {
  final String errorMsg;

  PrivilegesErrorState({required this.errorMsg});
}
