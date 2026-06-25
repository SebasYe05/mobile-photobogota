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

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('/auth/passwords/recovery-request', data: {'email': email});
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw ServerFailure(msg ?? 'Error al solicitar recuperación');
    }
  }

  Future<void> verifyCode(String email, String code) async {
    try {
      await _dio.post('/auth/passwords/verify-code', data: {'email': email, 'code': code});
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw ServerFailure(msg ?? 'Código inválido');
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/auth/passwords/reset',
        data: {'email': email, 'code': code, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw ServerFailure(msg ?? 'Error al restablecer contraseña');
    }
  }
}
