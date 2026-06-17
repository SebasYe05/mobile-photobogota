import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // Simulación de lectura de token (aquí usarás FlutterSecureStorage o SharedPreferences)
  Future<bool> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula leer el storage
    // Cambia a 'false' para ver cómo te manda al Login
    return true; 
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthStatus(),
      builder: (context, snapshot) {
        // Mientras lee el almacenamiento, muestra una pantalla de carga estética
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF806FBE)),
              ),
            ),
          );
        }

        // Si está autenticado, va al mapa. Si no, al Login.
        if (snapshot.data == true) {
          //return const MapScreen();
          return const Scaffold(
            body: Center(
              child: Text(
                'Mapa de Bogotá',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          //return const LoginScreen();
          return const Scaffold(
            body: Center(
              child: Text(
                'Inicia sesión para ver el mapa',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }
      },
    );
  }
}