import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/screens/login.dart';
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

        // Unauthenticated (logout o sin token)
        return const Login();
      },
    );
  }
}

