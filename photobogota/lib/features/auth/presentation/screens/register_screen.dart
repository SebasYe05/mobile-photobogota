import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photobogota/features/auth/presentation/widgets/inputtext.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final usuarioController = TextEditingController();
  final fechaController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();

  DateTime? fechaNacimiento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Bogotá'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF806fbe),
      ),
      backgroundColor: const Color(0xFFf5f2eb),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "Crea tu cuenta",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0a0a0a),
                ),
              ),
              Divider(color: Colors.grey[300], thickness: 1),
              const SizedBox(height: 20),

              // Campos de texto
              CampoTexto(
                controller: emailController,
                label: 'Correo electrónico',
                icon: Icons.email,
                tipoTeclado: TextInputType.emailAddress,
              ),
              CampoTexto(
                controller: nombreController,
                label: 'Nombre',
                icon: Icons.edit,
              ),
              CampoTexto(
                controller: apellidoController,
                label: 'Apellido',
                icon: Icons.edit,
              ),
              CampoTexto(
                controller: usuarioController,
                label: 'Usuario',
                icon: Icons.person,
              ),
              CampoTexto(
                controller: fechaController,
                label: 'Fecha de nacimiento',
                icon: Icons.calendar_month,
                soloLectura: true,
                onTap: () async {
                  DateTime? fecha = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2099),
                  );
                  if (fecha != null) {
                    setState(() {
                      fechaNacimiento = fecha;
                      fechaController.text =
                          '${fecha.day}/${fecha.month}/${fecha.year}';
                    });
                  }
                },
              ),
              CampoTexto(
                controller: passwordController,
                label: 'Contraseña',
                icon: Icons.lock,
                esPassword: true,
              ),
              CampoTexto(
                controller: confirmarPasswordController,
                label: 'Confirmar contraseña',
                icon: Icons.lock_outline,
                esPassword: true,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      registrar();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF806fbe),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Guardar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.send, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registrar() async {
    //Formateo manual de la fecha a "yyyy-MM-dd" para el backend
    String fechaFormateada = "";
    if (fechaNacimiento != null) {
      fechaFormateada =
          "${fechaNacimiento!.year}-"
          "${fechaNacimiento!.month.toString().padLeft(2, '0')}-"
          "${fechaNacimiento!.day.toString().padLeft(2, '0')}";
    }

    // 2. Estructura que coincide con lo que probaste en Thunder Client
    Map<String, dynamic> datos = {
      "nombresCompletos": "${nombreController.text} ${apellidoController.text}",
      "email": emailController.text,
      "nombreUsuario": usuarioController.text,
      "contrasena": passwordController.text,
      "fechaNacimiento": fechaFormateada,
      "telefono": "",
      "fotoPerfil": "",
      "estadoCuenta": true,
      "biografia": "",
      "correoConfirmado": false,
      "roles": ["miembro"],
    };

    try {
      // 3. URL actualizada a la que probaste exitosamente
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8080/api/v1/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(datos),
      );  

      print("Código: ${response.statusCode}");
      print("Respuesta: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario registrado correctamente")),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error ${response.statusCode}: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error de conexión: $e")));
    }
  }
}
