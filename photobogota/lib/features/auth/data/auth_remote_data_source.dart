import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import './models/auth_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSource(this._dio);

  Future<AuthModel> login(String login, String contrasena) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'login': login, 'contrasena': contrasena},
    );
    return AuthModel.fromJson(response.data); // ← ya no retorna String
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      await _dio.post('/auth/register', data: userData);
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw ServerFailure(msg ?? 'Error en el registro');
    }
  }
}
