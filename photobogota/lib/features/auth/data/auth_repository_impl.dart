import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';
import '../domain/entities/auth_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthEntity> login(String login, String contrasena) async {
    final model = await remoteDataSource.login(login, contrasena);
    await storage.write(key: 'jwt_token', value: model.token);
    return model.toEntity(); // ← entidad limpia hacia arriba
  }

  @override
  Future<void> register({
    required String nombresCompletos,
    required String email,
    required String nombreUsuario,
    required String contrasena,
    required String fechaNacimiento,
  }) async {
    await remoteDataSource.register({
      'nombresCompletos': nombresCompletos,
      'email': email,
      'nombreUsuario': nombreUsuario,
      'contrasena': contrasena,
      'fechaNacimiento': fechaNacimiento,
      'telefono': "",
      'fotoPerfil': "",
      'estadoCuenta': true,
      'biografia': "",
      'correoConfirmado': false,
      'roles': ["miembro"],
    });
  }

  @override
  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }

  @override
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  @override
  Future<void> forgotPassword(String email) async {
    await remoteDataSource.forgotPassword(email);
  }

  @override
  Future<void> verifyCode(String email, String code) async {
    await remoteDataSource.verifyCode(email, code);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await remoteDataSource.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }
}
