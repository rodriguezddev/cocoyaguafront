import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

import '../../../models/solicitud_conexion_model.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';

class RegistrarSolicitudConexionView extends StatefulWidget {
  final SolicitudConexion? solicitudExistente;

  const RegistrarSolicitudConexionView({super.key, this.solicitudExistente});

  @override
  State<RegistrarSolicitudConexionView> createState() =>
      _RegistrarSolicitudConexionViewState();
}

class _RegistrarSolicitudConexionViewState
    extends State<RegistrarSolicitudConexionView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _fechaSolicitudController;
  late TextEditingController _direccionController;
  late TextEditingController _descripcionRequerimientoController;

  // Selected values
  String? _selectedEstado;

  // Options for dropdowns
  // TODO: Definir los estados posibles para una solicitud de conexión
  final List<String> _estadoOptions = [
    'Nueva',
    'En Proceso',
    'Instalada',
    'Cancelada'
  ];

  @override
  void initState() {
    super.initState();
    final solicitud = widget.solicitudExistente;

    _fechaSolicitudController = TextEditingController(
        text: solicitud != null
            ? DateFormat('dd/MM/yyyy').format(solicitud.fechaSolicitud)
            : DateFormat('dd/MM/yyyy').format(DateTime.now()));
    _direccionController =
        TextEditingController(text: solicitud?.direccion ?? '');
    _descripcionRequerimientoController =
        TextEditingController(text: solicitud?.descripcionRequerimiento ?? '');

    _selectedEstado =
        solicitud?.estado ?? _estadoOptions.first; // Default 'Nueva'
  }

  @override
  void dispose() {
    _fechaSolicitudController.dispose();
    _direccionController.dispose();
    _descripcionRequerimientoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _guardarSolicitud() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Convertir fecha de String a DateTime antes de guardar
      // TODO: Crear o actualizar el objeto SolicitudConexion
      // TODO: Implementar lógica de guardado (API call, base de datos local, etc.)

      final String mensaje = widget.solicitudExistente == null
          ? 'Solicitud de conexión creada (simulación)'
          : 'Solicitud de conexión actualizada (simulación)';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
      Navigator.of(context).pop(); // Volver a la lista
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Solicitudes', // Título del módulo
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Santiago Meza Alvés',
                    style: AppTypography.bodyLg
                        .copyWith(color: AppTheme.textPrimaryColor)),
                Text('Operador',
                    style: AppTypography.bodySm
                        .copyWith(color: AppTheme.textPrimaryColor)),
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
    final String formTitle = widget.solicitudExistente == null
        ? 'Registrar Nueva Solicitud de Conexión'
        : 'Editar Solicitud de Conexión';

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
                leading: BackButton(
                    color: AppTheme.textPrimaryColor,
                    onPressed: () => Navigator.of(context).pop()),
                title: _buildHeader(),
                toolbarHeight: 80,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formTitle,
                        style: AppTypography.h2
                            .copyWith(color: AppTheme.textPrimaryColor),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        'Complete la información requerida para la solicitud de conexión.',
                        style: AppTypography.bodyLg
                            .copyWith(color: AppTheme.textColor),
                      ),
                      const SizedBox(height: Spacing.xl),

                      // Campos del formulario
                      AppInput(
                        label: 'Fecha de Solicitud*',
                        controller: _fechaSolicitudController,
                        readOnly: true,
                        onTap: () =>
                            _selectDate(context, _fechaSolicitudController),
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AppInput(
                        label: 'Dirección*',
                        controller: _direccionController,
                        maxLines: 2, // Puede ser una dirección larga
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AppInput(
                        label: 'Descripción del Requerimiento*',
                        controller: _descripcionRequerimientoController,
                        maxLines: 4,
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AppSelect<String>(
                        label: 'Estado de la Solicitud*',
                        value: _selectedEstado,
                        options: _estadoOptions,
                        labelBuilder: (v) => v,
                        onChanged: (v) => setState(() => _selectedEstado = v),
                        validator: (v) => v == null ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: Spacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            text: 'Cancelar',
                            onPressed: () => Navigator.of(context).pop(),
                            kind: AppButtonKind.secondary,
                            width: isMobile ? null : 120,
                          ),
                          const SizedBox(width: Spacing.md),
                          AppButton(
                            text: widget.solicitudExistente == null
                                ? 'Crear Solicitud'
                                : 'Actualizar Solicitud',
                            onPressed: _guardarSolicitud,
                            kind: AppButtonKind.primary,
                            width: isMobile ? null : 180,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
