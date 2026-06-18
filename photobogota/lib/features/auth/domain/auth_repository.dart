abstract class AuthRepository {
  Future<String> login(String login, String contrasena);
  Future<void> register({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<String?> getToken();
}
