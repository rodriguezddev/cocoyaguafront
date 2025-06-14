import 'package:cocoyagua/models/pedido_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class PedidoDetailsDialog extends StatelessWidget {
  final Pedido pedido;

  const PedidoDetailsDialog({super.key, required this.pedido});

  Widget _buildDetailRow(BuildContext context, String label, String? value, {Color? valueColor}) {
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
              value ?? 'N/A',
              style: AppTypography.body.copyWith(
                color: valueColor ?? AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    if (pedido.detalles.isEmpty) {
      return const Text('No hay productos en este pedido.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pedido.detalles.map((detalle) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: Spacing.xs),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detalle.productoNombre, style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.bold)),
                _buildDetailRow(context, 'Cantidad', detalle.cantidad.toString()),
                _buildDetailRow(context, 'Precio Unit.', detalle.precioUnitario.toStringAsFixed(2)),
                if (detalle.descuentoPorcentaje != null && detalle.descuentoPorcentaje! > 0)
                  _buildDetailRow(context, 'Descuento', '${(detalle.descuentoPorcentaje! * 100).toStringAsFixed(0)}%'),
                _buildDetailRow(context, 'Total Línea', detalle.totalLinea.toStringAsFixed(2)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Detalles del Pedido',
        style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDetailRow(context, 'Nº Pedido', pedido.pedidoId),
            _buildDetailRow(context, 'Fecha Pedido', DateFormat('dd/MM/yyyy').format(pedido.fechaPedido)),
            _buildDetailRow(context, 'Cliente', pedido.clienteId), // Idealmente mostrar nombre del cliente
            _buildDetailRow(context, 'Empleado', pedido.empleadoId), // Idealmente mostrar nombre del empleado
            _buildDetailRow(context, 'Estado', estadoPedidoToString(pedido.estadoPedido)),
            
            const SizedBox(height: Spacing.md),
            Text('Productos:', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
            _buildProductDetails(context),
            
            const SizedBox(height: Spacing.md),
            Text('Datos de Envío:', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
            _buildDetailRow(context, 'Fecha Envío', pedido.fechaEnvio != null ? DateFormat('dd/MM/yyyy').format(pedido.fechaEnvio!) : 'N/A'),
            _buildDetailRow(context, 'Transportista', pedido.transportistaId),
            _buildDetailRow(context, 'Recibe', pedido.nombreEnvio),
            _buildDetailRow(context, 'Dirección', pedido.direccionEnvio),
            _buildDetailRow(context, 'Ciudad', pedido.ciudadMunicipioDest),
            
            const SizedBox(height: Spacing.md),
            Text('Datos de Facturación:', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
            _buildDetailRow(context, 'Fecha Pago', pedido.fechaPago != null ? DateFormat('dd/MM/yyyy').format(pedido.fechaPago!) : 'N/A'),
            _buildDetailRow(context, 'Tipo Pago', pedido.tipoPago),
            _buildDetailRow(context, 'Tipo Impositivo', pedido.tipoImpositivo != null ? '${(pedido.tipoImpositivo! * 100).toStringAsFixed(0)}%' : 'N/A'),
            _buildDetailRow(context, 'Gastos Envío', pedido.gastosEnvio.toStringAsFixed(2)),
            
            const Divider(height: Spacing.lg, thickness: 1),
            _buildDetailRow(context, 'Subtotal Bruto', pedido.subtotalBruto.toStringAsFixed(2)),
            _buildDetailRow(context, 'Total Descuentos', pedido.totalDescuentos.toStringAsFixed(2)),
            _buildDetailRow(context, 'Monto Impuestos', pedido.montoImpuestos.toStringAsFixed(2)),
            _buildDetailRow(context, 'TOTAL NETO', pedido.totalNeto.toStringAsFixed(2), valueColor: AppTheme.primaryColor),
            
            if (pedido.notas != null && pedido.notas!.isNotEmpty) ...[
                const SizedBox(height: Spacing.md),
                _buildDetailRow(context, 'Notas', pedido.notas),
            ]
            // TODO: Añadir botones de acción (Editar, Marcar como enviado, Cancelar, Ver recibo)
            // TODO: Añadir Stepper o barra de progreso para el estado del pedido
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cerrar', style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Spacing.md)),
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}