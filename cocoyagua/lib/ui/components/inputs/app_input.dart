import 'package:flutter/material.dart';
import '../../theme/app_theme.dart'; // Asegúrate de importar esto si no lo has hecho

class AppInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;

  const AppInput({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.textColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: TextStyle(color: textColor), // Color del texto
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                TextStyle(color: textColor.withOpacity(0.6)), // Hint más claro
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
