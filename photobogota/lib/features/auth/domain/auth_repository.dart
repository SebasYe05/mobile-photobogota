import 'entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(String login, String contrasena);
  Future<void> register({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<String?> getToken();
}
