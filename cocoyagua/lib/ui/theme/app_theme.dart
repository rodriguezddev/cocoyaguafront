import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static const Color primaryColor = Color(0xFF39ADCD);
  static const Color secondaryColor = Color(0xFF00CC99);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF94A4AD);
  static const Color textPrimaryColor = Color(0xFF3A474E);
  static const Color texttableColor = Color(0xFF596E79);
  static const Color dangerColor = Color(0xFFD32F2F);
  // Tema claro
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    dataTableTheme: const DataTableThemeData(
      dividerThickness: 0.0,
      headingRowColor:
          MaterialStatePropertyAll(Color(0xFFF5F5F5)),
      dataRowColor: MaterialStatePropertyAll(
          Colors.transparent),
    ),
    dividerColor: Colors
        .transparent, 
  );


  // Tema oscuro (opcional)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    ),
  );

  
}
