
import 'package:cocoyagua/ui/views/contratos/registrar_contrato_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/contrato_model.dart';
// Asumiendo modelos existentes o que se crearán
// import '../../../models/cliente_model.dart';
// import '../../../models/titular_model.dart';
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

class ContratoRowData {
  final String id;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String clienteInfo; // Nombre o ID del cliente
  final String tomaDomiciliariaId;
  final String titularInfo; // Nombre o ID del titular
  final String? medidorId;
  final String estado;
  final ContratoModel contratoOriginal;

  ContratoRowData({
    required this.id,
    required this.fechaInicio,
    this.fechaFin,
    required this.clienteInfo,
    required this.tomaDomiciliariaId,
    required this.titularInfo,
    this.medidorId,
    required this.estado,
    required this.contratoOriginal,
  });
}

class ContratosView extends StatefulWidget {
  const ContratosView({super.key});

  @override
  State<ContratosView> createState() => _ContratosViewState();
}

class _ContratosViewState extends State<ContratosView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _clienteFilterController = TextEditingController();
  final TextEditingController _titularFilterController = TextEditingController();

  List<ContratoRowData> _listaContratos = [];
  List<ContratoModel> _contratosOriginales = [];

  String? _selectedEstadoFilter = 'Todos';
  final List<String> _estadoOptions = ['Todos', 'Activo', 'Pendiente Firma', 'Finalizado', 'Suspendido']; // Ejemplo
  DateTime? _selectedFechaInicioFilter;
  DateTime? _selectedFechaFinFilter;

  @override
  void initState() {
    super.initState();
    _cargarDatosDeEjemplo();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _clienteFilterController.dispose();
    _titularFilterController.dispose();
    super.dispose();
  }

  void _cargarDatosDeEjemplo() {
    _contratosOriginales = List.generate(15, (i) {
      final startDate = DateTime.now().subtract(Duration(days: 30 * i + 60));
      return ContratoModel(
        id: 'CON-${2000 + i}',
        fechaContrato: startDate,
        fechaFinalizacion: i % 3 == 0 ? null : startDate.add(const Duration(days: 365 * 2)),
        clienteId: 'CLI-${100 + i}',
        clienteNombre: 'Cliente Ejemplo ${100 + i}',
        titularId: 'TTDM-${1000 + i}',
        titularNombre: 'Titular Ejemplo ${50 + i}',
        tomaDomiciliariaId: 'TOMA-${300 + i}',
        medidorId: i % 2 == 0 ? 'MED-${700 + i}' : null,
        empleadoId: 'EMP-${400 + i}',
        estado: _estadoOptions[(i % (_estadoOptions.length -1)) + 1], // Evita 'Todos'
        asignacionMedidorId: i % 2 == 0 ? 'ASIGMED-${800+i}' : null,
        documentoImpresoId: i % 4 == 0 ? 'DOCIMP-${900+i}' : null,
        fechaCreacion: DateTime.now().subtract(Duration(days: 30 * i + 62)),
        fechaActualizacion: DateTime.now().subtract(Duration(days: i + 1)),
      );
    });
    _actualizarListaParaTabla();
  }

  void _actualizarListaParaTabla() {
    // TODO: Aplicar filtros y búsqueda aquí antes de setState
    _listaContratos = _contratosOriginales.map((c) {
      return ContratoRowData(
        id: c.id,
        fechaInicio: c.fechaContrato,
        fechaFin: c.fechaFinalizacion,
        clienteInfo: c.clienteNombre ?? c.clienteId,
        tomaDomiciliariaId: c.tomaDomiciliariaId,
        titularInfo: c.titularNombre ?? c.titularId,
        medidorId: c.medidorId,
        estado: c.estado,
        contratoOriginal: c,
      );
    }).toList();

    // Lógica de filtrado (ejemplo básico)
    final searchLower = _searchController.text.toLowerCase();
    final clienteFilterLower = _clienteFilterController.text.toLowerCase();
    final titularFilterLower = _titularFilterController.text.toLowerCase();

    _listaContratos = _listaContratos.where((item) {
      bool matchesSearch = searchLower.isEmpty ||
          item.id.toLowerCase().contains(searchLower) ||
          (item.medidorId?.toLowerCase().contains(searchLower) ?? false);

      bool matchesCliente = clienteFilterLower.isEmpty ||
          item.clienteInfo.toLowerCase().contains(clienteFilterLower);

      bool matchesTitular = titularFilterLower.isEmpty ||
          item.titularInfo.toLowerCase().contains(titularFilterLower);

      bool matchesEstado = _selectedEstadoFilter == 'Todos' || item.estado == _selectedEstadoFilter;
      
      bool matchesFechaInicio = _selectedFechaInicioFilter == null ||
          !item.fechaInicio.isBefore(_selectedFechaInicioFilter!);

      bool matchesFechaFin = _selectedFechaFinFilter == null ||
          (item.fechaFin != null && !item.fechaFin!.isAfter(_selectedFechaFinFilter!));

      return matchesSearch && matchesCliente && matchesTitular && matchesEstado && matchesFechaInicio && matchesFechaFin;
    }).toList();

    setState(() {});
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected, {DateTime? initialDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
      _actualizarListaParaTabla();
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Gestión de Contratos', style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        // ... (resto del header como en TitularesView)
         Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Santiago Meza Alvés', style: AppTypography.bodyLg.copyWith(color: AppTheme.textPrimaryColor)),
                Text('Operador', style: AppTypography.bodySm.copyWith(color: AppTheme.textPrimaryColor)),
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
                        child: _buildContratosTable(_listaContratos),
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
    return Column(
      children: [
        AppInput(
            label: "Buscar N° Contrato, Medidor",
            hintText: 'Escriba aquí...',
            controller: _searchController,
            icon: Icons.search,
            onChanged: (_) => _actualizarListaParaTabla()),
        const SizedBox(height: Spacing.sm),
        AppInput(
            label: "Filtrar por Cliente",
            hintText: 'Nombre o ID Cliente...',
            controller: _clienteFilterController,
            icon: Icons.person_search,
            onChanged: (_) => _actualizarListaParaTabla()),
        const SizedBox(height: Spacing.sm),
        AppInput(
            label: "Filtrar por Titular",
            hintText: 'Nombre o ID Titular...',
            controller: _titularFilterController,
            icon: Icons.assignment_ind,
            onChanged: (_) => _actualizarListaParaTabla()),
        const SizedBox(height: Spacing.sm),
        AppSelect<String>(label: 'Estado Contrato', value: _selectedEstadoFilter, options: _estadoOptions, onChanged: (val) => setState(() { _selectedEstadoFilter = val; _actualizarListaParaTabla(); }), labelBuilder: (s) => s),
        const SizedBox(height: Spacing.sm),
        // TODO: Añadir DatePickers para fechas
        AppButton(text: 'Nuevo Contrato', icon: Icons.add, onPressed: _navegarARegistrarContrato, width: double.infinity),
      ],
    );
  }

  Widget _buildDesktopFiltersAndActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: AppInput(label: "Buscar N° Contrato, Medidor", hintText: 'Escriba aquí...', controller: _searchController, icon: Icons.search, onChanged: (_) => _actualizarListaParaTabla())),
            const SizedBox(width: Spacing.md),
            Expanded(flex: 2, child: AppInput(label: "Filtrar por Cliente", hintText: 'Nombre o ID Cliente...', controller: _clienteFilterController, icon: Icons.person_search, onChanged: (_) => _actualizarListaParaTabla())),
            const SizedBox(width: Spacing.md),
            Expanded(flex: 2, child: AppInput(label: "Filtrar por Titular", hintText: 'Nombre o ID Titular...', controller: _titularFilterController, icon: Icons.assignment_ind, onChanged: (_) => _actualizarListaParaTabla())),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(flex: 2, child: AppSelect<String>(label: 'Estado Contrato', value: _selectedEstadoFilter, options: _estadoOptions, onChanged: (val) => setState(() { _selectedEstadoFilter = val; _actualizarListaParaTabla(); }), labelBuilder: (s) => s)),
            const SizedBox(width: Spacing.md),
            Expanded(
              flex: 2,
              child: AppButton(
                text: _selectedFechaInicioFilter == null ? 'Fecha Inicio Desde' : 'Inicio: ${DateFormat('dd/MM/yy').format(_selectedFechaInicioFilter!)}',
                onPressed: () => _selectDate(context, (date) => setState(() => _selectedFechaInicioFilter = date), initialDate: _selectedFechaInicioFilter),
                kind: AppButtonKind.secondary,
                icon: Icons.calendar_today,
              ),
            ),
             const SizedBox(width: Spacing.xs),
            if (_selectedFechaInicioFilter != null) IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => setState(() { _selectedFechaInicioFilter = null; _actualizarListaParaTabla();})),
            const SizedBox(width: Spacing.md),
            Expanded(
              flex: 2,
              child: AppButton(
                text: _selectedFechaFinFilter == null ? 'Fecha Fin Hasta' : 'Fin: ${DateFormat('dd/MM/yy').format(_selectedFechaFinFilter!)}',
                onPressed: () => _selectDate(context, (date) => setState(() => _selectedFechaFinFilter = date), initialDate: _selectedFechaFinFilter),
                kind: AppButtonKind.secondary,
                icon: Icons.calendar_today,
              ),
            ),
            if (_selectedFechaFinFilter != null) IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => setState(() { _selectedFechaFinFilter = null; _actualizarListaParaTabla();})),
            const Spacer(flex: 1),
            AppButton(text: 'Nuevo Contrato', icon: Icons.add, onPressed: _navegarARegistrarContrato),
          ],
        ),
      ],
    );
  }

  void _navegarARegistrarContrato({ContratoModel? contrato}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrarContratoView(contratoExistente: contrato)),
    ).then((_) => _cargarDatosDeEjemplo()); // Recargar datos al volver
  }

  Widget _buildContratosTable(List<ContratoRowData> items) {
    return AppTable<ContratoRowData>(
      columns: const ['ID', 'F. INICIO', 'F. FIN', 'CLIENTE', 'TOMA DOM.', 'TITULAR', 'MEDIDOR', 'ESTADO', 'ACCIONES'],
      items: items,
      buildRow: (item) {
        return DataRow(cells: [
          DataCell(Text(item.id, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
          DataCell(Text(DateFormat('dd/MM/yyyy').format(item.fechaInicio), style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
          DataCell(Text(item.fechaFin != null ? DateFormat('dd/MM/yyyy').format(item.fechaFin!) : 'N/A', style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
          DataCell(Text(item.clienteInfo, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
          DataCell(Text(item.tomaDomiciliariaId, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
          DataCell(Text(item.titularInfo, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
          DataCell(Text(item.medidorId ?? 'N/A', style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
          DataCell(Text(item.estado, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.visibility_outlined, color: AppTheme.primaryColor, size: 18), tooltip: 'Ver Detalles', onPressed: () { /* TODO: _mostrarDialogoDetallesContrato */ }),
              IconButton(icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryColor, size: 18), tooltip: 'Editar', onPressed: () => _navegarARegistrarContrato(contrato: item.contratoOriginal)),
              IconButton(icon: const Icon(Icons.delete_outline, color: AppTheme.dangerColor, size: 18), tooltip: 'Eliminar', onPressed: () { /* TODO: _eliminarContrato */ }),
              IconButton(icon: const Icon(Icons.receipt_long_outlined, color: AppTheme.secondaryColor, size: 18), tooltip: 'Ver Estado de Cuenta', onPressed: () { /* TODO: Navegar a Estado de Cuenta */ }),
            ],
          )),
        ]);
      },
    );
  }
  // TODO: Implementar _mostrarDialogoDetallesContrato y _eliminarContrato
}
