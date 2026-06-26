import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/widgets/inputtext.dart';
import 'package:photobogota/features/auth/presentation/controllers/auth_bloc.dart';
import 'package:photobogota/features/auth/presentation/screens/login_screen.dart';
import 'package:photobogota/core/theme/theme.dart';

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
        title: const Text('Photobogotá'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          // BlocConsumer envuelve todo el formulario para poder reaccionar
          // a RegisterSuccess / AuthFailure y mostrar el spinner en el botón.
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Usuario registrado correctamente"),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              } else if (state is AuthFailure) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                });
              }
            },
            builder: (context, state) {
              final cargando = state is AuthLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Crea tu cuenta",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkColor,
                      fontFamily: 'SF Pro',
                    ),
                  ),
                  Divider(color: AppTheme.borderColor, thickness: 1),
                  const SizedBox(height: 20),

                  // Campos de texto
                  CampoTexto(
                    controller: emailController,
                    label: 'Correo electrónico',
                    icon: Icons.email,
                    tipoTeclado: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo electrónico';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$',
                      ).hasMatch(value)) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  CampoTexto(
                    controller: nombreController,
                    label: 'Nombre',
                    icon: Icons.edit,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu nombre';
                      }
                      return null;
                    },
                  ),
                  CampoTexto(
                    controller: apellidoController,
                    label: 'Apellido',
                    icon: Icons.edit,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu apellido';
                      }
                      return null;
                    },
                  ),
                  CampoTexto(
                    controller: usuarioController,
                    label: 'Usuario',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu usuario';
                      }
                      return null;
                    },
                  ),
                  CampoTexto(
                    controller: fechaController,
                    label: 'Fecha de nacimiento',
                    icon: Icons.calendar_month,
                    soloLectura: true,
                    onTap: () async {
                      DateTime? fecha = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(
                          Duration(days: 365 * 18),
                        ),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now().subtract(
                          Duration(days: 365 * 18),
                        ),
                      );
                      if (fecha != null) {
                        setState(() {
                          fechaNacimiento = fecha;
                          fechaController.text =
                              '${fecha.day}/${fecha.month}/${fecha.year}';
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecciona tu fecha de nacimiento';
                      }
                      if (fechaNacimiento != null) {
                        final edad =
                            DateTime.now()
                                .difference(fechaNacimiento!)
                                .inDays ~/
                            365;
                        if (edad < 18) {
                          return 'Debes tener al menos 18 años';
                        }
                      }
                      return null;
                    },
                  ),
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
                  CampoTexto(
                    controller: confirmarPasswordController,
                    label: 'Confirmar contraseña',
                    icon: Icons.lock_outline,
                    esPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirma tu contraseña';
                      }
                      if (value != passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
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
                          ? const CircularProgressIndicator(color: Colors.white)
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
  // Ya no hay Dio, ni try/catch aquí: todo eso vive en el
  // datasource y el repository, igual que en login.
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
        nombresCompletos: "${nombreController.text} ${apellidoController.text}",
        email: emailController.text,
        nombreUsuario: usuarioController.text,
        contrasena: passwordController.text,
        fechaNacimiento: fechaFormateada,
      ),
    );
  }
}
