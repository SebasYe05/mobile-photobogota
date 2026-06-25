import 'entities/spot_entity.dart';
import 'entities/opcion_filtro_entity.dart';
import 'entities/filtros_mapa_entity.dart';

abstract class MapaRepository {
  /// Equivalente a getCategoriasActivas() en categoriaApi.js
  Future<List<OpcionFiltroEntity>> getCategoriasActivas();

  /// Equivalente a getLocalidadesActivas() en localidadApi.js
  Future<List<OpcionFiltroEntity>> getLocalidadesActivas();

  /// Equivalente a obtenerSpots(filtros) en spot.service.js
  Future<List<SpotEntity>> obtenerSpots(FiltrosMapaEntity filtros);
}
