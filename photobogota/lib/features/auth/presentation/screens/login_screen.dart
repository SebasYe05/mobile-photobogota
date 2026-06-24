import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/screens/register_screen.dart';
import 'package:photobogota/features/auth/presentation/controllers/auth_bloc.dart';
import 'package:photobogota/core/theme/theme.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  bool ocultarPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
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
                  style: TextStyle(fontSize: 16, color: AppTheme.primaryColor, fontFamily: 'SF Pro'),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Photo Bogotá",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkColor,
                    fontFamily: 'SF Pro',
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
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        final cargando = state is AuthLoading;
                        return Column(
                          children: [
                            TextField(
                              controller: usuarioController,
                              enabled: !cargando,
                              decoration: InputDecoration(
                                labelText: "Usuario o correo",
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: passwordController,
                              obscureText: ocultarPassword,
                              enabled: !cargando,
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
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: cargando ? null : _login,
                                child: cargando
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Ingresar",
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Divider(color: AppTheme.borderColor, thickness: 1),
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
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro',
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

  void _login() {
    final username = usuarioController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa usuario y contraseña")),
      );
      return;
    }

    context.read<AuthBloc>().add(LoginSubmitted(username, password));
  }
}
