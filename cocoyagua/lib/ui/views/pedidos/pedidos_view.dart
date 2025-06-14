import 'package:cocoyagua/models/pedido_model.dart';
import './pedidos_form_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/layout/app_card.dart';
import '../../components/shared/responsive.dart';
import '../../components/tables/app_table.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/dialogs/pedido_details_dialog.dart'; // Asegúrate de crear este diálogo
import '../../widgets/sidebar_menu.dart';

class PedidosView extends StatefulWidget {
  const PedidosView({super.key});

  @override
  State<PedidosView> createState() => _PedidosViewState();
}

class _PedidosViewState extends State<PedidosView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedEstadoFilter;
  String? _selectedClienteFilter;
  String? _selectedPeriodoFacturacionFilter;
  // TODO: Add date range filter controllers

  List<Pedido> _pedidos = [];

  // Mock data for filters - replace with actual data
  final List<String> _clienteOptionsFilter = ['CLI001-EmpresaA', 'CLI002-EmpresaB', 'Todos'];
  final List<String> _periodoFacturacionOptionsFilter = ['2023-10', '2023-11', 'Todos'];

  @override
  void initState() {
    super.initState();
    _loadMockPedidos();
  }

  void _loadMockPedidos() {
    // Simula la carga de pedidos
    setState(() {
      _pedidos = List.generate(3, (index) {
        return Pedido(
          pedidoId: 'PED-2023-${200 + index}',
          fechaPedido: DateTime.now().subtract(Duration(days: index * 7)),
          empleadoId: 'EMP00${index + 1}',
          clienteId: 'CLI00${index + 1}-Cliente ${index + 1}',
          estadoPedido: index % 2 == 0 ? EstadoPedido.pendiente : EstadoPedido.enviado,
          pdoPeriodoFacturacion: '2023-${10 + index}',
          detalles: [
            PedidoDetalle(productoId: 'PROD001', productoNombre: 'Producto A', cantidad: 2, precioUnitario: 50.0),
            PedidoDetalle(productoId: 'PROD002', productoNombre: 'Producto B', cantidad: 1, precioUnitario: 75.0, descuentoPorcentaje: 0.1),
          ],
          gastosEnvio: 10.0,
          tipoImpositivo: 0.18,
        );
      });
    });
  }

  void _navigateToForm({Pedido? pedido}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PedidoFormView(pedidoToEdit: pedido),
      ),
    );
    if (result == true) {
      _loadMockPedidos(); // Recargar datos si se guardó algo
    }
  }

  void _showDetailsDialog(Pedido pedido) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PedidoDetailsDialog(pedido: pedido);
      },
    );
  }
    Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Gestión de Pedidos',
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Santiago Meza Alvés',
                    style: AppTypography.bodyLg
                        .copyWith(color: AppTheme.textPrimaryColor)),
                Text('Administrador',
                    style: AppTypography.bodySm
                        .copyWith(color: AppTheme.textPrimaryColor)),
              ],
            ),
            const SizedBox(width: Spacing.md),
            const CircleAvatar(
              backgroundColor: Colors.grey,
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
                    _buildFilterBar(isMobile),
                    const SizedBox(height: Spacing.lg),
                    AppCard(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildPedidosTable(),
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

  Widget _buildFilterBar(bool isMobile) {
    // TODO: Add more filters (Date Range, Cliente, Periodo Facturación)
    final filterFields = [
      Expanded(
        flex: isMobile ? 0 : 2,
        child: AppInput(
          hintText: 'Buscar por Nº Pedido, Cliente...',
          controller: _searchController,
          icon: Icons.search,
          label: 'Buscar Pedido',
          isLabelVisible: !isMobile,
          onChanged: (value) { /* TODO: Implement search logic */ },
        ),
      ),
      const SizedBox(width: Spacing.md, height: Spacing.md),
      Expanded(
        flex: isMobile ? 0 : 1,
        child: AppSelect<String>(
          label: 'Estado',
          value: _selectedEstadoFilter,
          options: EstadoPedido.values.map((e) => estadoPedidoToString(e)).toList(),
          labelBuilder: (v) => v,
          onChanged: (value) => setState(() => _selectedEstadoFilter = value /* TODO: Filter */),
          hint: const Text('Todos'),
        ),
      ),
      // Add more AppSelect for Cliente and PeriodoFacturacion if needed
    ];

    return isMobile
        ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            ...filterFields,
            const SizedBox(height: Spacing.md),
            AppButton(text: 'Crear Nuevo Pedido', icon: Icons.add, onPressed: () => _navigateToForm()),
          ])
        : Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            ...filterFields,
            const SizedBox(width: Spacing.md),
            AppButton(text: 'Crear Pedido', icon: Icons.add, onPressed: () => _navigateToForm()),
          ]);
  }

  Widget _buildPedidosTable() {
    // TODO: Apply filtering to _pedidos list
    List<Pedido> filteredPedidos = _pedidos;

    return AppTable<Pedido>(
      columns: const [
        'Nº Pedido',
        'Fecha',
        'Cliente',
        'Estado',
        'Total',
        'Acciones',
      ],
      items: filteredPedidos,
      buildRow: (pedido) {
        return DataRow(cells: [
          DataCell(Text(pedido.pedidoId, style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(DateFormat('dd/MM/yyyy').format(pedido.fechaPedido), style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(pedido.clienteId, style: TextStyle(color: AppTheme.texttableColor))), // Mostrar nombre del cliente si se tiene
          DataCell(Text(estadoPedidoToString(pedido.estadoPedido), style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(pedido.totalNeto.toStringAsFixed(2), style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.visibility, color: AppTheme.texttableColor), tooltip: 'Ver Detalles', onPressed: () => _showDetailsDialog(pedido)),
              IconButton(icon: const Icon(Icons.edit, color: AppTheme.texttableColor), tooltip: 'Editar', onPressed: () => _navigateToForm(pedido: pedido)),
              // TODO: Add more actions like "Marcar como enviado", "Cancelar", "Ver recibo"
            ],
          )),
        ]);
      },
    );
  }
}