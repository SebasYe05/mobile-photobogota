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
    required String username,
    required String email,
    required String password,
  }) async {
    await remoteDataSource.register({
      'username': username,
      'email': email,
      'password': password,
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
}
