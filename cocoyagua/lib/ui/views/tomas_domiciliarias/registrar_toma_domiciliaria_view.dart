// lib/ui/views/tomas_domiciliarias/registrar_toma_domiciliaria_view.dart
import 'package:flutter/material.dart';
import '../../components/buttons/app_button.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';
import 'form_steps/step1_datos_generales_toma.dart';
import 'form_steps/step2_ubicacion_toma.dart';
import 'form_steps/step3_resumen_guardar_toma.dart';

class RegistrarTomaDomiciliariaView extends StatefulWidget {
  const RegistrarTomaDomiciliariaView({super.key});

  @override
  State<RegistrarTomaDomiciliariaView> createState() =>
      _RegistrarTomaDomiciliariaViewState();
}

class _RegistrarTomaDomiciliariaViewState
    extends State<RegistrarTomaDomiciliariaView> {
  int _currentStep = 1;

  // Controllers para Step 1: Datos Generales
  final _documentoImpresoIdController = TextEditingController();
  final _empleadoController = TextEditingController(); // Asumimos input por ahora
  final _fechaRegistroController = TextEditingController();
  final _idaController = TextEditingController();
  final _tomaDomiciliariaIdController = TextEditingController();
  String? _selectedEstado;
  String? _selectedUsoSuministro;

  // Controllers para Step 2: Ubicación
  String? _selectedDepartamento;
  String? _selectedMunicipio;
  final _localidad1Controller = TextEditingController();
  final _localidad2Controller = TextEditingController();
  final _localidad3Controller = TextEditingController();
  final _claveCatastralController = TextEditingController();
  final _coordenadasController = TextEditingController();

  // Opciones para selects
  final List<String> _estadoOptions = ['Activa', 'Pendiente', 'Cancelada'];
  final List<String> _usoSuministroOptions = [
    'Residencial',
    'Comercial',
    'Industrial',
    'Gubernamental',
    'Otro'
  ];
  final List<String> _departamentoOptions = [
    'Atlántida',
    'Colón',
    'Comayagua',
    'Copán',
    'Cortés',
    'Choluteca',
    'El Paraíso',
    'Francisco Morazán',
    'Gracias a Dios',
    'Intibucá',
    'Islas de la Bahía',
    'La Paz',
    'Lempira',
    'Ocotepeque',
    'Olancho',
    'Santa Bárbara',
    'Valle',
    'Yoro'
  ];
  // Municipios deberían ser dinámicos basados en departamento, pero para ejemplo:
  final Map<String, List<String>> _municipioOptionsMap = {
    'Atlántida': ['La Ceiba', 'Tela', 'Jutiapa'],
    'Francisco Morazán': ['Tegucigalpa', 'Valle de Ángeles', 'Santa Lucía'],
    // ... agregar más
  };
  List<String> _currentMunicipioOptions = [];

 @override
  void dispose() {
    _documentoImpresoIdController.dispose();
    _empleadoController.dispose();
    _fechaRegistroController.dispose();
    _idaController.dispose();
    _tomaDomiciliariaIdController.dispose();
    _localidad1Controller.dispose();
    _localidad2Controller.dispose();
    _localidad3Controller.dispose();
    _claveCatastralController.dispose();
    _coordenadasController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    // Similar al de PersonInformationForm pero adaptado
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Registrar Toma', // Título adaptado
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        // Puedes mantener la información del usuario si es relevante en este contexto
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Santiago Meza Alvés',
                    style: AppTypography.bodyLg
                        .copyWith(color: AppTheme.textPrimaryColor)),
                Text('Operador', // Rol adaptado
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
    // Aquí irían las validaciones por paso
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Lógica para finalizar y guardar
      print('Formulario finalizado. Guardando datos...');
      // Por ejemplo, mostrar un SnackBar
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toma domiciliaria registrada (simulación)')),
      );
      Navigator.of(context).pop(); // Volver a la vista anterior
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  Widget _buildStepIndicator(int step, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicatorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator(1, isActive: _currentStep == 1),
        _buildStepIndicator(2, isActive: _currentStep == 2),
        _buildStepIndicator(3, isActive: _currentStep == 3),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registro de Nueva Toma Domiciliaria',
                                style: AppTypography.h2.copyWith(
                                    color: AppTheme.textPrimaryColor),
                              ),
                              const SizedBox(height: Spacing.sm),
                              Text(
                                'Complete la información en los siguientes pasos.',
                                style: AppTypography.bodyLg.copyWith(
                                    color: AppTheme.textColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Spacing.lg),
                        _buildStepIndicatorRow(),
                      ],
                    ),
                    _buildStepContent(context, isMobile),
                    const SizedBox(height: Spacing.lg),
                    _buildActionButtons(isMobile),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, bool isMobile) {
    switch (_currentStep) {
      case 1:
        return Step1DatosGeneralesToma(
          isMobile: isMobile,
          documentoImpresoIdController: _documentoImpresoIdController,
          empleadoController: _empleadoController,
          fechaRegistroController: _fechaRegistroController,
          idaController: _idaController,
          tomaDomiciliariaIdController: _tomaDomiciliariaIdController,
          selectedEstado: _selectedEstado,
          estadoOptions: _estadoOptions,
          onEstadoChanged: (value) => setState(() => _selectedEstado = value),
          selectedUsoSuministro: _selectedUsoSuministro,
          usoSuministroOptions: _usoSuministroOptions,
          onUsoSuministroChanged: (value) =>
              setState(() => _selectedUsoSuministro = value),
        );
      case 2:
        return Step2UbicacionToma(
          isMobile: isMobile,
          selectedDepartamento: _selectedDepartamento,
          departamentoOptions: _departamentoOptions,
          onDepartamentoChanged: (value) {
            setState(() {
              _selectedDepartamento = value;
              _selectedMunicipio = null; // Reset municipio
              _currentMunicipioOptions = _municipioOptionsMap[value] ?? [];
            });
          },
          selectedMunicipio: _selectedMunicipio,
          municipioOptions: _currentMunicipioOptions,
          onMunicipioChanged: (value) =>
              setState(() => _selectedMunicipio = value),
          localidad1Controller: _localidad1Controller,
          localidad2Controller: _localidad2Controller,
          localidad3Controller: _localidad3Controller,
          claveCatastralController: _claveCatastralController,
          coordenadasController: _coordenadasController,
        );
      case 3:
        return Step3ResumenGuardarToma(
          isMobile: isMobile,
          // Pasar todos los datos recolectados
          documentoImpresoId: _documentoImpresoIdController.text,
          empleado: _empleadoController.text,
          fechaRegistro: _fechaRegistroController.text,
          ida: _idaController.text,
          tomaDomiciliariaId: _tomaDomiciliariaIdController.text,
          estado: _selectedEstado ?? 'N/A',
          usoSuministro: _selectedUsoSuministro ?? 'N/A',
          departamento: _selectedDepartamento ?? 'N/A',
          municipio: _selectedMunicipio ?? 'N/A',
          localidad1: _localidad1Controller.text,
          localidad2: _localidad2Controller.text,
          localidad3: _localidad3Controller.text,
          claveCatastral: _claveCatastralController.text,
          coordenadas: _coordenadasController.text,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons(bool isMobile) {
    final Widget backButton = AppButton(
      text: 'Atrás',
      onPressed: _previousStep,
      kind: AppButtonKind.secondary, // Usar AppButton
      width: isMobile ? null : 120,
    );

    final Widget cancelButton = AppButton(
      text: 'Cancelar',
      onPressed: () => Navigator.of(context).pop(),
      kind: AppButtonKind.secondary, // Usar AppButton
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
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              if (_currentStep > 1) Expanded(child: backButton),
              if (_currentStep > 1 && _currentStep == 1) const SizedBox(width: Spacing.md), // Condición nunca cierta, revisar
              if (_currentStep == 1) Expanded(child: cancelButton),
            ],
          ),
        ],
      );
    } else {
      // Desktop layout
      List<Widget> webButtons = [];
      if (_currentStep == 1) {
        webButtons.add(cancelButton);
        webButtons.add(const SizedBox(width: Spacing.md));
      }
      if (_currentStep > 1) {
        webButtons.add(backButton);
        webButtons.add(const SizedBox(width: Spacing.md));
      }
      webButtons.add(continueOrFinishButton);

      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: webButtons,
      );
    }
  }
}
