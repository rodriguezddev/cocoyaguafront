import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  void _navigate(BuildContext context, String route) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Image.asset('assets/images/logo.png', height: 80),
          const SizedBox(height: 20),
          _buildExpansionTile(context, 'Gestión de empresa', Icons.apartment, [
            _subTile(context, 'Productos y servicios', '/gestion/productos_servicios'),
            _subTile(context, 'Personas', '/gestion/personas'),
            // _subTile(context, 'Empleados', '/gestion/empleados'),
            // _subTile(context, 'Clientes', '/gestion/clientes'),
            // _subTile(context, 'Proveedores', '/gestion/proveedores'),
          ]),
          _buildExpansionTile(context, 'Gestión del Servicio Agua y Saneamiento', Icons.settings, [
            _subTile(context, 'Usos de suministro', '/gestion&saneamiento/usos_suministros'),
             _subTile(
                context, 'Solicitudes', '/gestion&saneamiento/solicitudes'),
                // _subTile(
                // context, 'Medidores', '/gestion&saneamiento/medidores'),
                _subTile(
                context, 'Tomas domiciliarias', '/gestion&saneamiento/tomas_domiciliarias'),
            _subTile(context, 'Titulares',
                '/gestion&saneamiento/titulares'), // Ruta activada
                _subTile(context, 'contratos',
                '/gestion&saneamiento/contratos'),
                _subTile(context, 'Quejas',
                '/gestion&saneamiento/quejas'),
                _subTile(context, 'Casos',
                '/gestion&saneamiento/casos'),
                _subTile(context, 'Resoluciones',
                '/gestion&saneamiento/resoluciones'),
                _subTile(context, 'Reportes técnicos',
                '/gestion&saneamiento/reportes_tecnicos'),
          ]),
          // _buildExpansionTile(context, 'Gestión Presupuestaria', Icons.settings, [
          //   _subTile(context, 'Requisiciones', '/Gestion_presupuestaria/requisiciones'),
          //   _subTile(context, 'Resumen de cotización y adjudicación',
          //       '/Gestion_presupuestaria/Resumen_cotizacion&adjudicacion'),
          //       _subTile(context, 'Órdenes de compra',
          //       '/Gestion_presupuestaria/ordenes_compra'),
          //       _subTile(context, 'Expedientes de órdenes de pago',
          //       '/Gestion_presupuestaria/expedientes_ordenes_pago'),
          //       _subTile(context, 'Beneficiarios',
          //       '/Gestion_presupuestaria/beneficiarios'),
          //       _subTile(context, 'Cheques',
          //       '/Gestion_presupuestaria/cheques'),
          //       _subTile(context, 'Órdenes de pago',
          //       '/Gestion_presupuestaria/ordenes_pago'),
          //       _subTile(context, 'Inventario',
          //       '/Gestion_presupuestaria/inventario'),
          // ]),
          _buildExpansionTile(context, 'Oficina Virtual', Icons.settings, [
            // _subTile(context, 'Cita Previa', '/oficina_virtual/cita_previa'),
            // _subTile(context, 'Contratación', '/oficina_virtual/contratacion'),
            _subTile(context, 'Requisitos de contratación', '/oficina_virtual/requisitos_contratacion'),
            _subTile(context, 'Contratos', '/oficina_virtual/Contratos'),
            _subTile(context, 'Solicitud alta', '/oficina_virtual/solicitud_alta'),
            _subTile(context, 'Solicitud cambio titularidad', '/oficina_virtual/solicitud_cambio_titularidad'),
            _subTile(context, 'Solicitud de baja', '/oficina_virtual/Solicitud_baja'),
            // _subTile(context, 'Estado gestión y aportar documentos', '/oficina_virtual/estado_gestion&aportar_documentos'),
            _subTile(context, 'Facturas', '/oficina_virtual/facturas'),
            // _subTile(context, 'Factura electrónica', '/oficina_virtual/factura_electrónica'),
            // _subTile(context, 'Pago de facturas online', '/oficina_virtual/Pago_facturas_online'),
            // _subTile(context, 'Comprobantes de pago',
            //     '/oficina_virtual/Comprobantes_pago'),
          ]),
          _buildExpansionTile(context, 'Facturación', Icons.settings, [
            _subTile(context, 'Periodos de facturación', '/facturacion/periodos_facturación'),
            _subTile(context, 'Lecturas', '/facturacion/lecturas'), // Comentado si Lectura de Medidores lo reemplaza
            _subTile(context, 'Pedidos', '/facturacion/pedidos'),
            _subTile(context, 'Facturas', '/facturacion/facturas'),
            _subTile(context, 'Lectura de Medidores', '/facturacion/lecturas-medidores'), // <-- Nueva entrada
          ]),
          _buildExpansionTile(context, 'Información de Pago', Icons.settings, [
            _subTile(context, 'Recibos', '/información_pago/recibos'),
            _subTile(context, 'Estados de cuenta', '/información_pago/estados_cuenta'),
          ]),
          // _buildExpansionTile(context, 'Información de Pago', Icons.settings, [
          //   _subTile(context, 'Recibos', '/información_pago/recibos'),
          //   _subTile(context, 'Estados de cuenta',
          //       '/información_pago/estados_cuenta'),
          // ]),
          _buildExpansionTile(context, 'Configuración', Icons.settings, [
            _subTile(context, 'Región ', '/configuracion/region'),
            _subTile(context, 'Empresa', '/configuracion/empresa'),
            _subTile(context, 'Cuentas de usuario', '/configuracion/cuentas_usuario'),
            _subTile(context, 'Copias de seguridad',
                '/configuracion/copias_seguridad'),
                _subTile(context, 'Segmentos de información',
                '/configuracion/Segmentos_informacion'),
          ]),
          _buildTile(context, 'Bitácora', Icons.book, '/bitacora'),
        ],
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textColor),
      title: Text(title, style: const TextStyle(color: AppTheme.textColor)),
      onTap: () => _navigate(context, route),
    );
  }

  Widget _buildExpansionTile(BuildContext context, String title, IconData icon,
      List<Widget> children) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: AppTheme.textColor,
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyMedium: const TextStyle(color: AppTheme.textColor),
            ),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: AppTheme.textColor),
        title: Text(title, style: const TextStyle(color: AppTheme.textColor)),
        children: children,
      ),
    );
  }

  Widget _subTile(BuildContext context, String title, String route) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40.0),
      title: Text(title, style: const TextStyle(color: AppTheme.textColor)),
      onTap: () => _navigate(context, route),
    );
  }
}
