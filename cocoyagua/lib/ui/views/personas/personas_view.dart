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
import 'persona_information_form.dart';
import '../../components/tables/app_table.dart'; // <-- Importa el nuevo componente

// Definir la clase Persona
class Persona {
  final String nombreCompleto;
  final String tipoDocumento;
  final String nroDocumento;
  final String genero;
  final String tipoPersona;

  Persona({
    required this.nombreCompleto,
    required this.tipoDocumento,
    required this.nroDocumento,
    required this.genero,
    required this.tipoPersona,
  });
}

class PersonasView extends StatefulWidget {
  const PersonasView({super.key});

  @override
  _PersonasViewState createState() => _PersonasViewState();
}

class _PersonasViewState extends State<PersonasView> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _documentoController = TextEditingController();
  String? _selectedOption = 'Natural';
  String? _selectedOptionFilter = 'Nombre';
  String? _selectedTipoDocumento = 'DNI';
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  void _mostrarDialogoCrearPersona(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Text(
              'Crear nueva persona',
              style: AppTypography.body.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Complete los siguientes datos',
                    style: AppTypography.body2.copyWith(
                      color: AppTheme.texttableColor,
                    )),
                const SizedBox(height: 16),
                AppSelect<String>(
                  label: 'Tipo de documento',
                  value: _selectedTipoDocumento,
                  options: const ['DNI', 'Pasaporte', 'Carnet de Extranjería'],
                  labelBuilder: (v) => v,
                  onChanged: (value) {
                    setState(() {
                      _selectedTipoDocumento = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Número de documento',
                  controller: _documentoController,
                  hintText: 'Ingrese número de documento',
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'Continuar',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonInformationForm(
                            tipoDocumento: _selectedTipoDocumento ?? 'DNI',
                            numeroDocumento: _documentoController.text,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final List<Persona> personas = List.generate(8, (index) {
    return Persona(
      nombreCompleto: 'María Reina Saavedra Quiróz',
      tipoDocumento: 'DNI',
      nroDocumento: '4545678765677755',
      genero: 'Femenino',
      tipoPersona: 'Natural',
    );
  });

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .end, // Aligns children to the end (right)
                        children: [
                          // Container 1: Search Input
                          AppInput(
                            hintText: 'Buscar',
                            controller: _userController,
                            icon: Icons.search,
                            label: 'Buscar',
                            isLabelVisible: false,
                          ),
                          const SizedBox(height: Spacing.md),
                          // Container 2: Selects and Button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .end, // Also align children of this group to the end
                            children: [
                              AppSelect(
                                value: _selectedOption,
                                label: 'Tipo de persona',
                                options: const ['Natural', 'Jurídica'],
                                labelBuilder: (v) => v,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOption = value;
                                  });
                                },
                              ),
                              const SizedBox(height: Spacing.md),
                              AppSelect(
                                value: _selectedOptionFilter,
                                label: 'Filtrar por',
                                options: const ['Nombre', 'Documento'],
                                labelBuilder: (v) => v,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOptionFilter = value;
                                  });
                                },
                              ),
                              const SizedBox(height: Spacing.md),
                              // Button is no longer wrapped in SizedBox(width: double.infinity)
                              // so it can align to the end based on its parent's crossAxisAlignment.
                              AppButton(
                                text: 'Crear Persona',
                                icon: Icons.add,
                                onPressed: () =>
                                    _mostrarDialogoCrearPersona(context),
                              ),
                            ],
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
                                flex: 3,
                                child: AppInput(
                                  hintText: 'Buscar',
                                  controller: _userController,
                                  icon: Icons.search,
                                  label: 'Buscar',
                                ),
                              ),
                              const SizedBox(width: Spacing.md),
                              Expanded(
                                flex: 1,
                                child: AppSelect(
                                  value: _selectedOption,
                                  label: 'Tipo de persona',
                                  options: const ['Natural', 'Jurídica'],
                                  labelBuilder: (v) => v,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: Spacing.md),
                              Expanded(
                                flex: 1,
                                child: AppSelect(
                                  value: _selectedOptionFilter,
                                  label: 'Filtrar por',
                                  options: const ['Nombre', 'Documento'],
                                  labelBuilder: (v) => v,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOptionFilter = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: Spacing.md),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // o .center dependiendo del efecto
                                  children: [
                                    SizedBox(height: 28),
                                    AppButton(
                                      text: 'Crear Persona',
                                      onPressed: () =>
                                          _mostrarDialogoCrearPersona(context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: Spacing.lg),
                    AppCard(
                      child: SizedBox(
                        width: double.infinity,
                        child:
                            _buildAppTable(), // <-- Aquí uso la tabla reusable
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
        Text('Personas',
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

  Widget _buildAppTable() {
    return AppTable<Persona>(
      columns: [
        'NOMBRE COMPLETO',
        'DOCUMENTO',
        'NRO. DOCUMENTO',
        'GÉNERO',
        'TIPO DE PERSONA',
        '',
      ],
      items: personas,
      currentPage: _currentPage,
      rowsPerPage: _rowsPerPage,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      buildRow: (persona) {
        return DataRow(
          cells: [
            DataCell(Text(persona.nombreCompleto,
                style: TextStyle(color: AppTheme.texttableColor))),
            DataCell(Text(persona.tipoDocumento,
                style: TextStyle(color: AppTheme.texttableColor))),
            DataCell(Text(persona.nroDocumento,
                style: TextStyle(color: AppTheme.texttableColor))),
            DataCell(Text(persona.genero,
                style: TextStyle(color: AppTheme.texttableColor))),
            DataCell(Text(persona.tipoPersona,
                style: TextStyle(color: AppTheme.texttableColor))),
            DataCell(
              IconButton(
                icon: const Icon(Icons.edit, color: AppTheme.texttableColor),
                onPressed: () {
                  // Acción editar persona aquí
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
