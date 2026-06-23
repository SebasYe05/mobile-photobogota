import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photobogota/features/auth/presentation/screens/register_screen.dart';
import 'package:http/http.dart' as http;
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  bool ocultarPassword = true;
  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f2eb),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                const SizedBox(height: 40),
                const SizedBox(height: 20),

                const Text(
                  "Accede a tu cuenta",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF806FBE)),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Photo Bogotá",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0a0a0a),
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: usuarioController,
                          decoration: InputDecoration(
                            labelText: "Usuario o correo",
                            prefixIcon: const Icon(Icons.person),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide
                                  .none, // Borde invisible para diseño limpio
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: passwordController,
                          obscureText: ocultarPassword,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                ocultarPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  ocultarPassword = !ocultarPassword;
                                });
                              },
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide
                                  .none, // Borde invisible para diseño limpio
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: cargando ? null : login,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF806fbe),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: cargando
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Ingresar",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: 25),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Registro()),
                    );
                  },
                  child: const Text(
                    "¿Eres nuevo en Photo Bogotá? Crear cuenta",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF806fbe),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      cargando = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8080/api/v1/auth/login"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({
          "login": usuarioController.text,
          "contrasena": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> datos = jsonDecode(response.body);

        print(datos);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario o contraseña incorrectos")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() {
      cargando = false;
    });
  }
}
