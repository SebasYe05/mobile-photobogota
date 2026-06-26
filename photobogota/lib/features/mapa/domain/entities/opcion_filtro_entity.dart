/// Una opción de filtro (categoría o localidad), equivalente al
/// formato `{ value, label }` que usa react-select en la web.
class OpcionFiltroEntity {
  final String value;
  final String label;

  const OpcionFiltroEntity({required this.value, required this.label});

  @override
  bool operator ==(Object other) =>
      other is OpcionFiltroEntity && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
