import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType tipoTeclado;
  final bool esPassword;
  final VoidCallback? onTap;
  final bool soloLectura;

  const CampoTexto({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.tipoTeclado = TextInputType.text,
    this.esPassword = false,
    this.onTap,
    this.soloLectura = false,
  });

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  bool ocultar = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.tipoTeclado,
        obscureText: widget.esPassword ? ocultar : false,
        readOnly: widget.soloLectura,
        onTap: widget.onTap,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.esPassword
              ? IconButton(
                  icon: Icon(ocultar ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => ocultar = !ocultar),
                )
              : null,
        ),
      ),
    );
  }
}