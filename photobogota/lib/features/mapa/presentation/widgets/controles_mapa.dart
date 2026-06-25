import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Botones de zoom +/- flotantes, equivalentes a ControlesZoom en MapaBogota.jsx.
class ControlesZoom extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const ControlesZoom({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BotonMapa(icon: Icons.add_rounded, onTap: onZoomIn),
        const SizedBox(height: 8),
        _BotonMapa(icon: Icons.remove_rounded, onTap: onZoomOut),
      ],
    );
  }
}

/// Botón flotante para centrar el mapa en la ubicación del usuario,
/// equivalente a BotonUbicacion en MapaBogota.jsx.
class BotonUbicacion extends StatelessWidget {
  final VoidCallback onTap;
  final bool cargando;

  const BotonUbicacion({super.key, required this.onTap, this.cargando = false});

  @override
  Widget build(BuildContext context) {
    return _BotonMapa(
      icon: Icons.my_location_rounded,
      onTap: cargando ? null : onTap,
      cargando: cargando,
    );
  }
}

class _BotonMapa extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool cargando;

  const _BotonMapa({required this.icon, required this.onTap, this.cargando = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primaryColor,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: cargando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
