import 'package:cocoyagua/ui/views/personas/personas_view.dart'; // For Persona model and RolPersona helpers
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class PersonDetailsDialog extends StatelessWidget {
  final Persona persona;

  const PersonDetailsDialog({super.key, required this.persona});

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: AppTypography.body.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTypography.body.copyWith(
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Detalles de Persona',
        style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDetailRow(context, 'Nombre Completo', persona.nombreCompleto),
            _buildDetailRow(context, 'Tipo de Documento', persona.tipoDocumento),
            _buildDetailRow(context, 'Nro. Documento', persona.nroDocumento),
            _buildDetailRow(context, 'Género', persona.genero),
            _buildDetailRow(context, 'Tipo de Persona', persona.tipoPersona),
            _buildDetailRow(context, 'Roles', persona.roles.map(rolPersonaToString).join(', ')), // Mostrar Roles
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cerrar', style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.md),
      ),
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}