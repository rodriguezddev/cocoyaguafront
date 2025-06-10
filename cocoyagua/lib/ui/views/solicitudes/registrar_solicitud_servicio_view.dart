import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

import '../../../models/solicitud_servicio_model.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';

class RegistrarSolicitudServicioView extends StatefulWidget {
  final SolicitudServicio? solicitudExistente;

  const RegistrarSolicitudServicioView({super.key, this.solicitudExistente});

  @override
  State<RegistrarSolicitudServicioView> createState() =>
      _RegistrarSolicitudServicioViewState();
}

class _RegistrarSolicitudServicioViewState
    extends State<RegistrarSolicitudServicioView> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;

  // Controllers
  late TextEditingController _fechaSolicitudController;
  late TextEditingController _fechaAprobacionController;
  late TextEditingController _numeroDocumentoController;
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoController;
  late TextEditingController _organizacionController;
  late TextEditingController _ubicacion1Controller;
  late TextEditingController _ubicacion2Controller;
  late TextEditingController _tomaDomiciliariaIdController;

  // Selected values
  String? _selectedTipoPersona;
  String? _selectedTipoDocumento;
  String? _selectedProvincia;
  String? _selectedCiudad;
  String? _selectedEstado;

  // Options for dropdowns
  final List<String> _tipoPersonaOptions = ['Natural', 'Jurídica'];
  final List<String> _tipoDocumentoOptions = [
    'DNI',
    'RUC',
    'Pasaporte',
    'Carnet de Extranjería'
  ];
  // TODO: Cargar provincias y ciudades dinámicamente o desde una fuente de datos
  final List<String> _provinciaOptions = [
    'Provincia A',
    'Provincia B',
    'Provincia C'
  ];
  final Map<String, List<String>> _ciudadOptionsMap = {
    'Provincia A': ['Ciudad A1', 'Ciudad A2'],
    'Provincia B': ['Ciudad B1', 'Ciudad B2'],
    'Provincia C': ['Ciudad C1', 'Ciudad C2'],
  };
  List<String> _currentCiudadOptions = [];
  final List<String> _estadoOptions = [
    'Activo',
    'En Revisión',
    'Completado',
    'Cancelado'
  ];

  @override
  void initState() {
    super.initState();
    final solicitud = widget.solicitudExistente;

    _fechaSolicitudController = TextEditingController(
        text: solicitud != null
            ? DateFormat('dd/MM/yyyy').format(solicitud.fechaSolicitud)
            : DateFormat('dd/MM/yyyy').format(DateTime.now()));
    _fechaAprobacionController = TextEditingController(
        text: solicitud?.fechaAprobacion != null
            ? DateFormat('dd/MM/yyyy').format(solicitud!.fechaAprobacion!)
            : '');
    _numeroDocumentoController =
        TextEditingController(text: solicitud?.numeroDocumento ?? '');
    _nombresController = TextEditingController(text: solicitud?.nombres ?? '');
    _apellidosController =
        TextEditingController(text: solicitud?.apellidos ?? '');
    _telefonoController =
        TextEditingController(text: solicitud?.telefono ?? '');
    _correoController = TextEditingController(text: solicitud?.correo ?? '');
    _organizacionController =
        TextEditingController(text: solicitud?.organizacion ?? '');
    _ubicacion1Controller =
        TextEditingController(text: solicitud?.ubicacion1 ?? '');
    _ubicacion2Controller =
        TextEditingController(text: solicitud?.ubicacion2 ?? '');
    _tomaDomiciliariaIdController =
        TextEditingController(text: solicitud?.tomaDomiciliariaId ?? '');

    _selectedTipoPersona = solicitud?.tipoPersona ?? _tipoPersonaOptions.first;
    _selectedTipoDocumento = solicitud?.tipoDocumento;
    _selectedProvincia = solicitud?.provincia;
    if (_selectedProvincia != null &&
        _ciudadOptionsMap.containsKey(_selectedProvincia)) {
      _currentCiudadOptions = _ciudadOptionsMap[_selectedProvincia]!;
    }
    _selectedCiudad = solicitud?.ciudad;
    _selectedEstado =
        solicitud?.estado ?? _estadoOptions[1]; // Default 'En Revisión'
  }

  @override
  void dispose() {
    _fechaSolicitudController.dispose();
    _fechaAprobacionController.dispose();
    _numeroDocumentoController.dispose();
    _nombresController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _organizacionController.dispose();
    _ubicacion1Controller.dispose();
    _ubicacion2Controller.dispose();
    _tomaDomiciliariaIdController.dispose();
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
      // TODO: Convertir fechas de String a DateTime antes de guardar
      // TODO: Crear o actualizar el objeto SolicitudServicio
      // TODO: Implementar lógica de guardado (API call, base de datos local, etc.)

      final String mensaje = widget.solicitudExistente == null
          ? 'Solicitud de servicio creada (simulación)'
          : 'Solicitud de servicio actualizada (simulación)';

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
                        .copyWith(color: AppTheme.textColor)),
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

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 3) {
        // 3 Pasos definidos
        setState(() {
          _currentStep++;
        });
      } else {
        _guardarSolicitud();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final String formTitle = widget.solicitudExistente == null
        ? 'Registrar Nueva Solicitud de Servicio'
        : 'Editar Solicitud de Servicio';

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formTitle,
                                  style: AppTypography.h2.copyWith(
                                      color: AppTheme.textPrimaryColor),
                                ),
                                const SizedBox(height: Spacing.sm),
                                Text(
                                  'Complete la información requerida para la solicitud de servicio.',
                                  style: AppTypography.bodyLg
                                      .copyWith(color: AppTheme.textColor),
                                ),
                              ],
                            ),
                          ),
                          _buildStepIndicatorRow(),
                        ],
                      ),
                      const SizedBox(height: Spacing.xl),
                      _buildStepContent(isMobile),
                      const SizedBox(height: Spacing.lg),
                      _buildActionButtons(isMobile),
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

  Widget _buildStepIndicatorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator(1,
            isActive: _currentStep == 1, label: "Solicitante"),
        _buildStepIndicator(2, isActive: _currentStep == 2, label: "Detalles"),
        _buildStepIndicator(3, isActive: _currentStep == 3, label: "Ubicación"),
      ],
    );
  }

  Widget _buildStepIndicator(int step,
      {bool isActive = false, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryColor : Colors.grey[300],
              shape: BoxShape.circle,
              border: isActive
                  ? Border.all(color: AppTheme.primaryColor, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: TextStyle(
                  color: isActive ? Colors.white : AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(label,
              style: AppTypography.caption.copyWith(
                  color: isActive ? AppTheme.primaryColor : AppTheme.textColor))
        ],
      ),
    );
  }

  Widget _buildStepContent(bool isMobile) {
    switch (_currentStep) {
      case 1:
        return _buildStep1Solicitante(isMobile);
      case 2:
        return _buildStep2DetallesSolicitud(isMobile);
      case 3:
        return _buildStep3Ubicacion(isMobile);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1Solicitante(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Información del Solicitante",
            style: AppTypography.h2
                .copyWith(fontSize: 20, color: AppTheme.textPrimaryColor)),
        const SizedBox(height: Spacing.md),
        Row(children: [
          Expanded(
              child: AppSelect<String>(
            label: 'Tipo de Persona*',
            value: _selectedTipoPersona,
            options: _tipoPersonaOptions,
            labelBuilder: (v) => v,
            onChanged: (v) => setState(() => _selectedTipoPersona = v),
            validator: (v) => v == null ? 'Campo requerido' : null,
          )),
          const SizedBox(width: Spacing.md),
          Expanded(
              child: AppSelect<String>(
            label: 'Tipo de Documento*',
            value: _selectedTipoDocumento,
            options: _tipoDocumentoOptions,
            labelBuilder: (v) => v,
            onChanged: (v) => setState(() => _selectedTipoDocumento = v),
            validator: (v) => v == null ? 'Campo requerido' : null,
          )),
        ]),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Número de Documento*',
          controller: _numeroDocumentoController,
          validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: Spacing.md),
        if (_selectedTipoPersona == 'Natural') ...[
          Row(children: [
            Expanded(
                child: AppInput(
              label: 'Nombres*',
              controller: _nombresController,
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            )),
            const SizedBox(width: Spacing.md),
            Expanded(
                child: AppInput(
              label: 'Apellidos*',
              controller: _apellidosController,
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            )),
          ]),
        ] else ...[
          // Jurídica
          AppInput(
            label: 'Razón Social*',
            controller:
                _nombresController, // Usamos el mismo controller de nombres
            validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
          ),
        ],
        const SizedBox(height: Spacing.md),
        Row(children: [
          Expanded(
              child: AppInput(
            label: 'Teléfono*',
            controller: _telefonoController,
            validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            keyboardType: TextInputType.phone,
          )),
          const SizedBox(width: Spacing.md),
          Expanded(
              child: AppInput(
            label: 'Correo Electrónico*',
            controller: _correoController,
            validator: (v) {
              if (v!.isEmpty) return 'Campo requerido';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                return 'Correo inválido';
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          )),
        ]),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Organización (Opcional)',
          controller: _organizacionController,
        ),
      ],
    );
  }

  Widget _buildStep2DetallesSolicitud(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Detalles de la Solicitud",
            style: AppTypography.h2
                .copyWith(fontSize: 20, color: AppTheme.textPrimaryColor)),
        const SizedBox(height: Spacing.md),
        Row(children: [
          Expanded(
              child: AppInput(
            label: 'Fecha de Solicitud*',
            controller: _fechaSolicitudController,
            readOnly: true,
            onTap: () => _selectDate(context, _fechaSolicitudController),
            validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
          )),
          const SizedBox(width: Spacing.md),
          Expanded(
              child: AppInput(
            label: 'Fecha de Aprobación',
            controller: _fechaAprobacionController,
            readOnly: true,
            onTap: () => _selectDate(context, _fechaAprobacionController),
            // No es obligatorio
          )),
        ]),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'ID Toma Domiciliaria (Referencia)*',
          controller: _tomaDomiciliariaIdController,
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
      ],
    );
  }

  Widget _buildStep3Ubicacion(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ubicación del Servicio",
            style: AppTypography.h2
                .copyWith(fontSize: 20, color: AppTheme.textPrimaryColor)),
        const SizedBox(height: Spacing.md),
        Row(children: [
          Expanded(
              child: AppSelect<String>(
            label: 'Provincia*',
            value: _selectedProvincia,
            options: _provinciaOptions,
            labelBuilder: (v) => v,
            onChanged: (v) {
              setState(() {
                _selectedProvincia = v;
                _selectedCiudad = null; // Reset ciudad
                _currentCiudadOptions =
                    (v != null && _ciudadOptionsMap.containsKey(v))
                        ? _ciudadOptionsMap[v]!
                        : [];
              });
            },
            validator: (v) => v == null ? 'Campo requerido' : null,
          )),
          const SizedBox(width: Spacing.md),
          Expanded(
              child: AppSelect<String>(
            label: 'Ciudad*',
            value: _selectedCiudad,
            options: _currentCiudadOptions,
            labelBuilder: (v) => v,
            onChanged: (v) => setState(() => _selectedCiudad = v),
            validator: (v) => v == null ? 'Campo requerido' : null,
          )),
        ]),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Ubicación 1 (Dirección Principal)*',
          controller: _ubicacion1Controller,
          validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
          maxLines: 2,
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Ubicación 2 (Referencia Adicional)',
          controller: _ubicacion2Controller,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    final Widget backButton = AppButton(
      text: 'Atrás',
      onPressed: _previousStep,
      kind: AppButtonKind.secondary,
      width: isMobile ? null : 120,
    );

    final Widget cancelButton = AppButton(
      text: 'Cancelar',
      onPressed: () => Navigator.of(context).pop(),
      kind: AppButtonKind.ghost,
      width: isMobile ? null : 120,
    );

    final Widget continueOrFinishButton = AppButton(
      text: _currentStep == 3 ? 'Finalizar y Guardar' : 'Continuar',
      onPressed: _nextStep,
      kind: AppButtonKind.primary,
      width: isMobile ? null : 180,
    );

    if (isMobile) {
      return Column(
        children: [
          SizedBox(width: double.infinity, child: continueOrFinishButton),
          const SizedBox(height: Spacing.sm),
          if (_currentStep > 1)
            SizedBox(width: double.infinity, child: backButton),
          if (_currentStep == 1)
            SizedBox(width: double.infinity, child: cancelButton),
        ],
      );
    } else {
      // Desktop
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_currentStep == 1) cancelButton,
          if (_currentStep > 1) backButton,
          const SizedBox(width: Spacing.md),
          continueOrFinishButton,
        ],
      );
    }
  }
}
