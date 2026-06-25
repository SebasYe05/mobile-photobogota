import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/spot_entity.dart';

/// Bottom sheet con el detalle de un spot, equivalente a SpotPreviewModal
/// que se abre desde MapaBogota.jsx al hacer click en un marcador.
class SpotDetailSheet extends StatelessWidget {
  final SpotEntity spot;

  const SpotDetailSheet({super.key, required this.spot});

  static Future<void> mostrar(BuildContext context, SpotEntity spot) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpotDetailSheet(spot: spot),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.lightColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              _Imagen(url: spot.imagen),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            spot.nombre,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkColor,
                            ),
                          ),
                        ),
                        if (spot.rating != null) _RatingBadge(rating: spot.rating!),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (spot.direccion.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.place_rounded,
                              size: 16, color: AppTheme.mutedColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              spot.direccion,
                              style: const TextStyle(
                                  color: AppTheme.mutedColor, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (spot.categoria != null)
                          _Etiqueta(icon: Icons.category_rounded, texto: spot.categoria!),
                        if (spot.localidad != null)
                          _Etiqueta(icon: Icons.map_rounded, texto: spot.localidad!),
                        if (spot.totalResenas != null)
                          _Etiqueta(
                            icon: Icons.reviews_rounded,
                            texto: '${spot.totalResenas} reseñas',
                          ),
                      ],
                    ),
                    if (spot.descripcion != null && spot.descripcion!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _Seccion(
                        titulo: 'Descripción',
                        icono: Icons.notes_rounded,
                        texto: spot.descripcion!,
                      ),
                    ],
                    if (spot.recomendacion != null && spot.recomendacion!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _Seccion(
                        titulo: 'Recomendación',
                        icono: Icons.star_rounded,
                        texto: spot.recomendacion!,
                        colorIcono: AppTheme.starColor,
                      ),
                    ],
                    if (spot.tipsFoto != null && spot.tipsFoto!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _Seccion(
                        titulo: 'Tips de foto',
                        icono: Icons.camera_alt_rounded,
                        texto: spot.tipsFoto!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Imagen extends StatelessWidget {
  final String? url;
  const _Imagen({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: (url != null && url!.isNotEmpty)
            ? Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ImagenPlaceholder(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: AppTheme.backgroundColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              )
            : const _ImagenPlaceholder(),
      ),
    );
  }
}

class _ImagenPlaceholder extends StatelessWidget {
  const _ImagenPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.secondaryColor,
      child: const Center(
        child: Icon(Icons.camera_alt_rounded, size: 48, color: AppTheme.primaryColor),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.starColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppTheme.starColor),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppTheme.darkColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final IconData icon;
  final String texto;
  const _Etiqueta({required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.bgSoftColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primaryColor),
          const SizedBox(width: 5),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryHover,
            ),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final String texto;
  final Color? colorIcono;

  const _Seccion({
    required this.titulo,
    required this.icono,
    required this.texto,
    this.colorIcono,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, size: 17, color: colorIcono ?? AppTheme.primaryColor),
            const SizedBox(width: 6),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.mutedColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
