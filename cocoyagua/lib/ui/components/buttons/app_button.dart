import 'package:flutter/material.dart';
import '../../theme/app_theme.dart'; // Asegúrate de que AppTheme esté importado si lo usas para colores

// Definición del enum para los tipos de botón
enum AppButtonKind {
  primary,
  secondary,
  ghost,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Puede ser null si el botón está deshabilitado por lógica externa o por 'loading'
  final bool loading;
  final AppButtonKind kind;
  final double? width;
  final double? height;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.kind = AppButtonKind.primary, // Valor por defecto
    this.loading = false,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = loading
        ? const SizedBox(
            width: 18, // Ajusta el tamaño según tu diseño
            height: 18, // Ajusta el tamaño según tu diseño
            child: CircularProgressIndicator(
              strokeWidth: 2,
              // Considera establecer el color del indicador para que coincida con el texto del botón
              // valueColor: AlwaysStoppedAnimation<Color>(/* color del texto del botón */),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Para que el Row no ocupe todo el ancho innecesariamente
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18), // Puedes ajustar el tamaño del ícono
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    final effectiveOnPressed = loading ? null : onPressed;

    switch (kind) {
      case AppButtonKind.primary:
        return SizedBox(
          width: width, //  ?? double.infinity, // Considera si siempre debe ser double.infinity o ajustarse al contenido
          height: height ?? 48, // Un alto por defecto podría ser útil
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Ajustado
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            onPressed: effectiveOnPressed,
            child: buttonChild,
          ),
        );
      case AppButtonKind.secondary:
        return SizedBox(
          width: width,
          height: height ?? 48,
          child: OutlinedButton( // Usar OutlinedButton para secundario es una opción común
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              foregroundColor: Theme.of(context).primaryColor, // Color del texto/icono
              side: BorderSide(color: Theme.of(context).primaryColor), // Borde
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            onPressed: effectiveOnPressed,
            child: buttonChild,
          ),
        );
      case AppButtonKind.ghost:
        return TextButton( // TextButton es ideal para 'ghost'
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Menor padding para ghost
            foregroundColor: AppTheme.textPrimaryColor, // O el color que prefieras para el texto
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: buttonChild,
        );
    }
  }
}
