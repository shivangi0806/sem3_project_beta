class User {
  String userId;
  String username;
  String email;
  String roleId;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.roleId,
  });
  factory User.fromJson(Map<String,dynamic> json)
  {
    return User(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      roleId: json['roleId']);
  }
}
class UserSession{
  User user;
  String accessToken;
  String refreshToken;
  UserSession({required this.user,required this.accessToken,required this.refreshToken});
  factory UserSession.fromJson(Map<String,dynamic> json)
  {
    return UserSession(user: User.fromJson(json['user']), accessToken: json['accessToken'], refreshToken: json['refreshToken']);
  }
}