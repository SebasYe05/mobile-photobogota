import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobogota/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:photobogota/features/auth/presentation/controllers/auth_bloc.dart';

class VerifyCode extends StatefulWidget {
  final String email;
  const VerifyCode({super.key, required this.email});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f2eb),
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
                  "Verifica tu identidad",
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
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        } else if (state is VerifyCodeSuccess) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResetPassword(email: widget.email, code: codeController.text.trim()),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final cargando = state is AuthLoading;
                        return Column(
                          children: [
                            TextField(
                              controller: codeController,
                              enabled: !cargando,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Código de verificación",
                                prefixIcon: const Icon(Icons.numbers),
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
                                onPressed: cargando ? null : _verifyCode,
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
                                        "Verificar código",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Volver",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF806fbe),
                      fontWeight: FontWeight.bold,
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

  void _verifyCode() {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa el código de verificación")),
      );
      return;
    }
    context.read<AuthBloc>().add(VerifyCodeSubmitted(widget.email, code));
  }
}
