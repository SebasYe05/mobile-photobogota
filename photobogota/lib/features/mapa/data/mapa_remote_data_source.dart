import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import 'models/spot_model.dart';
import 'models/opcion_filtro_model.dart';
import '../domain/entities/filtros_mapa_entity.dart';

class MapaRemoteDataSource {
  final Dio _dio;
  MapaRemoteDataSource(this._dio);

  // NOTA: ajusta estas rutas si tu backend expone otros endpoints.
  // Se asumen equivalentes a categoriaApi.js / localidadApi.js / spot.service.js
  // de la web (getCategoriasActivas, getLocalidadesActivas, obtenerSpots).

  Future<List<OpcionFiltroModel>> getCategoriasActivas() async {
    try {
      final response = await _dio.get('/categorias');
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);
      return data
          .map((e) => OpcionFiltroModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(_mensajeError(e, 'Error al cargar categorías'));
    }
  }

  Future<List<OpcionFiltroModel>> getLocalidadesActivas() async {
    try {
      final response = await _dio.get('/localidades');
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);
      return data
          .map((e) => OpcionFiltroModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(_mensajeError(e, 'Error al cargar localidades'));
    }
  }

  Future<List<SpotModel>> obtenerSpots(FiltrosMapaEntity filtros) async {
    try {
      final response = await _dio.get(
        '/spots',
        queryParameters: filtros.toQueryParams(),
      );
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);
      return data
          .map((e) => SpotModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(_mensajeError(e, 'Error al cargar el mapa'));
    }
  }

  String _mensajeError(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return fallback;
  }
}
