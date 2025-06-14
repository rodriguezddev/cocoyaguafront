import '../../../models/lectura_model.dart';
import 'package:cocoyagua/ui/views/lecturas/lectura_form_view.dart';
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
import '../../widgets/dialogs/lectura_details_dialog.dart';
import '../../widgets/sidebar_menu.dart';

class LecturasView extends StatefulWidget {
  const LecturasView({super.key});

  @override
  State<LecturasView> createState() => _LecturasViewState();
}

class _LecturasViewState extends State<LecturasView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedEstadoFilter;
  // TODO: Add date range filter controllers and logic

  // Mock data - replace with actual data fetching
  List<Lectura> _lecturas = [];

  @override
  void initState() {
    super.initState();
    _loadMockLecturas();
  }

  void _loadMockLecturas() {
    // Simula la carga de lecturas
    setState(() {
      _lecturas = List.generate(5, (index) {
        final anterior = 50.0 + index * 10;
        final actual = anterior + 15.0 + index * 2;
        return Lectura(
          lecturaId: 'LEC-2023-${100 + index}',
          fechaLectura: DateTime.now().subtract(Duration(days: index * 5)),
          medidorId: 'MED00${index + 1}',
          lecturaAnterior: anterior,
          lecturaActual: actual,
          unidadMedida: UnidadMedida.m3,
          empleadoId: 'EMP001',
          estadoLectura: index % 2 == 0
              ? EstadoLectura.realizada
              : EstadoLectura.facturada,
          productoId: 'AGUA_POTABLE',
        );
      });
    });
  }

  void _navigateToForm({Lectura? lectura}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LecturaFormView(lecturaToEdit: lectura),
      ),
    );
    if (result == true) {
      _loadMockLecturas(); // Recargar datos si se guardó algo
    }
  }

  void _showDetailsDialog(Lectura lectura) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LecturaDetailsDialog(lectura: lectura);
      },
    );
  }

      Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Lectura de Medidores',
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
                        child: _buildLecturasTable(),
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
    final filterFields = [
      Expanded(
        flex: isMobile ? 0 : 2,
        child: AppInput(
          hintText: 'Buscar por ID Medidor, Fecha, ID Lectura...',
          controller: _searchController,
          icon: Icons.search,
          label: 'Buscar Lectura',
          isLabelVisible: !isMobile,
          onChanged: (value) {/* TODO: Implement search logic */},
        ),
      ),
      const SizedBox(width: Spacing.md, height: Spacing.md),
      Expanded(
        flex: isMobile ? 0 : 1,
        child: AppSelect<String>(
          label: 'Estado',
          value: _selectedEstadoFilter,
          options: EstadoLectura.values
              .map((e) => estadoLecturaToString(e))
              .toList(),
          labelBuilder: (v) => v,
          onChanged: (value) {
            setState(() {
              _selectedEstadoFilter = value;
              // TODO: Implement filter logic
            });
          },
          hint: const Text('Todos los estados'),
        ),
      ),
      // TODO: Add Date Range Pickers
    ];

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...filterFields,
              const SizedBox(height: Spacing.md),
              AppButton(
                text: 'Registrar Nueva Lectura',
                onPressed: () => _navigateToForm(),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...filterFields,
              const SizedBox(width: Spacing.md),
              AppButton(
                text: 'Registrar Lectura',
                onPressed: () => _navigateToForm(),
              ),
            ],
          );
  }

  Widget _buildLecturasTable() {
    // TODO: Apply filtering and search to _lecturas list before passing to AppTable
    List<Lectura> filteredLecturas = _lecturas;

    return AppTable<Lectura>(
      columns: const [
        'ID Lectura',
        'Fecha',
        'Medidor ID',
        'Lect. Anterior',
        'Lect. Actual',
        'Consumo',
        'Estado',
        'Acciones',
      ],
      items: filteredLecturas,
      buildRow: (lectura) {
        return DataRow(cells: [
          DataCell(Text(lectura.lecturaId,
              style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(DateFormat('dd/MM/yyyy').format(lectura.fechaLectura),
              style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(lectura.medidorId,
              style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(lectura.lecturaAnterior.toStringAsFixed(2),
              style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(lectura.lecturaActual.toStringAsFixed(2),
              style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(lectura.consumo.toStringAsFixed(2),
              style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Text(estadoLecturaToString(lectura.estadoLectura),
              style: TextStyle(color: AppTheme.texttableColor))),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.visibility,
                      color: AppTheme.texttableColor),
                  tooltip: 'Ver Detalles',
                  onPressed: () => _showDetailsDialog(lectura)),
              IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.texttableColor),
                  tooltip: 'Editar',
                  onPressed: () => _navigateToForm(lectura: lectura)),
            ],
          )),
        ]);
      },
    );
  }
}
