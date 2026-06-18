import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/auth_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Cargando o verificando token inicial → spinner
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Autenticado → pantalla principal
        if (state is Authenticated) {
          return const Scaffold(
            body: Center(child: Text('Aquí va tu MapScreen')),
          );
        }

        // Falló el login → LoginScreen con mensaje de error
        if (state is AuthFailure) {
          return LoginScreen(errorMessage: state.message);
        }

        // Unauthenticated (logout o sin token)
        return const LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  final String? errorMessage;

  const LoginScreen({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Muestra el error si viene de AuthFailure
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  LoginSubmitted('juan_marin', 'password123'),
                );
              },
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
