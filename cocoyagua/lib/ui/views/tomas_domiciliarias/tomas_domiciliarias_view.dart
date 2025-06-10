import 'package:flutter/material.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/layout/app_card.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';
import 'registrar_toma_domiciliaria_view.dart'; // For navigation
import '../../components/tables/app_table.dart';

// Data class for table rows
class _TomaRowData {
  final String documentoImpresoId;
  final String empleado;
  final String fechaRegistro;
  final String ida;
  final String tomaDomiciliariaId;
  final String estado;
  // Nuevos campos para el modal
  final String usoSuministro;
  final String departamento;
  final String municipio;
  final String localidad1;
  final String? localidad2; // Opcional
  final String? localidad3; // Opcional
  final String claveCatastral;
  final String coordenadas;

  _TomaRowData({
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
}

class TomasDomiciliariasView extends StatefulWidget {
  const TomasDomiciliariasView({super.key});

  @override
  _TomasDomiciliariasViewState createState() => _TomasDomiciliariasViewState();
}

class _TomasDomiciliariasViewState extends State<TomasDomiciliariasView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedEstado = 'Activa'; // Default filter example
  String? _selectedFiltroGeneral = 'ID Toma'; // Default filter example
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  // Sample data for the table
  final List<_TomaRowData> _tomasDataList = List.generate(12, (index) {
    return _TomaRowData(
      documentoImpresoId: 'DOC-IMP-${1000 + index}',
      empleado: 'Carlos Pérez', // Example employee
      fechaRegistro: '2024-0${(index % 9) + 1}-${(index % 28) + 1}',
      ida: 'IDA-${2000 + index}',
      tomaDomiciliariaId: 'TOMA-DOM-${3000 + index}',
      estado: (index % 3 == 0)
          ? 'Activa'
          : (index % 3 == 1 ? 'Pendiente' : 'Cancelada'),
      usoSuministro: 'Residencial',
      departamento: 'Atlántida',
      municipio: 'La Ceiba',
      localidad1: 'Barrio El Centro',
      localidad2: (index % 2 == 0) ? 'Colonia El Sauce' : null, // Example for optional field
      localidad3: (index % 3 == 0) ? 'Aldea El Pino' : null,    // Example for optional field
      claveCatastral: '0101-001-00203',
      coordenadas: '15.7833° N, 86.7833° W',

    );
  });

  void _mostrarDialogoDetallesToma(BuildContext context, _TomaRowData toma) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Detalles de Toma Domiciliaria',
            style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor),
          ),
          content: DefaultTabController(
            length: 2,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.30, // Reducido al 55% del ancho de pantalla
              height: 350, // Ajusta esta altura según sea necesario
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TabBar(
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: AppTheme.textColor,
                    indicatorColor: AppTheme.primaryColor,
                    tabs: const [
                      Tab(text: 'Datos Generales'),
                      Tab(text: 'Ubicación'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildDatosGeneralesTab(toma),
                        _buildUbicacionTab(toma),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            AppButton(
              text: 'Cerrar',
              onPressed: () {
                Navigator.of(context).pop();
              },
              kind: AppButtonKind.ghost,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatosGeneralesTab(_TomaRowData toma) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.md),
      child: ListBody(
        children: <Widget>[
          _buildDetailRow('Documento Impreso ID:', toma.documentoImpresoId),
          _buildDetailRow('Empleado:', toma.empleado),
          _buildDetailRow('Fecha Registro:', toma.fechaRegistro),
          _buildDetailRow('IDA:', toma.ida),
          _buildDetailRow('Toma Domiciliaria ID:', toma.tomaDomiciliariaId),
          _buildDetailRow('Estado:', toma.estado),
          _buildDetailRow('Uso de Suministro:', toma.usoSuministro),
        ],
      ),
    );
  }

  Widget _buildUbicacionTab(_TomaRowData toma) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.md),
      child: ListBody(
        children: <Widget>[
          _buildDetailRow('Departamento:', toma.departamento),
          _buildDetailRow('Municipio:', toma.municipio),
          _buildDetailRow('Localidad 1:', toma.localidad1),
          if (toma.localidad2 != null && toma.localidad2!.isNotEmpty)
            _buildDetailRow('Localidad 2:', toma.localidad2!),
          if (toma.localidad3 != null && toma.localidad3!.isNotEmpty)
            _buildDetailRow('Localidad 3:', toma.localidad3!),
          _buildDetailRow('Clave Catastral:', toma.claveCatastral),
          _buildDetailRow('Coordenadas:', toma.coordenadas),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: AppTypography.body.copyWith(color: AppTheme.textColor),
          children: [
            TextSpan(
                text: label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor)), // Label con color primario y bold
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    // Filtered list (actual filtering logic would go here)
    // For now, it just uses the full list
    final List<_TomaRowData> filteredTomas = _tomasDataList;

    return Scaffold(
      drawer: isMobile ? const Drawer(child: SidebarMenu()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const SidebarMenu(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false, // No back button in AppBar
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppInput(
                            hintText: 'Buscar Toma...',
                            controller: _searchController,
                            icon: Icons.search,
                            label: 'Buscar',
                            isLabelVisible: false,
                          ),
                          const SizedBox(height: Spacing.md),
                          AppSelect<String>(
                            value: _selectedEstado,
                            label: 'Estado',
                            options: const [
                              'Activa',
                              'Pendiente',
                              'Cancelada',
                              'Todas'
                            ],
                            labelBuilder: (v) => v,
                            onChanged: (value) {
                              setState(() {
                                _selectedEstado = value;
                                // Add filtering logic here
                              });
                            },
                          ),
                          const SizedBox(height: Spacing.md),
                          AppSelect<String>(
                            value: _selectedFiltroGeneral,
                            label: 'Filtrar por',
                            options: const [
                              'ID Toma',
                              'Empleado',
                              'Documento Impreso ID'
                            ],
                            labelBuilder: (v) => v,
                            onChanged: (value) {
                              setState(() {
                                _selectedFiltroGeneral = value;
                                // Add filtering logic here
                              });
                            },
                          ),
                          const SizedBox(height: Spacing.md),
                          AppButton(
                            text: 'Crear Toma',
                            icon: Icons.add,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrarTomaDomiciliariaView(),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: AppInput(
                              hintText: 'Buscar Toma Domiciliaria...',
                              controller: _searchController,
                              icon: Icons.search,
                              label: 'Buscar',
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            flex: 1, // Adjusted flex
                            child: AppSelect<String>(
                              value: _selectedEstado,
                              label: 'Estado',
                              options: const [
                                'Activa',
                                'Pendiente',
                                'Cancelada',
                                'Todas'
                              ],
                              labelBuilder: (v) => v,
                              onChanged: (value) {
                                setState(() {
                                  _selectedEstado = value;
                                  // Add filtering logic here
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            flex: 1, // Adjusted flex
                            child: AppSelect<String>(
                              value: _selectedFiltroGeneral,
                              label: 'Filtrar por',
                              options: const [
                                'ID Toma',
                                'Empleado',
                                'Documento ID'
                              ],
                              labelBuilder: (v) => v,
                              onChanged: (value) {
                                setState(() {
                                  _selectedFiltroGeneral = value;
                                  // Add filtering logic here
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // o .center dependiendo del efecto
                                children: [
                                  SizedBox(height: 28),
                                  AppButton(
                                    text: 'Crear Toma',
                                    icon: null,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegistrarTomaDomiciliariaView(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                        ],
                      ),
                  ],),
                    const SizedBox(height: Spacing.lg),
                    AppCard(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildAppTable(filteredTomas),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tomas Domiciliarias', // Changed title
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        // This user info part can be a shared widget or customized as needed
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Santiago Meza Alvés',
                    style: AppTypography.bodyLg
                        .copyWith(color: AppTheme.textPrimaryColor)),
                Text('Administrador',
                    style: AppTypography.bodySm.copyWith(
                        color: AppTheme.textColor)),
              ],
            ),
            const SizedBox(width: Spacing.md),
            const CircleAvatar(
              backgroundColor: AppTheme.primaryColor, // Changed color
              child: Icon(Icons.person, color: Colors.white),
              radius: 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppTable(List<_TomaRowData> tomas) {
    return AppTable<_TomaRowData>(
      columns: const [
        'DOC. IMPRESO ID',
        'EMPLEADO',
        'FECHA REGISTRO',
        'IDA',
        'TOMA ID',
        'ESTADO',
        'ACCIONES',
      ],
      items: tomas,
      currentPage: _currentPage,
      rowsPerPage: _rowsPerPage,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      buildRow: (toma) {
        return DataRow(
          cells: [
            DataCell(Text(toma.documentoImpresoId,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(toma.empleado,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(toma.fechaRegistro,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(toma.ida,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(toma.tomaDomiciliariaId, style: AppTypography.bodySmall.copyWith(color: AppTheme.texttableColor))),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Ajustado el padding para mejor visualización
              decoration: BoxDecoration(
                  color: toma.estado == 'Activa'
                      ? Colors.green.withOpacity(0.1)
                      : toma.estado == 'Pendiente'
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: toma.estado == 'Activa'
                          ? Colors.green
                          : toma.estado == 'Pendiente'
                              ? Colors.orange
                              : Colors.red,
                      width: 0.5)),
              child: Text(toma.estado,
                  style: AppTypography.bodySmall.copyWith(
                      color: toma.estado == 'Activa'
                          ? Colors.green.shade700
                          : toma.estado == 'Pendiente'
                              ? Colors.orange.shade700
                              : Colors.red.shade700,
                      fontWeight: FontWeight.w500)),
            )),
            DataCell(
              IconButton(
                icon: const Icon(Icons.visibility_outlined,
                    color: AppTheme.primaryColor, size: 20),
                tooltip: 'Ver Detalles',
                onPressed: () {
                  _mostrarDialogoDetallesToma(context, toma);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
