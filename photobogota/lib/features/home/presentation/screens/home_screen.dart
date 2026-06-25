import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/controllers/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Bogotá'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF806fbe),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF806fbe),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Photo Bogotá',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: const Text('Mapa'),
              onTap: () {
                // Navegar a la pantalla del mapa
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                // Navegar a la pantalla del perfil
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                // Navegar a la pantalla de configuración
                Navigator.pop(context);
              },
            ),
          ]
        ),
      ),
      body: const Center(
        child: Text(
          'Aquí va tu mapa',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
