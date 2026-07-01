import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/controllers/auth_bloc.dart';
import 'package:photobogota/features/mapa/presentation/screens/mapa_screen.dart';


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
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostSpotScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Color(0xFF806fbe)),
              label: const Text(
                'Publicar Spot'
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Mapa'),
                onTap: () {
                  Navigator.pop(context); // Cierra el Drawer
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Perfil'),
                onTap: () {
                  Navigator.pop(context); // Cierra el Drawer
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.pop(context); 
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.handshake_outlined),
                title: const Text('Ser socio'),
                onTap:() {
                  Navigator.pop(context); 
                }
              ),
            ),
            SafeArea(child: 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pop(context); 
                },
              ),
            ),
            ),
          ]
        ),
      ),
      body: const Center(
        child: MapaScreen(),
      ),
    );
  }
}
