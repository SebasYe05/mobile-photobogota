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
      body: const Center(
        child: Text(
          'Aquí va tu mapa',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
