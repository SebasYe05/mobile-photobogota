/// Filtros activos aplicados al mapa. Equivalente al objeto `filtros`
/// que se pasa entre FiltrosMapa.jsx -> MapaContent.jsx -> MapaBogota.jsx.
class FiltrosMapaEntity {
  final String? categoria;
  final String? localidad;

  const FiltrosMapaEntity({this.categoria, this.localidad});

  const FiltrosMapaEntity.vacio() : categoria = null, localidad = null;

  bool get estaVacio => categoria == null && localidad == null;

  Map<String, dynamic> toQueryParams() => {
        if (categoria != null) 'categoria': categoria,
        if (localidad != null) 'localidad': localidad,
      };
}
