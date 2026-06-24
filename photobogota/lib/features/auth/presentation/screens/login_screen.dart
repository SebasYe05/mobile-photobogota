import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/screens/register_screen.dart';
import 'package:photobogota/features/auth/presentation/controllers/auth_bloc.dart';
import 'package:photobogota/core/theme/theme.dart';
import 'package:photobogota/features/auth/presentation/widgets/inputtext.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
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
              children: [
                const SizedBox(height: 40),
                const SizedBox(height: 20),
                const Text(
                  "Accede a tu cuenta",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.primaryColor,
                    fontFamily: 'SF Pro',
                  ),
                ),
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
                Padding(
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
                      return Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CampoTexto(
                              controller: usuarioController,
                              label: 'Usuario o correo',
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu usuario o correo';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CampoTexto(
                              controller: passwordController,
                              label: 'Contraseña',
                              icon: Icons.lock,
                              esPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                if (value.length < 8) {
                                  return 'La contraseña debe tener al menos 8 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: cargando
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          _login();
                                        }
                                      },
                                child: cargando
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text("Ingresar"),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Divider(color: AppTheme.borderColor, thickness: 1),
                const SizedBox(height: 25),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "¿Eres nuevo en Photo Bogotá? ",
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        color: AppTheme.darkColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Registro()),
                        );
                      },
                      child: const Text(
                        "Crear cuenta",
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
