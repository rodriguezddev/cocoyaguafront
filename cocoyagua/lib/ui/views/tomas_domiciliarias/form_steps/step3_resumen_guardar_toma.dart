// lib/ui/views/tomas_domiciliarias/form_steps/step3_resumen_guardar_toma.dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';
import '../../../theme/typography.dart';

class Step3ResumenGuardarToma extends StatelessWidget {
  final bool isMobile;
  final String documentoImpresoId;
  final String empleado;
  final String fechaRegistro;
  final String ida;
  final String tomaDomiciliariaId;
  final String estado;
  final String usoSuministro;
  final String departamento;
  final String municipio;
  final String localidad1;
  final String? localidad2;
  final String? localidad3;
  final String claveCatastral;
  final String coordenadas;

  const Step3ResumenGuardarToma({
    super.key,
    required this.isMobile,
    required this.documentoImpresoId,
    required this.empleado,
    required this.fechaRegistro,
    required this.ida,
    required this.tomaDomiciliariaId,
    required this.estado,
    required this.usoSuministro,
    required this.departamento,
    required this.municipio,
    required this.localidad1,
    this.localidad2,
    this.localidad3,
    required this.claveCatastral,
    required this.coordenadas,
  });

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty || value == 'N/A')
      return const SizedBox.shrink(); // No mostrar si está vacío o N/A
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isMobile ? 2 : 1,
            child: Text(
              label,
              style: AppTypography.body
                  .copyWith(color: AppTheme.textPrimaryColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTypography.body
                  .copyWith(color: AppTheme.textColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de la Información',
            style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            'Por favor, verifique que todos los datos sean correctos antes de guardar.',
            style:
                AppTypography.body.copyWith(color: AppTheme.textColor),
          ),
          const SizedBox(height: Spacing.md),
          Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Datos Generales',
                    style: AppTypography.h2
                        .copyWith(color: AppTheme.primaryColor),
                  ),
                  const Divider(),
                  _buildDetailRow('Documento Impreso ID:', documentoImpresoId),
                  _buildDetailRow('Empleado Asignado:', empleado),
                  _buildDetailRow('Fecha de Registro:', fechaRegistro),
                  _buildDetailRow('IDA:', ida),
                  _buildDetailRow('Toma Domiciliaria ID:', tomaDomiciliariaId),
                  _buildDetailRow('Estado:', estado),
                  _buildDetailRow('Uso de Suministro:', usoSuministro),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'Datos de Ubicación',
                    style: AppTypography.h2
                        .copyWith(color: AppTheme.primaryColor),
                  ),
                  const Divider(),
                  _buildDetailRow('Departamento:', departamento),
                  _buildDetailRow('Municipio:', municipio),
                  _buildDetailRow('Localidad Principal:', localidad1),
                  if (localidad2 != null && localidad2!.isNotEmpty)
                    _buildDetailRow('Localidad 2:', localidad2!),
                  if (localidad3 != null && localidad3!.isNotEmpty)
                    _buildDetailRow('Localidad 3:', localidad3!),
                  _buildDetailRow('Clave Catastral:', claveCatastral),
                  _buildDetailRow('Coordenadas:', coordenadas),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
