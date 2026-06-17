import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'presentation/screens/auth_wrapper.dart'; // Importas tu wrapper

void main() {
  runApp(const PhotoBogotaApp());
}

class PhotoBogotaApp extends StatelessWidget {
  const PhotoBogotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Bogotá',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(), // El Wrapper decide qué pantalla mostrar
    );
  }
}