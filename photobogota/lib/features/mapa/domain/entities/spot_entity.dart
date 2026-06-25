/// Representa un spot fotográfico en el mapa.
/// Equivalente al objeto `lugar` formateado en MapaBogota.jsx.
class SpotEntity {
  final String id;
  final String nombre;
  final String direccion;
  final double latitud;
  final double longitud;
  final String? categoria;
  final String? localidad;
  final String? descripcion;
  final double? rating;
  final int? totalResenas;
  final String? imagen;
  final String? recomendacion;
  final String? tipsFoto;

  const SpotEntity({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    this.categoria,
    this.localidad,
    this.descripcion,
    this.rating,
    this.totalResenas,
    this.imagen,
    this.recomendacion,
    this.tipsFoto,
  });
}
