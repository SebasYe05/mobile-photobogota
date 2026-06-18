abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<void> register({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<String?> getToken();
}
