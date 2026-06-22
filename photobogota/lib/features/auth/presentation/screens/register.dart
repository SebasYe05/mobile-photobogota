import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/controllers/auth_bloc.dart';
import 'package:photobogota/widgets/inputtext.dart';
import 'login.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final usuarioController = TextEditingController();
  final fechaController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();

  DateTime? fechaNacimiento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea tu cuenta'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF806fbe),
      ),
      backgroundColor: const Color(0xFFf5f2eb),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: BlocConsumer<AuthBloc, AuthState>(
            // listener: acciones de un solo disparo (navegar, SnackBar)
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Usuario registrado correctamente"),
                  ),
                );
                // Mandamos al usuario al Login para que inicie sesión
                // con la cuenta que acaba de crear.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            // builder: solo dibuja según el estado actual
            builder: (context, state) {
              final cargando = state is AuthLoading;

              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // <--- Alineado a la izquierda
                children: [
                  const Text(
                    "Photo Bogotá",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0a0a0a),
                    ),
                  ),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 20),

                  // Campos de texto
                  CampoTexto(
                    controller: emailController,
                    label: 'Correo electrónico',
                    icon: Icons.email,
                    tipoTeclado: TextInputType.emailAddress,
                  ),
                  CampoTexto(
                    controller: nombreController,
                    label: 'Nombre',
                    icon: Icons.edit,
                  ),
                  CampoTexto(
                    controller: apellidoController,
                    label: 'Apellido',
                    icon: Icons.edit,
                  ),
                  CampoTexto(
                    controller: usuarioController,
                    label: 'Usuario',
                    icon: Icons.person,
                  ),
                  CampoTexto(
                    controller: fechaController,
                    label: 'Fecha de nacimiento',
                    icon: Icons.calendar_month,
                    soloLectura: true,
                    onTap: () async {
                      DateTime? fecha = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2027),
                      );
                      if (fecha != null) {
                        setState(() {
                          fechaNacimiento = fecha;
                          fechaController.text =
                              '${fecha.day}/${fecha.month}/${fecha.year}';
                        });
                      }
                    },
                  ),
                  CampoTexto(
                    controller: passwordController,
                    label: 'Contraseña',
                    icon: Icons.lock,
                    esPassword: true,
                  ),
                  CampoTexto(
                    controller: confirmarPasswordController,
                    label: 'Confirmar contraseña',
                    icon: Icons.lock_outline,
                    esPassword: true,
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: cargando
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                _disparrarRegistro(context);
                              }
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
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Guardar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.send, color: Colors.white),
                              ],
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Formatea la fecha y dispara el evento hacia el Bloc.
  // Ya no hay jsonEncode, ni http.post, ni try/catch aquí: todo eso
  // vive ahora en el datasource y el repository.
  void _disparrarRegistro(BuildContext context) {
    String fechaFormateada = "";
    if (fechaNacimiento != null) {
      fechaFormateada =
          "${fechaNacimiento!.year}-"
          "${fechaNacimiento!.month.toString().padLeft(2, '0')}-"
          "${fechaNacimiento!.day.toString().padLeft(2, '0')}";
    }

    context.read<AuthBloc>().add(
          RegisterSubmitted(
            nombresCompletos:
                "${nombreController.text} ${apellidoController.text}",
            email: emailController.text,
            nombreUsuario: usuarioController.text,
            contrasena: passwordController.text,
            fechaNacimiento: fechaFormateada,
          ),
        );
  }
}