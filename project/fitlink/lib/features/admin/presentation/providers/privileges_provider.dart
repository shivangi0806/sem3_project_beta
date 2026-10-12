import 'package:fitlink/core/model/privilege.dart';
import 'package:flutter/material.dart';

class PrivilegesProvider extends ChangeNotifier {
  final List<Privilege> _privileges = [];
  String _searchQuery = '';

  List<Privilege> get privileges => List.unmodifiable(_privileges);
  String get searchQuery => _searchQuery;

  List<Privilege> get filteredPrivileges {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return privileges;

    return List.unmodifiable(
      _privileges.where((privilege) {
        return privilege.name.toLowerCase().contains(query) ||
            privilege.description.toLowerCase().contains(query) ||
            privilege.category.toLowerCase().contains(query);
      }),
    );
  }

  void setPrivileges(List<Privilege> privileges) {
    _privileges
      ..clear()
      ..addAll(privileges);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void addPrivilege({
    required String name,
    required String description,
    String category = '',
    bool isSystemPrivilege = false,
  }) {
    final now = DateTime.now();
    _privileges.add(
      Privilege(
        id: now.microsecondsSinceEpoch.toString(),
        privilegeId: _nextPrivilegeId(),
        name: name.trim(),
        description: description.trim(),
        category: category.trim(),
        isSystemPrivilege: isSystemPrivilege,
        createdAt: now,
        updatedAt: now,
      ),
    );
    notifyListeners();
  }

  bool updatePrivilege({
    required String id,
    required String name,
    required String description,
    String category = '',
    bool? isSystemPrivilege,
  }) {
    final index = _privileges.indexWhere((privilege) => privilege.id == id);
    if (index == -1) return false;

    final now = DateTime.now();
    _privileges[index] = _privileges[index].copyWith(
      name: name.trim(),
      description: description.trim(),
      category: category.trim(),
      isSystemPrivilege: isSystemPrivilege,
      updatedAt: now,
    );
    notifyListeners();
    return true;
  }

  bool deletePrivilege(String id) {
    final oldLength = _privileges.length;
    _privileges.removeWhere((privilege) => privilege.id == id);

    final deleted = _privileges.length != oldLength;
    if (deleted) notifyListeners();
    return deleted;
  }

  void clearPrivileges() {
    if (_privileges.isEmpty) return;
    _privileges.clear();
    notifyListeners();
  }

  int _nextPrivilegeId() {
    if (_privileges.isEmpty) return 1;
    return _privileges
            .map((privilege) => privilege.privilegeId)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }
}
