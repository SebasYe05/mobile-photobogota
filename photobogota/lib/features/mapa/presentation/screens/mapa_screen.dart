import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/mapa_remote_data_source.dart';
import '../../data/mapa_repository_impl.dart';
import '../controllers/mapa_bloc.dart';
import '../widgets/filtros_mapa_widget.dart';
import '../widgets/spot_detail_sheet.dart';
import '../widgets/spot_marker.dart';
import '../widgets/controles_mapa.dart';

/// Centro de Bogotá, igual al `center` de MapContainer en MapaBogota.jsx.
const LatLng _centroBogota = LatLng(4.6529, -74.075);

/// Límites de movimiento del mapa, igual al `setMaxBounds` de MapBounds
/// en MapaBogota.jsx.
final LatLngBounds _limitesBogota = LatLngBounds(
  const LatLng(4.2, -74.6),
  const LatLng(5.1, -73.6),
);

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapaBloc(
        mapaRepository: MapaRepositoryImpl(
          remoteDataSource: MapaRemoteDataSource(createDioClient()),
        ),
      )..add(MapaIniciado()),
      child: const _MapaScreenBody(),
    );
  }
}

class _MapaScreenBody extends StatefulWidget {
  const _MapaScreenBody();

  @override
  State<_MapaScreenBody> createState() => _MapaScreenBodyState();
}

class _MapaScreenBodyState extends State<_MapaScreenBody> {
  final MapController _mapController = MapController();
  bool _filtrosVisibles = false;
  bool _ubicandoUsuario = false;
  LatLng? _miUbicacion;
  String? _ultimoAviso;

  Future<void> _irAMiUbicacion() async {
    setState(() => _ubicandoUsuario = true);
    try {
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Activa el permiso de ubicación para usar esta función')),
          );
        }
        return;
      }

      final servicioActivo = await Geolocator.isLocationServiceEnabled();
      if (!servicioActivo) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Activa el GPS de tu dispositivo')),
          );
        }
        return;
      }

      final posicion = await Geolocator.getCurrentPosition();
      final latlng = LatLng(posicion.latitude, posicion.longitude);

      setState(() => _miUbicacion = latlng);
      _mapController.move(latlng, 16);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener tu ubicación')),
        );
      }
    } finally {
      if (mounted) setState(() => _ubicandoUsuario = false);
    }
  }

  void _zoomIn() {
    _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocConsumer<MapaBloc, MapaState>(
        listener: (context, state) {
          if (state is MapaCargado &&
              state.avisoSpotsDescartados != null &&
              state.avisoSpotsDescartados != _ultimoAviso) {
            _ultimoAviso = state.avisoSpotsDescartados;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.avisoSpotsDescartados!)),
            );
          }
        },
        builder: (context, state) {
          if (state is MapaError) {
            return _ErrorMapa(
              mensaje: state.mensaje,
              onReintentar: () => context.read<MapaBloc>().add(MapaIniciado()),
            );
          }

          if (state is! MapaCargado) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _centroBogota,
                  initialZoom: 12,
                  minZoom: 10,
                  maxZoom: 18,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                  cameraConstraint: CameraConstraint.containCenter(
                    bounds: _limitesBogota,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.photobogota.app',
                  ),
                  MarkerLayer(
                    markers: [
                      for (final spot in state.spots)
                        Marker(
                          point: LatLng(spot.latitud, spot.longitud),
                          width: 44,
                          height: 50,
                          alignment: Alignment.topCenter,
                          child: SpotMarker(
                            onTap: () => SpotDetailSheet.mostrar(context, spot),
                          ),
                        ),
                      if (_miUbicacion != null)
                        Marker(
                          point: _miUbicacion!,
                          width: 24,
                          height: 24,
                          child: const UbicacionActualMarker(),
                        ),
                    ],
                  ),
                ],
              ),

              // Botón "Mostrar/Ocultar filtros", igual a toggle-filtros-btn
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Center(
                        child: _BotonToggleFiltros(
                          visible: _filtrosVisibles,
                          onTap: () => setState(() => _filtrosVisibles = !_filtrosVisibles),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        child: _filtrosVisibles
                            ? FiltrosMapaWidget(
                                categorias: state.categorias,
                                localidades: state.localidades,
                                filtrosIniciales: state.filtrosActuales,
                                onAplicar: (filtros) {
                                  context.read<MapaBloc>().add(FiltrosAplicados(filtros));
                                },
                                onLimpiar: () {
                                  context.read<MapaBloc>().add(FiltrosLimpiados());
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),

              // Controles de zoom + ubicación, igual a la web
              Positioned(
                right: 16,
                bottom: 100,
                child: ControlesZoom(onZoomIn: _zoomIn, onZoomOut: _zoomOut),
              ),
              Positioned(
                right: 16,
                bottom: 40,
                child: BotonUbicacion(
                  onTap: _irAMiUbicacion,
                  cargando: _ubicandoUsuario,
                ),
              ),

              if (state.cargandoSpots)
                const Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Center(child: _BadgeCargando()),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BotonToggleFiltros extends StatelessWidget {
  final bool visible;
  final VoidCallback onTap;

  const _BotonToggleFiltros({required this.visible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.lightColor,
      borderRadius: BorderRadius.circular(50),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                visible ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                visible ? 'Ocultar filtros' : 'Mostrar filtros',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeCargando extends StatelessWidget {
  const _BadgeCargando();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor),
          ),
          SizedBox(width: 10),
          Text(
            'Cargando spots...',
            style: TextStyle(fontSize: 13, color: AppTheme.mutedColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ErrorMapa extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _ErrorMapa({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 56, color: AppTheme.mutedColor),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.mutedColor, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onReintentar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
