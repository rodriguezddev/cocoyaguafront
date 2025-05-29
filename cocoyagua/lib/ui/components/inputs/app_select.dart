import 'package:cocoyagua/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppSelect<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> options;
  final String Function(T) labelBuilder;
  final void Function(T?)? onChanged;
  final Widget? hint;
  final String? Function(T?)? validator;

  const AppSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.labelBuilder,
    this.onChanged,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (value != null && !options.contains(value)) {
      print("Warning: El valor seleccionado no está en la lista de opciones.");
    }

    final uniqueOptions = options.toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint is Text ? (hint as Text).data : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFFC4CCD0),
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFFC4CCD0),
                width: 1.0,
              ),
            ),
          ),
          validator: validator,
          hint: hint,
          items: uniqueOptions.map((T option) {
            return DropdownMenuItem<T>(
              value: option,
              child: Text(labelBuilder(option)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
