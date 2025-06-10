import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:flutter/services.dart'; // Necesario para FilteringTextInputFormatter

class AppInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isLabelVisible;
  final int? maxLines;
  final bool readOnly; // Nueva propiedad
  final VoidCallback? onTap; // Nueva propiedad
  final List<TextInputFormatter>? inputFormatters; // Nueva propiedad
  final ValueChanged<String>? onChanged; // Nueva propiedad

  const AppInput({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.validator,
    this.isLabelVisible = true,
    this.maxLines = 1,
    this.readOnly = false, // Valor por defecto
    this.onTap,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.textColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isLabelVisible
            ? Text(
                label ?? '',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines, // Aplicar maxLines
          readOnly: readOnly, // Aplicar readOnly
          onTap: onTap, // Aplicar onTap
          inputFormatters: inputFormatters, // Aplicar inputFormatters
          onChanged: onChanged, // Aplicar onChanged
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
            prefixIcon: icon != null
                ? Icon(icon, color: textColor)
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFFC4CCD0),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFFC4CCD0),
                width: 1.0,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          validator: validator, // Usar el validador
        ),
      ],
    );
  }
}
