import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/auth_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Retorna tu MapScreen() cuando el BLoC confirme que hay sesión
          return const Scaffold(body: Center(child: Text("Aquí va tu Mapa Screen"))); 
        }
        if (state is AuthLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        // Si no está autenticado o falla, directo al Login
        return const LoginScreen(); 
      },
    );
  }
}

// Un LoginScreen rápido de ejemplo para ver cómo disparar el evento
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Así disparas la petición a Spring Boot mediante BLoC:
            context.read<AuthBloc>().add(LoginSubmitted('juan_marin', 'password123'));
          },
          child: const Text("Iniciar Sesión"),
        ),
      ),
    );
  }
}