import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/mapa_repository.dart';
import '../../domain/entities/spot_entity.dart';
import '../../domain/entities/opcion_filtro_entity.dart';
import '../../domain/entities/filtros_mapa_entity.dart';
import '../../data/mapa_repository_impl.dart' show SpotsParcialesException;

// ==========================================
// EVENTOS
// ==========================================
abstract class MapaEvent {}

/// Se dispara una vez al entrar a la pantalla: carga opciones de filtro y spots.
class MapaIniciado extends MapaEvent {}

/// Equivalente a aplicar() en FiltrosMapa.jsx
class FiltrosAplicados extends MapaEvent {
  final FiltrosMapaEntity filtros;
  FiltrosAplicados(this.filtros);
}

/// Equivalente a limpiar() en FiltrosMapa.jsx
class FiltrosLimpiados extends MapaEvent {}

// ==========================================
// ESTADOS
// ==========================================
abstract class MapaState {}

class MapaCargandoInicial extends MapaState {}

class MapaError extends MapaState {
  final String mensaje;
  MapaError(this.mensaje);
}

class MapaCargado extends MapaState {
  final List<SpotEntity> spots;
  final List<OpcionFiltroEntity> categorias;
  final List<OpcionFiltroEntity> localidades;
  final FiltrosMapaEntity filtrosActuales;
  final bool cargandoSpots;
  final String? avisoSpotsDescartados;

  MapaCargado({
    required this.spots,
    required this.categorias,
    required this.localidades,
    required this.filtrosActuales,
    this.cargandoSpots = false,
    this.avisoSpotsDescartados,
  });

  MapaCargado copyWith({
    List<SpotEntity>? spots,
    List<OpcionFiltroEntity>? categorias,
    List<OpcionFiltroEntity>? localidades,
    FiltrosMapaEntity? filtrosActuales,
    bool? cargandoSpots,
    String? avisoSpotsDescartados,
  }) {
    return MapaCargado(
      spots: spots ?? this.spots,
      categorias: categorias ?? this.categorias,
      localidades: localidades ?? this.localidades,
      filtrosActuales: filtrosActuales ?? this.filtrosActuales,
      cargandoSpots: cargandoSpots ?? this.cargandoSpots,
      avisoSpotsDescartados: avisoSpotsDescartados,
    );
  }
}

// ==========================================
// BLOC
// ==========================================
class MapaBloc extends Bloc<MapaEvent, MapaState> {
  final MapaRepository mapaRepository;

  MapaBloc({required this.mapaRepository}) : super(MapaCargandoInicial()) {
    on<MapaIniciado>(_onIniciado);
    on<FiltrosAplicados>(_onFiltrosAplicados);
    on<FiltrosLimpiados>(_onFiltrosLimpiados);
  }

  Future<void> _onIniciado(MapaIniciado event, Emitter<MapaState> emit) async {
    emit(MapaCargandoInicial());
    try {
      final categorias = await mapaRepository.getCategoriasActivas();
      final localidades = await mapaRepository.getLocalidadesActivas();
      const filtrosVacios = FiltrosMapaEntity.vacio();

      emit(MapaCargado(
        spots: const [],
        categorias: categorias,
        localidades: localidades,
        filtrosActuales: filtrosVacios,
        cargandoSpots: true,
      ));

      await _cargarSpots(filtrosVacios, emit);
    } catch (e) {
      emit(MapaError(e.toString()));
    }
  }

  Future<void> _onFiltrosAplicados(
      FiltrosAplicados event, Emitter<MapaState> emit) async {
    final actual = state;
    if (actual is! MapaCargado) return;

    emit(actual.copyWith(
      filtrosActuales: event.filtros,
      cargandoSpots: true,
    ));
    await _cargarSpots(event.filtros, emit);
  }

  Future<void> _onFiltrosLimpiados(
      FiltrosLimpiados event, Emitter<MapaState> emit) async {
    const filtrosVacios = FiltrosMapaEntity.vacio();
    final actual = state;
    if (actual is! MapaCargado) return;

    emit(actual.copyWith(
      filtrosActuales: filtrosVacios,
      cargandoSpots: true,
    ));
    await _cargarSpots(filtrosVacios, emit);
  }

  Future<void> _cargarSpots(
      FiltrosMapaEntity filtros, Emitter<MapaState> emit) async {
    final actual = state;
    if (actual is! MapaCargado) return;

    try {
      final spots = await mapaRepository.obtenerSpots(filtros);
      emit(actual.copyWith(spots: spots, cargandoSpots: false));
    } on SpotsParcialesException catch (e) {
      // Igual que el toast.error de MapaBogota.jsx, pero sin perder los
      // spots que sí son válidos.
      emit(actual.copyWith(
        spots: e.spotsValidos,
        cargandoSpots: false,
        avisoSpotsDescartados:
            '${e.descartados} spots no se pudieron mostrar por coordenadas inválidas',
      ));
    } catch (e) {
      emit(actual.copyWith(spots: const [], cargandoSpots: false));
    }
  }
}
