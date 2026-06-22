import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/controllers/auth_bloc.dart';
import 'package:photobogota/features/auth/presentation/screens/register.dart';

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
      backgroundColor: const Color(0xFFf5f2eb),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: BlocConsumer<AuthBloc, AuthState>(
              // listener: se ejecuta UNA VEZ por cada cambio de estado.
              // Aquí van las acciones "de un solo disparo": navegar, mostrar SnackBar.
              listener: (context, state) {
                if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
                // No navegamos manualmente cuando el estado es Authenticated.
                // El AuthWrapper (más arriba en el árbol, en main.dart)
                // ya escucha este mismo AuthBloc con un BlocBuilder y
                // cambia de pantalla automáticamente hacia el Home/MapScreen.
                // Si navegamos aquí también, las dos navegaciones compiten
                // y termina ganando la que no quieres.
              },
              // builder: reconstruye la UI según el estado actual.
              // Aquí va lo que se "dibuja" (spinner, textos, etc).
              builder: (context, state) {
                final cargando = state is AuthLoading;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const SizedBox(height: 20),

                    const Text(
                      "Accede a tu cuenta",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF806FBE)),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Photo Bogotá",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0a0a0a),
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
                        child: Column(
                          children: [
                            TextField(
                              controller: usuarioController,
                              decoration: InputDecoration(
                                labelText: "Usuario o correo",
                                prefixIcon: const Icon(Icons.person),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            TextField(
                              controller: passwordController,
                              obscureText: ocultarPassword,
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
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                // Si está cargando, deshabilitamos el botón (igual que antes con setState)
                                onPressed: cargando
                                    ? null
                                    : () {
                                        // Ya no llamamos a http directamente.
                                        // Solo disparamos el evento; el Bloc hace el resto.
                                        context.read<AuthBloc>().add(
                                              LoginSubmitted(
                                                usuarioController.text,
                                                passwordController.text,
                                              ),
                                            );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF806fbe),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: cargando
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Ingresar",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    Divider(color: Colors.grey[300], thickness: 1),
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
                          color: Color(0xFF806fbe),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}