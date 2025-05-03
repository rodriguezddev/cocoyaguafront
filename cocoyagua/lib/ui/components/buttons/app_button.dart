import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool primary;
  final bool loading;
  final double? width; // Nuevo: ancho opcional
  final double? height; // Nuevo: alto opcional

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.primary = true,
    this.loading = false,
    this.width, // Nuevo
    this.height, // Nuevo
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      backgroundColor:
          primary ? Theme.of(context).primaryColor : Colors.grey[300],
      foregroundColor: primary ? Colors.white : Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
    );

    return SizedBox(
      width: width ?? double.infinity, // Ocupa todo el ancho por defecto
      height: height, // Ajustable si se desea
      child: ElevatedButton(
        style: style,
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(text),
      ),
    );
  }
}
