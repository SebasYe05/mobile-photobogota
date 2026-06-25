import '../../domain/entities/opcion_filtro_entity.dart';

class OpcionFiltroModel {
  final String value;
  final String label;

  const OpcionFiltroModel({required this.value, required this.label});

  /// Acepta tanto `{value, label}` (formato ya pensado para selects)
  /// como `{id, nombre}` (formato típico de un backend REST), para no
  /// depender de que el backend devuelva exactamente el shape de react-select.
  factory OpcionFiltroModel.fromJson(Map<String, dynamic> json) {
    final value = json['value'] ?? json['id'];
    final label = json['label'] ?? json['nombre'];
    return OpcionFiltroModel(
      value: value?.toString() ?? '',
      label: label?.toString() ?? '',
    );
  }

  OpcionFiltroEntity toEntity() =>
      OpcionFiltroEntity(value: value, label: label);
}
