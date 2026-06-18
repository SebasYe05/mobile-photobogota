import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  // Cambia por tu IP local de desarrollo (evita localhost si usas emulador Android, usa 10.0.2.2)
  final String _baseUrl = 'http://127.0.0.1:8080/api/v1'; 

  AuthRemoteDataSource(this._dio);

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/controller/login', // TODO: Ajusta según tus endpoints reales
        data: {'username': username, 'password': password},
      );
      
      // Asumiendo que tu backend retorna {"token": "JWT_HERE"}
      return response.data['token']; 
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al iniciar sesión');
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      await _dio.post('$_baseUrl/controller/register', data: userData);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en el registro');
    }
  }
}