import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

Dio createDioClient() {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}
