import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import './models/auth_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSource(this._dio);

  Future<AuthModel> login(String login, String contrasena) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'login': login, 'contrasena': contrasena},
      );
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      await _dio.post('/auth/register', data: userData);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String? backendMessage;
    if (data is Map) {
      backendMessage = data['message'] ?? data['error'] ?? data['detalle'];
    }

    switch (statusCode) {
      case 400:
        return ServerFailure(backendMessage ?? 'Datos inválidos. Revisa el formulario.');
      case 401:
        return ServerFailure(backendMessage ?? 'Usuario o contraseña incorrectos.');
      case 403:
        return ServerFailure(backendMessage ?? 'No tienes permiso para realizar esta acción.');
      case 404:
        return ServerFailure(backendMessage ?? 'Recurso no encontrado.');
      case 409:
        return ServerFailure(backendMessage ?? 'Este usuario o correo ya existe.');
      case 500:
        return ServerFailure(backendMessage ?? 'Error interno del servidor. Intenta más tarde.');
      default:
        return ServerFailure(backendMessage ?? 'Ocurrió un error inesperado ($statusCode).');
    }
  }
}