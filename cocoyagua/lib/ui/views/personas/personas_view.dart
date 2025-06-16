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
import 'edit_persona_information_form.dart';
import '../../widgets/dialogs/person_details_dialog.dart';
import '../../components/tables/app_table.dart';

// Enum para los roles de persona
enum RolPersona { cliente, empleado, proveedor }

// Helper para convertir enum a String legible
String rolPersonaToString(RolPersona rol) {
  switch (rol) {
    case RolPersona.cliente:
      return 'Cliente';
    case RolPersona.empleado:
      return 'Empleado';
    case RolPersona.proveedor:
      return 'Proveedor';
  }
}
class Persona {
  final String nombreCompleto;
  final String tipoDocumento;
  final String nroDocumento;
  final String genero;
  final String tipoPersona;
  final List<RolPersona> roles;

  Persona({
    required this.nombreCompleto,
    required this.tipoDocumento,
    required this.nroDocumento,
    required this.genero,
    required this.tipoPersona,
     this.roles = const [],
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
  String? _selectedOptionFilter = 'Nombre';
  String? _selectedTipoPersonaFilter = 'Natural';
  String? _selectedTipoDocumento = 'DNI';
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  @override
  void dispose() {
    _userController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  void _mostrarDialogoCrearPersona(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedTipoPersonaDialogo = 'Natural';

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
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Complete los siguientes datos',
                      style: AppTypography.body2.copyWith(
                        color: AppTheme.texttableColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppSelect<String>(
                      label: 'Tipo de persona',
                      value: selectedTipoPersonaDialogo,
                      options: const ['Natural', 'Jurídica'],
                      labelBuilder: (v) => v,
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedTipoPersonaDialogo = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    AppSelect<String>(
                      label: 'Tipo de documento',
                      value: _selectedTipoDocumento,
                      options: const [
                        'DNI',
                        'Pasaporte',
                        'Carnet de Extranjería'
                      ],
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
                                initialPersonType: selectedTipoPersonaDialogo,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  final List<Persona> personas = List.generate(8, (index) {
    return Persona(
      nombreCompleto: 'María Reina Saavedra Quiróz',
      tipoDocumento: index % 2 == 0 ? 'DNI' : 'RUC',
      nroDocumento: '4545678${index}65677755',
      genero: 'Femenino',
      tipoPersona: index % 2 == 0 ? 'Natural' : 'Jurídica',
      roles: index % 3 == 0
          ? [RolPersona.cliente, RolPersona.empleado]
          : (index % 3 == 1 ? [RolPersona.proveedor] : [RolPersona.cliente]),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppInput(
                            hintText: 'Buscar',
                            controller: _userController,
                            icon: Icons.search,
                            label: 'Buscar',
                            isLabelVisible: false,
                          ),
                          const SizedBox(height: Spacing.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AppSelect<String>(
                                value: _selectedTipoPersonaFilter,
                                label: 'Tipo de persona',
                                options: const ['Natural', 'Jurídica'],
                                labelBuilder: (v) => v,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTipoPersonaFilter = value;
                                  });
                                },
                              ),
                              const SizedBox(height: Spacing.md),
                              AppSelect<String>(
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
                                flex: 4,
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
                                child: AppSelect<String>(
                                  value: _selectedTipoPersonaFilter,
                                  label: 'Tipo de persona',
                                  options: const ['Natural', 'Jurídica'],
                                  labelBuilder: (v) => v,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTipoPersonaFilter = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: Spacing.md),
                              Expanded(
                                flex: 1,
                                child: AppSelect<String>(
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 28),
                                  AppButton(
                                    text: 'Crear Persona',
                                    onPressed: () =>
                                        _mostrarDialogoCrearPersona(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: Spacing.lg),
                    AppCard(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildAppTable(),
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
        'ROLES',
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
                DataCell(Text(
                persona.roles
                    .map(rolPersonaToString)
                    .join(', '), // Mostrar roles
                style: TextStyle(color: AppTheme.texttableColor))),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility,
                        color: AppTheme.texttableColor),
                    tooltip: 'Ver Detalles',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PersonDetailsDialog(persona: persona);
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.edit, color: AppTheme.texttableColor),
                    tooltip: 'Editar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPersonInformationForm(
                            personaToEdit: persona,
                            // initialRoles: persona.roles,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
