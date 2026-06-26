import '../../domain/entities/spot_entity.dart';

class SpotModel {
  final String id;
  final String nombre;
  final String direccion;
  final double? latitud;
  final double? longitud;
  final String? categoria;
  final String? localidad;
  final String? descripcion;
  final double? rating;
  final int? totalResenas;
  final String? imagen;
  final String? recomendacion;
  final String? tipsFoto;

  const SpotModel({
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

  /// `coordenadasValidas` replica el filtro estricto que hace MapaBogota.jsx
  /// antes de pintar el marcador (lat/lng numéricos y dentro de rango).
  bool get coordenadasValidas =>
      latitud != null &&
      longitud != null &&
      latitud! >= -90 &&
      latitud! <= 90 &&
      longitud! >= -180 &&
      longitud! <= 180;

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  factory SpotModel.fromJson(Map<String, dynamic> json) {
    // El backend puede mandar 'imagen' o un arreglo 'imagenes' (toma la primera).
    final imagenes = json['imagenes'];
    final primeraImagen = (imagenes is List && imagenes.isNotEmpty)
        ? imagenes.first?.toString()
        : null;

    return SpotModel(
      id: json['id']?.toString() ?? '',
      nombre: (json['nombre'] as String?) ?? 'Sin nombre',
      direccion: (json['direccion'] as String?) ?? '',
      latitud: _parseDouble(json['latitud']),
      longitud: _parseDouble(json['longitud']),
      categoria: json['categoria']?.toString(),
      localidad: json['localidad']?.toString(),
      descripcion: json['descripcion'] as String?,
      rating: _parseDouble(json['rating']),
      totalResenas: (json['totalResenas'] as num?)?.toInt(),
      imagen: (json['imagen'] as String?) ?? primeraImagen,
      recomendacion: json['recomendacion'] as String?,
      tipsFoto: json['tipsFoto'] as String?,
    );
  }

  SpotEntity toEntity() => SpotEntity(
        id: id,
        nombre: nombre,
        direccion: direccion,
        latitud: latitud!,
        longitud: longitud!,
        categoria: categoria,
        localidad: localidad,
        descripcion: descripcion,
        rating: rating,
        totalResenas: totalResenas,
        imagen: imagen,
        recomendacion: recomendacion,
        tipsFoto: tipsFoto,
      );
}
