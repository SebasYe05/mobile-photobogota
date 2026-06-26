import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/opcion_filtro_entity.dart';
import '../../domain/entities/filtros_mapa_entity.dart';

/// Panel de filtros del mapa. Equivalente a FiltrosMapa.jsx, adaptado a
/// móvil: en vez de dos <Select> de react-select, cada filtro es un chip
/// que abre un bottom sheet con buscador para elegir la opción.
class FiltrosMapaWidget extends StatefulWidget {
  final List<OpcionFiltroEntity> categorias;
  final List<OpcionFiltroEntity> localidades;
  final FiltrosMapaEntity filtrosIniciales;
  final void Function(FiltrosMapaEntity filtros) onAplicar;
  final VoidCallback onLimpiar;

  const FiltrosMapaWidget({
    super.key,
    required this.categorias,
    required this.localidades,
    required this.filtrosIniciales,
    required this.onAplicar,
    required this.onLimpiar,
  });

  @override
  State<FiltrosMapaWidget> createState() => _FiltrosMapaWidgetState();
}

class _FiltrosMapaWidgetState extends State<FiltrosMapaWidget> {
  OpcionFiltroEntity? _categoria;
  OpcionFiltroEntity? _localidad;

  @override
  void initState() {
    super.initState();
    _sincronizarSeleccion();
  }

  @override
  void didUpdateWidget(covariant FiltrosMapaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filtrosIniciales != widget.filtrosIniciales) {
      _sincronizarSeleccion();
    }
  }

  void _sincronizarSeleccion() {
    _categoria = widget.categorias
        .where((c) => c.value == widget.filtrosIniciales.categoria)
        .firstOrNull;
    _localidad = widget.localidades
        .where((l) => l.value == widget.filtrosIniciales.localidad)
        .firstOrNull;
  }

  Future<void> _abrirSelector({
    required String titulo,
    required List<OpcionFiltroEntity> opciones,
    required OpcionFiltroEntity? seleccionActual,
    required void Function(OpcionFiltroEntity?) onSeleccionar,
  }) async {
    final resultado = await showModalBottomSheet<OpcionFiltroEntity?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SelectorBottomSheet(
        titulo: titulo,
        opciones: opciones,
        seleccionActual: seleccionActual,
      ),
    );

    // `resultado` puede ser null (sin selección / "Todas") explícitamente
    // devuelto por el sheet, así que usamos un sentinel para distinguir
    // "no se tocó nada" de "se eligió Todas".
    if (resultado != _sinCambios) {
      setState(() => onSeleccionar(resultado));
    }
  }

  static const _sinCambios = OpcionFiltroEntity(value: '__sin_cambios__', label: '');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Filtrar spots',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FiltroChip(
                  icon: Icons.category_rounded,
                  placeholder: 'Todas las categorías',
                  seleccion: _categoria?.label,
                  onTap: () => _abrirSelector(
                    titulo: 'Categoría',
                    opciones: widget.categorias,
                    seleccionActual: _categoria,
                    onSeleccionar: (v) => _categoria = v,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FiltroChip(
                  icon: Icons.location_on_rounded,
                  placeholder: 'Todas las localidades',
                  seleccion: _localidad?.label,
                  onTap: () => _abrirSelector(
                    titulo: 'Localidad',
                    opciones: widget.localidades,
                    seleccionActual: _localidad,
                    onSeleccionar: (v) => _localidad = v,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _categoria = null;
                      _localidad = null;
                    });
                    widget.onLimpiar();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.bgSoftColor,
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Limpiar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => widget.onAplicar(
                    FiltrosMapaEntity(
                      categoria: _categoria?.value,
                      localidad: _localidad?.value,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Aplicar filtros',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final String? seleccion;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.icon,
    required this.placeholder,
    required this.seleccion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tieneSeleccion = seleccion != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: tieneSeleccion ? AppTheme.bgSoftColor : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: tieneSeleccion ? AppTheme.primaryColor.withOpacity(0.4) : AppTheme.borderColor,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                seleccion ?? placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: tieneSeleccion ? FontWeight.w600 : FontWeight.normal,
                  color: tieneSeleccion ? AppTheme.darkColor : AppTheme.mutedColor,
                ),
              ),
            ),
            Icon(Icons.expand_more_rounded, size: 18, color: AppTheme.mutedColor),
          ],
        ),
      ),
    );
  }
}

class _SelectorBottomSheet extends StatefulWidget {
  final String titulo;
  final List<OpcionFiltroEntity> opciones;
  final OpcionFiltroEntity? seleccionActual;

  const _SelectorBottomSheet({
    required this.titulo,
    required this.opciones,
    required this.seleccionActual,
  });

  @override
  State<_SelectorBottomSheet> createState() => _SelectorBottomSheetState();
}

class _SelectorBottomSheetState extends State<_SelectorBottomSheet> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    final filtradas = widget.opciones
        .where((o) => o.label.toLowerCase().contains(_busqueda.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.lightColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.titulo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context,
                          const OpcionFiltroEntity(value: '__sin_cambios__', label: '')),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (v) => setState(() => _busqueda = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    filled: true,
                    fillColor: AppTheme.backgroundColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  children: [
                    _OpcionTile(
                      label: 'Todas',
                      seleccionado: widget.seleccionActual == null,
                      onTap: () => Navigator.pop(context, null),
                    ),
                    ...filtradas.map((o) => _OpcionTile(
                          label: o.label,
                          seleccionado: widget.seleccionActual?.value == o.value,
                          onTap: () => Navigator.pop(context, o),
                        )),
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

class _OpcionTile extends StatelessWidget {
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;

  const _OpcionTile({
    required this.label,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: seleccionado ? AppTheme.bgSoftColor : null,
      title: Text(
        label,
        style: TextStyle(
          fontWeight: seleccionado ? FontWeight.w700 : FontWeight.normal,
          color: seleccionado ? AppTheme.primaryColor : AppTheme.darkColor,
        ),
      ),
      trailing: seleccionado
          ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor)
          : null,
    );
  }
}

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
