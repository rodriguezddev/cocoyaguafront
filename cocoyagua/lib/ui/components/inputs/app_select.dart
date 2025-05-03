import 'package:flutter/material.dart';

class AppSelect<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> options;
  final String Function(T) labelBuilder;
  final void Function(T?)? onChanged;

  const AppSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.labelBuilder,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
      items: options.map((T option) {
        return DropdownMenuItem<T>(
          value: option,
          child: Text(labelBuilder(option)),
        );
      }).toList(),
    );
  }
}
