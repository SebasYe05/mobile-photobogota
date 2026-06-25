import '../domain/mapa_repository.dart';
import '../domain/entities/spot_entity.dart';
import '../domain/entities/opcion_filtro_entity.dart';
import '../domain/entities/filtros_mapa_entity.dart';
import 'mapa_remote_data_source.dart';

/// Excepción usada para avisar a la UI cuántos spots se descartaron por
/// coordenadas inválidas, igual al toast de MapaBogota.jsx, sin romper
/// el flujo principal (los spots válidos sí se entregan).
class SpotsParcialesException implements Exception {
  final List<SpotEntity> spotsValidos;
  final int descartados;
  SpotsParcialesException(this.spotsValidos, this.descartados);
}

class MapaRepositoryImpl implements MapaRepository {
  final MapaRemoteDataSource remoteDataSource;

  MapaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OpcionFiltroEntity>> getCategoriasActivas() async {
    final modelos = await remoteDataSource.getCategoriasActivas();
    return modelos.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<OpcionFiltroEntity>> getLocalidadesActivas() async {
    final modelos = await remoteDataSource.getLocalidadesActivas();
    return modelos.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<SpotEntity>> obtenerSpots(FiltrosMapaEntity filtros) async {
    final modelos = await remoteDataSource.obtenerSpots(filtros);

    final validos = modelos.where((m) => m.coordenadasValidas).toList();
    final descartados = modelos.length - validos.length;

    final entidades = validos.map((m) => m.toEntity()).toList();

    if (descartados > 0) {
      // El Bloc decide cómo avisar (snackbar) sin perder los spots válidos.
      throw SpotsParcialesException(entidades, descartados);
    }

    return entidades;
  }
}
