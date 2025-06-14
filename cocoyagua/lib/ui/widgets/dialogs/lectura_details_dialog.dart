import '../../../models/lectura_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class LecturaDetailsDialog extends StatelessWidget {
  final Lectura lectura;

  const LecturaDetailsDialog({super.key, required this.lectura});

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
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
                color: valueColor ?? AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAnomala = lectura.consumo < 0 ||
        lectura.estadoLectura == EstadoLectura.anomala; // Simplificado
    // TODO: Implementar lógica más robusta para lecturas anómalas (e.g., consumo muy alto vs histórico)

    return AlertDialog(
      title: Text(
        'Detalles de Lectura',
        style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDetailRow(context, 'ID Lectura', lectura.lecturaId),
            _buildDetailRow(context, 'Fecha de Lectura',
                DateFormat('dd/MM/yyyy HH:mm').format(lectura.fechaLectura)),
            _buildDetailRow(context, 'Medidor ID', lectura.medidorId),
            _buildDetailRow(context, 'Lectura Anterior',
                '${lectura.lecturaAnterior.toStringAsFixed(2)} ${unidadMedidaToString(lectura.unidadMedida)}'),
            _buildDetailRow(context, 'Lectura Actual',
                '${lectura.lecturaActual.toStringAsFixed(2)} ${unidadMedidaToString(lectura.unidadMedida)}'),
            if (lectura.lecturaInicio != null)
              _buildDetailRow(context, 'Lectura Inicio',
                  '${lectura.lecturaInicio!.toStringAsFixed(2)} ${unidadMedidaToString(lectura.unidadMedida)}'),
            _buildDetailRow(context, 'Consumo',
                '${lectura.consumo.toStringAsFixed(2)} ${unidadMedidaToString(lectura.unidadMedida)}',
                valueColor: isAnomala ? AppTheme.dangerColor : null),
            _buildDetailRow(context, 'Unidad de Medida',
                unidadMedidaToString(lectura.unidadMedida)),
            if (lectura.productoId != null)
              _buildDetailRow(context, 'Producto ID', lectura.productoId!),
            _buildDetailRow(context, 'Empleado ID', lectura.empleadoId),
            _buildDetailRow(
                context, 'Estado', estadoLecturaToString(lectura.estadoLectura),
                valueColor: isAnomala ? AppTheme.dangerColor : null),
            if (lectura.observaciones != null &&
                lectura.observaciones!.isNotEmpty)
              _buildDetailRow(context, 'Observaciones', lectura.observaciones!),

            const SizedBox(height: Spacing.md),
            if (isAnomala)
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                    color: AppTheme.dangerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Spacing.xs),
                    border: Border.all(color: AppTheme.dangerColor)),
                child: Text('¡Alerta! Lectura anómala detectada.',
                    style: AppTypography.body.copyWith(
                        color: AppTheme.dangerColor,
                        fontWeight: FontWeight.bold)),
              ),
            const SizedBox(height: Spacing.md),
            // Placeholder para integración con factura
            TextButton.icon(
                onPressed: () {/* TODO: Lógica para ver factura asociada */},
                icon: const Icon(Icons.receipt_long),
                label: const Text('Ver Factura Asociada (si existe)')),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cerrar',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.md)),
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}
