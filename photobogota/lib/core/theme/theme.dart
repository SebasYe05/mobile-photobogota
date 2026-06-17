import 'package:flutter/material.dart';

class AppTheme {

  // Definición de los colores basados en tu index.css
  static const Color backgroundColor = Color(0xFFF5F2EB);
  static const Color primaryColor = Color(0xFF806FBE);
  static const Color primaryHover = Color(0xFF5C4D94);
  static const Color darkColor = Color(0xFF212529);
  static const Color mutedColor = Color(0xFF6C757D);
  static const Color borderColor = Color(0xFFE8E8E8);

  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      
      // Configuración de la Tipografía (SF Pro / Poppins)
      fontFamily: 'SF Pro',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: darkColor, fontSize: 32, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: darkColor, fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: darkColor, fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: mutedColor, fontSize: 14, fontWeight: FontWeight.normal),
      ),

      // Estilo global para los Botones Redondeados (Pill)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // --pill: 50px
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'SF Pro',
          ),
        ),
      ),

      // Estilo para los Inputs / Campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}