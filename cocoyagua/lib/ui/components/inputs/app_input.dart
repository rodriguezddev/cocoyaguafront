import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AppInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isLabelVisible;
  final int? maxLines;

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
