class Role {
  const Role({
    required this.roleId,
    required this.roleName,
    required this.privilegesId,
    required this.isSystemRole,
    this.createdAt,
    this.updatedAt,
  });

  final String roleId;
  final String roleName;
  final List<int> privilegesId;
  final bool isSystemRole;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Role.fromJson(Map<String, dynamic> json) {
    final rawPrivileges = json['privilegesId'];
    final privilegeIds = rawPrivileges is List
        ? rawPrivileges.map((item) {
            if (item is Map) {
              final value = item['privilegeId'] ?? item['_id'];
              return int.tryParse(value.toString()) ?? 0;
            }
            return int.tryParse(item.toString()) ?? 0;
          }).where((id) => id > 0).toList(growable: false)
        : const <int>[];

    return Role(
      roleId: (json['roleId'] ?? '').toString(),
      roleName: (json['roleName'] ?? '').toString(),
      privilegesId: privilegeIds,
      isSystemRole: json['isSystemRole'] == true,
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()),
      updatedAt: DateTime.tryParse((json['updatedAt'] ?? '').toString()),
    );
  }
}
