import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Marcador moderno tipo "pin" con un ícono de cámara dentro, equivalente
/// visual al `camaraIcon` usado en MapaBogota.jsx (sin depender de un
/// asset de imagen externo).
class SpotMarker extends StatelessWidget {
  final VoidCallback onTap;
  final bool destacado;

  const SpotMarker({super.key, required this.onTap, this.destacado = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
          ),
          CustomPaint(
            size: const Size(10, 6),
            painter: _ColaPinPainter(color: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }
}

class _ColaPinPainter extends CustomPainter {
  final Color color;
  _ColaPinPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Marcador para la ubicación actual del usuario (punto azul tipo Google Maps).
class UbicacionActualMarker extends StatelessWidget {
  const UbicacionActualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(0.25),
      ),
      child: Center(
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
