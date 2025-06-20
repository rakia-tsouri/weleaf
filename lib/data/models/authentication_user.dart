class AuthUser {
  String password;
  String username;
  bool rememberMe;

  AuthUser({
    required this.password,
    required this.username,
    required this.rememberMe,
  });

  Map<String, dynamic> toJson() {
    final data = {"username": username, "password": password};
    return data;
  }
}
