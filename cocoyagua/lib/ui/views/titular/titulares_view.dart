import 'package:cocoyagua/ui/views/titular/registrar_titular_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/titular_model.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/layout/app_card.dart';
import '../../components/shared/responsive.dart';
import '../../components/tables/app_table.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';
// TODO: Crear e importar la vista de registro/edición de titulares
// import 'registrar_titular_view.dart';

// Clase de datos para las filas de la tabla de titulares
class TitularRowData {
  final String id; // TOMADOTITULAR_ID
  final String clienteInfo; // Nombre del cliente o ID
  final String tomaDomiciliariaId;
  final String claveCatastral;
  final DateTime fechaAsignacion;
  final String estadoRegistro;
  final String tipoFacturacion;
  final TitularModel titularOriginal; // Para acceder al objeto completo

  TitularRowData({
    required this.id,
    required this.clienteInfo,
    required this.tomaDomiciliariaId,
    required this.claveCatastral,
    required this.fechaAsignacion,
    required this.estadoRegistro,
    required this.tipoFacturacion,
    required this.titularOriginal,
  });
}

class TitularesView extends StatefulWidget {
  const TitularesView({super.key});

  @override
  State<TitularesView> createState() => _TitularesViewState();
}

class _TitularesViewState extends State<TitularesView> {
  final TextEditingController _searchController = TextEditingController();
  List<TitularRowData> _listaTitulares = [];
  List<TitularModel> _titularesOriginales = []; // Para mantener los datos completos

  // TODO: Definir y cargar opciones para filtros
  String? _selectedEstadoFilter = 'Todos';
  final List<String> _estadoOptions = ['Todos', 'Activo', 'Inactivo', 'Suspendido']; // Ejemplo
  String? _selectedTipoFacturacionFilter = 'Todos';
  final List<String> _tipoFacturacionOptions = ['Todos', 'Residencial', 'Comercial', 'Industrial']; // Ejemplo
  DateTime? _selectedFechaAsignacionFilter;

  @override
  void initState() {
    super.initState();
    _cargarDatosDeEjemplo();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _cargarDatosDeEjemplo() {
    // Simulación de carga de datos. Reemplazar con lógica real.
    _titularesOriginales = List.generate(10, (i) {
      return TitularModel(
        id: 'TTDM-${1000 + i}',
        clienteId: 'CLI-${200 + i}',
        clienteNombre: 'Cliente Ejemplo ${200 + i}', // Simulado
        tomaDomiciliariaId: 'TOMA-${300 + i}',
        empleadoId: 'EMP-${400 + i}',
        tipoDocumentoPropiedad: 'Escritura Pública',
        numeroDocumentoPropiedad: 'DP-${500 + i}',
        claveCatastral: 'CC-${600 + i}',
        fechaAsignacion: DateTime.now().subtract(Duration(days: 30 * i)),
        estadoGeneral: i % 2 == 0 ? 'Activo' : 'Inactivo',
        estadoRegistro: i % 3 == 0 ? 'Vigente' : (i % 3 == 1 ? 'Suspendido' : 'En Proceso'),
        tipoFacturacion: (i % 2 == 0) ? 'Residencial' : 'Comercial',
        cambioCliente: i % 4 == 0,
        fechaUltimaFactura: DateTime.now().subtract(Duration(days: 5 + i)),
      );
    });
    _actualizarListaParaTabla();
  }

  void _actualizarListaParaTabla() {
    _listaTitulares = _titularesOriginales.map((t) {
      return TitularRowData(
        id: t.id,
        clienteInfo: t.clienteNombre ?? t.clienteId,
        tomaDomiciliariaId: t.tomaDomiciliariaId,
        claveCatastral: t.claveCatastral,
        fechaAsignacion: t.fechaAsignacion,
        estadoRegistro: t.estadoRegistro,
        tipoFacturacion: t.tipoFacturacion,
        titularOriginal: t,
      );
    }).toList();
    // TODO: Aplicar filtros y búsqueda aquí antes de setState
    setState(() {});
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Gestión de Titulares',
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Santiago Meza Alvés',
                    style: AppTypography.bodyLg.copyWith(color: AppTheme.textPrimaryColor)),
                Text('Operador',
                    style: AppTypography.bodySm.copyWith(color: AppTheme.textPrimaryColor)),
              ],
            ),
            const SizedBox(width: Spacing.md),
            const CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, color: Colors.white),
              radius: 20,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    // TODO: Implementar lógica de filtrado real
    final List<TitularRowData> itemsFiltrados = _listaTitulares.where((item) {
      final searchLower = _searchController.text.toLowerCase();
      bool matchesSearch = searchLower.isEmpty ||
          item.clienteInfo.toLowerCase().contains(searchLower) ||
          item.claveCatastral.toLowerCase().contains(searchLower);
          // TODO: Añadir búsqueda por documento del cliente (necesitaría el dato en TitularRowData o TitularModel)

      bool matchesEstado = _selectedEstadoFilter == 'Todos' || item.estadoRegistro == _selectedEstadoFilter;
      bool matchesTipoFacturacion = _selectedTipoFacturacionFilter == 'Todos' || item.tipoFacturacion == _selectedTipoFacturacionFilter;
      // TODO: Filtrar por fecha de asignación

      return matchesSearch && matchesEstado && matchesTipoFacturacion;
    }).toList();

    return Scaffold(
      drawer: isMobile ? const Drawer(child: SidebarMenu()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const SidebarMenu(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: _buildHeader(),
                toolbarHeight: 80,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: ListView(
                  children: [
                    if (isMobile)
                      _buildMobileFiltersAndActions()
                    else
                      _buildDesktopFiltersAndActions(),
                    const SizedBox(height: Spacing.lg),
                    AppCard(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildTitularesTable(itemsFiltrados),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFiltersAndActions() {
    // Similar a SolicitudesView, adaptar campos
    return Column(
      children: [
        AppInput(
            hintText: 'Buscar por cliente, catastral...',
            controller: _searchController,
            icon: Icons.search,
            label: 'Buscar',
            isLabelVisible: false,
            onChanged: (_) => _actualizarListaParaTabla()),
        const SizedBox(height: Spacing.md),
        AppSelect<String>(
          label: 'Estado Registro',
          value: _selectedEstadoFilter,
          options: _estadoOptions,
          onChanged: (val) => setState(() {
            _selectedEstadoFilter = val;
            _actualizarListaParaTabla();
          }),
          labelBuilder: (s) => s,
        ),
        const SizedBox(height: Spacing.md),
        // TODO: Añadir más filtros (fecha, tipo facturación)
        AppButton(
          text: 'Nuevo Titular',
          icon: Icons.add,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrarTitularView()));
          },
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildDesktopFiltersAndActions() {
    // Similar a SolicitudesView, adaptar campos
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AppInput(
              hintText: 'Buscar por cliente, catastral...',
              controller: _searchController,
              icon: Icons.search,
              label: 'Buscar',
              onChanged: (_) => _actualizarListaParaTabla()),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          flex: 2,
          child: AppSelect<String>(
            label: 'Estado Registro',
            value: _selectedEstadoFilter,
            options: _estadoOptions,
            onChanged: (val) => setState(() {
              _selectedEstadoFilter = val;
              _actualizarListaParaTabla();
            }),
            labelBuilder: (s) => s,
          ),
        ),
        // TODO: Añadir más filtros
        const SizedBox(width: Spacing.md),
        AppButton(
            text: 'Nuevo Titular',
            icon: Icons.add,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrarTitularView()));
            }),
      ],
    );
  }

  Widget _buildTitularesTable(List<TitularRowData> items) {
    return AppTable<TitularRowData>(
      columns: const [
        'CLIENTE',
        'TOMA ID',
        'CLAVE CATASTRAL',
        'F. ASIGNACIÓN',
        'ESTADO REG.',
        'TIPO FACT.',
        'ACCIONES',
      ],
      items: items,
      buildRow: (item) {
        return DataRow(
          cells: [
            DataCell(Text(item.clienteInfo, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(item.tomaDomiciliariaId, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(item.claveCatastral, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(DateFormat('dd/MM/yyyy').format(item.fechaAsignacion), style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(item.estadoRegistro, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(item.tipoFacturacion, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                      icon: const Icon(Icons.visibility_outlined, color: AppTheme.primaryColor, size: 18),
                      tooltip: 'Ver',
                      onPressed: () => _mostrarDialogoDetallesTitular(context, item.titularOriginal)),
                  IconButton(
                      padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                      icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryColor, size: 18),
                      tooltip: 'Editar',
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrarTitularView(titularExistente: item.titularOriginal)));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TODO: Navegar a Editar Titular')));
                      }),
                  IconButton(
                      padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                      icon: const Icon(Icons.delete_outline, color: AppTheme.dangerColor, size: 18),
                      tooltip: 'Eliminar',
                      onPressed: () => _eliminarTitular(context, item.titularOriginal)),
                  // TODO: Botón para "Cambio de Titularidad"
                  IconButton(
                      padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                      icon: const Icon(Icons.swap_horiz, color: AppTheme.secondaryColor, size: 18),
                      tooltip: 'Cambiar Titularidad',
                      onPressed: () => _mostrarDialogoCambioTitularidad(context, item.titularOriginal)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoDetallesTitular(BuildContext context, TitularModel titular) {
     // Similar a _mostrarDialogoDetallesSolicitud, adaptar para mostrar campos de TitularModel
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Detalles del Titular: ${titular.clienteNombre ?? titular.clienteId}', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
        content: SizedBox(width: MediaQuery.of(context).size.width * 0.55, child: SingleChildScrollView(
          child: ListBody(children: <Widget>[
            _buildDetailRow('ID Titular:', titular.id),
            _buildDetailRow('Cliente ID:', titular.clienteId),
            if (titular.clienteNombre != null) _buildDetailRow('Nombre Cliente:', titular.clienteNombre!),
            _buildDetailRow('Toma Domiciliaria ID:', titular.tomaDomiciliariaId),
            _buildDetailRow('Clave Catastral:', titular.claveCatastral),
            _buildDetailRow('Fecha Asignación:', DateFormat('dd/MM/yyyy').format(titular.fechaAsignacion)),
            _buildDetailRow('Estado General:', titular.estadoGeneral),
            _buildDetailRow('Estado Registro:', titular.estadoRegistro),
            _buildDetailRow('Tipo Facturación:', titular.tipoFacturacion),
            _buildDetailRow('Tipo Doc. Propiedad:', titular.tipoDocumentoPropiedad),
            _buildDetailRow('Num. Doc. Propiedad:', titular.numeroDocumentoPropiedad),
            _buildDetailRow('Empleado Asignado ID:', titular.empleadoId),
            if (titular.fechaUltimaFactura != null) _buildDetailRow('Fecha Última Factura:', DateFormat('dd/MM/yyyy').format(titular.fechaUltimaFactura!)),
            _buildDetailRow('Indicador Cambio Cliente:', titular.cambioCliente ? 'Sí' : 'No'),
          ]),
        )),
        actions: <Widget>[ AppButton(text: 'Cerrar', onPressed: () => Navigator.of(context).pop(), kind: AppButtonKind.ghost)],
      );
    });
  }

   Widget _buildDetailRow(String label, String value) { // Reutilizado de SolicitudesView
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: AppTypography.body.copyWith(color: AppTheme.textPrimaryColor),
          children: [
            TextSpan(
                text: '$label ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _eliminarTitular(BuildContext context, TitularModel titular) {
    // Similar a _eliminarSolicitud
    showDialog(context: context, builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Confirmar Eliminación', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
        content: Text('¿Está seguro de que desea eliminar al titular con ID "${titular.id}" asociado al cliente "${titular.clienteNombre ?? titular.clienteId}"?'),
        actions: <Widget>[
          AppButton(text: 'Cancelar', onPressed: () => Navigator.of(dialogContext).pop(), kind: AppButtonKind.ghost),
          AppButton(text: 'Eliminar', onPressed: () {
            setState(() {
              _titularesOriginales.removeWhere((t) => t.id == titular.id);
              _actualizarListaParaTabla();
            });
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Titular eliminado (simulación).')));
          }, kind: AppButtonKind.primary),
        ],
      );
    });
  }

  void _mostrarDialogoCambioTitularidad(BuildContext context, TitularModel titular) {
    // TODO: Implementar diálogo para cambio de titularidad
    // Esto podría mostrar un historial (tomadomiciliaria_titularcambio)
    // y permitir ejecutar el cambio.
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Cambio de Titularidad para Toma: ${titular.tomaDomiciliariaId}', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
        content: const Text('Funcionalidad de cambio de titularidad (TODO). \nAquí se mostraría el historial y opciones para el cambio.'),
        actions: <Widget>[ AppButton(text: 'Cerrar', onPressed: () => Navigator.of(context).pop(), kind: AppButtonKind.ghost)],
      );
    });
  }
}
