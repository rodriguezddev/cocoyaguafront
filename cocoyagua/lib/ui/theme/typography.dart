import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppTypography {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppTheme.textColor,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28, // Un poco más pequeño que h1
    fontWeight: FontWeight.bold,
    color: AppTheme.textColor,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppTheme.textColor,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppTheme.textColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 14,
    color: AppTheme.textColor,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 16,
    color: AppTheme.textColor,
  );

static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppTheme.textColor,
  );

static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppTheme.textColor,
  );
}
