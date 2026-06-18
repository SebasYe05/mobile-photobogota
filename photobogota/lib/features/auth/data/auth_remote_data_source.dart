import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  // 10.0.2.2 → tu máquina desde el emulador Android
  // En dispositivo físico: usa tu IP local (ej: 192.168.1.x)
  // En iOS simulator: puedes usar 127.0.0.1
  static const String _baseUrl = 'http://127.0.0.1:8080/api/v1';

  AuthRemoteDataSource(this._dio);

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login', // Ajusta al endpoint real de tu Spring Boot
        data: {'username': username, 'password': password},
      );

      // Tu Spring Boot retorna {"token": "JWT_HERE"}
      return response.data['token'] as String;
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']
          : null;
      throw Exception(msg ?? 'Error al iniciar sesión');
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      await _dio.post('$_baseUrl/auth/register', data: userData);
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? e.response?.data['message']
          : null;
      throw Exception(msg ?? 'Error en el registro');
    }
  }
}