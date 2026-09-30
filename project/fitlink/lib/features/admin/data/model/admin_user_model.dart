class AdminUserModel {
  final String name;
  final String email;
  final String role;
  final String status;
  final String registeredDate;
  final String lastLogin;

  AdminUserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.registeredDate,
    required this.lastLogin,
  });
}