class User {
  final String userId;
  final String username;
  final String email;
  final String roleId;
  final String? mobileNo;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.roleId,
    this.mobileNo,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: (json['userId'] ?? json['_id'] ?? '').toString(),
      username: (json['username'] ?? json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      roleId: _roleId(json['roleId']),
      mobileNo: json['mobileNo']?.toString(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
    );
  }

  User copyWith({String? roleId, bool? isActive}) => User(
        userId: userId,
        username: username,
        email: email,
        roleId: roleId ?? this.roleId,
        mobileNo: mobileNo,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static String _roleId(dynamic value) {
    if (value is Map) return (value['roleId'] ?? value['_id'] ?? '').toString();
    return (value ?? '').toString();
  }

  static DateTime? _date(dynamic value) {
    if (value is DateTime) return value;
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

class UserSession {
  User user;
  String accessToken;
  String refreshToken;

  UserSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      user: User.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
    );
  }
}
