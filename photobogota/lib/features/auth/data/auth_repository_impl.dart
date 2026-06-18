import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> login(String username, String password) async {
    final token = await remoteDataSource.login(username, password);
    await storage.write(key: 'jwt_token', value: token);
    return token;
  }

  @override
  Future<void> register({required String username, required String email, required String password}) async {
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