import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/screens/login_screen.dart';
import 'package:photobogota/features/home/presentation/screens/home_screen.dart';
import '../controllers/auth_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      // buildWhen controla CUÁNDO este widget se reconstruye.
      // Se ejecuta en cada emit() del AuthBloc, ANTES del builder.
      // Si devuelve false, el builder NO se vuelve a ejecutar
      // y la pantalla actual se queda como está (no se reconstruye).
      buildWhen: (previous, current) {
        // Este BlocBuilder solo le importan 3 estados:
        // - AuthInitial: para mostrar el spinner de arranque
        // - Authenticated: para mostrar el Home
        // - Unauthenticated: para mostrar el Login
        //
        // AuthLoading y AuthFailure son estados que pertenecen
        // al INTENTO de login/registro (los maneja el BlocConsumer
        // que está dentro de la pantalla Login). Si dejamos que
        // este BlocBuilder también reaccione a ellos, reconstruiría
        // TODO el árbol (incluyendo un Login nuevo desde cero) justo
        // cuando el SnackBar está intentando aparecer, y por eso
        return current is AuthInitial ||
            current is Authenticated ||
            current is Unauthenticated;
      },

      // builder solo se ejecuta cuando buildWhen devolvió true.
      // Aquí decidimos QUÉ pantalla mostrar según el estado actual.
      builder: (context, state) {
        // Caso 1: la app recién abrió y todavía está revisando
        // si hay un token guardado (AuthCheckRequested).
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Caso 2: hay token válido (o el login fue exitoso) →
        // mandamos al usuario a la pantalla principal.
        if (state is Authenticated) {
          return const HomeScreen();
        }

        // Caso 3 (default): Unauthenticated, o cualquier estado
        // que no filtramos arriba → mostramos el Login.
        // Nota: gracias a buildWhen, este "return Login()" NO se
        // vuelve a ejecutar cuando llega AuthLoading o AuthFailure,
        // así que el Login que ya está en pantalla se mantiene
        // intacto (con su propio BlocConsumer activo) y el SnackBar
        // sí puede mostrarse.
        return const Login();
      },
    );
  }
}
