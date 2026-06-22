import 'entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(String login, String contrasena);

  Future<void> register({
    required String nombresCompletos,
    required String email,
    required String nombreUsuario,
    required String contrasena,
    required String fechaNacimiento,
  });

  Future<void> logout();

  Future<String?> getToken();
}