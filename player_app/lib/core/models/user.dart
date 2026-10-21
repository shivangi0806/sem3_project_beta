class User {
  final String userId;
  final String username;
  final String email;
  final String roleId;

  const User({
    required this.userId,
    required this.username,
    required this.email,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: (json['userId'] ?? json['_id'] ?? '').toString(),
      username: (json['username'] ?? json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      roleId: (json['roleId'] ?? '').toString(),
    );
  }
}

class UserSession {
  final User user;
  final String accessToken;
  final String refreshToken;

  const UserSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      user: User.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
    );
  }
}