import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/contrato_model.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';

class RegistrarContratoView extends StatefulWidget {
  final ContratoModel? contratoExistente;

  const RegistrarContratoView({super.key, this.contratoExistente});

  @override
  State<RegistrarContratoView> createState() => _RegistrarContratoViewState();
}

class _RegistrarContratoViewState extends State<RegistrarContratoView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _idController;
  late TextEditingController _fechaContratoController;
  late TextEditingController _fechaFinalizacionController;
  late TextEditingController _clienteIdController;
  late TextEditingController _titularIdController;
  late TextEditingController _tomaDomiciliariaIdController;
  late TextEditingController _medidorIdController;
  late TextEditingController _asignacionMedidorIdController;
  late TextEditingController _empleadoIdController;
  late TextEditingController _documentoImpresoIdController;

  String? _selectedEstado;
  final List<String> _estadoOptions = [
    'Activo',
    'Pendiente Firma',
    'Finalizado',
    'Suspendido',
    'Cancelado'
  ]; // Ejemplo

  // TODO: Cargar opciones para Cliente, Titular, Toma, Medidor, Empleado desde un servicio

  @override
  void initState() {
    super.initState();
    final contrato = widget.contratoExistente;

    _idController = TextEditingController(
        text: contrato?.id ?? ''); // Podría ser no editable
    _fechaContratoController = TextEditingController(
        text: contrato != null
            ? DateFormat('dd/MM/yyyy').format(contrato.fechaContrato)
            : DateFormat('dd/MM/yyyy').format(DateTime.now()));
    _fechaFinalizacionController = TextEditingController(
        text: contrato?.fechaFinalizacion != null
            ? DateFormat('dd/MM/yyyy').format(contrato!.fechaFinalizacion!)
            : '');
    _clienteIdController =
        TextEditingController(text: contrato?.clienteId ?? '');
    _titularIdController =
        TextEditingController(text: contrato?.titularId ?? '');
    _tomaDomiciliariaIdController =
        TextEditingController(text: contrato?.tomaDomiciliariaId ?? '');
    _medidorIdController =
        TextEditingController(text: contrato?.medidorId ?? '');
    _asignacionMedidorIdController =
        TextEditingController(text: contrato?.asignacionMedidorId ?? '');
    _empleadoIdController =
        TextEditingController(text: contrato?.empleadoId ?? '');
    _documentoImpresoIdController =
        TextEditingController(text: contrato?.documentoImpresoId ?? '');

    _selectedEstado = contrato?.estado ?? _estadoOptions.first;
  }

  @override
  void dispose() {
    _idController.dispose();
    _fechaContratoController.dispose();
    _fechaFinalizacionController.dispose();
    _clienteIdController.dispose();
    _titularIdController.dispose();
    _tomaDomiciliariaIdController.dispose();
    _medidorIdController.dispose();
    _asignacionMedidorIdController.dispose();
    _empleadoIdController.dispose();
    _documentoImpresoIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(controller.text);
      } catch (e) {/* Mantener inicial */}
    }
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() => controller.text = DateFormat('dd/MM/yyyy').format(picked));
    }
  }

  void _guardarContrato() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Convertir fechas de String a DateTime
      // TODO: Crear o actualizar el objeto ContratoModel
      // TODO: Implementar lógica de guardado (API call, validaciones cruzadas)
      // Ejemplo de validación cruzada (conceptual):
      // bool titularActivo = await checkTitularActivo(_titularIdController.text);
      // bool medidorDisponible = await checkMedidorDisponible(_medidorIdController.text);
      // if (!titularActivo) { /* Mostrar error */ return; }
      // if (!medidorDisponible && _medidorIdController.text.isNotEmpty) { /* Mostrar error */ return; }

      final String mensaje = widget.contratoExistente == null
          ? 'Contrato creado (simulación)'
          : 'Contrato actualizado (simulación)';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
      Navigator.of(context).pop();
    }
  }

  Widget _buildHeader() {
    // Reutilizado de RegistrarTitularView
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Gestión de Contratos',
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
                radius: 20),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final String formTitle = widget.contratoExistente == null
        ? 'Registrar Nuevo Contrato'
        : 'Editar Contrato';

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
                      Text(formTitle,
                          style: AppTypography.h2
                              .copyWith(color: AppTheme.textPrimaryColor)),
                      const SizedBox(height: Spacing.sm),
                      Text(
                          'Complete la información requerida para el contrato.',
                          style: AppTypography.bodyLg
                              .copyWith(color: AppTheme.textColor)),
                      const SizedBox(height: Spacing.xl),
                      _buildFormFields(isMobile),
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

  Widget _buildFormFields(bool isMobile) {
    // TODO: Reemplazar AppInput por AppSelect con búsqueda para Cliente, Titular, Toma, Medidor, Empleado
    return Column(
      children: [
        AppInput(
            label: 'ID Contrato (CONTRATO_ID)',
            controller: _idController,
            validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: Spacing.md),
        Row(children: [
          Expanded(
              child: AppInput(
                  label: 'Fecha Contrato*',
                  controller: _fechaContratoController,
                  readOnly: true,
                  onTap: () => _selectDate(context, _fechaContratoController),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null)),
          const SizedBox(width: Spacing.md),
          Expanded(
              child: AppInput(
                  label: 'Fecha Finalización',
                  controller: _fechaFinalizacionController,
                  readOnly: true,
                  onTap: () =>
                      _selectDate(context, _fechaFinalizacionController))),
        ]),
        const SizedBox(height: Spacing.md),
        AppInput(
            label: 'Cliente ID (CLIENTE_ID)*',
            controller: _clienteIdController,
            validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: Spacing.md),
        AppInput(
            label: 'Titular ID (TOMADOTITULAR_ID)*',
            controller: _titularIdController,
            validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: Spacing.md),
        AppInput(
            label: 'Toma Domiciliaria ID (TOMADOMICILIARIA_ID)*',
            controller: _tomaDomiciliariaIdController,
            validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: Spacing.md),
        Row(children: [
          Expanded(
              child: AppInput(
                  label: 'Medidor ID (MEDIDOR_ID)',
                  controller: _medidorIdController)),
          const SizedBox(width: Spacing.md),
          Expanded(
              child: AppInput(
                  label: 'Asignación Medidor ID (ASIGNACIONMEDIDOR_ID)',
                  controller: _asignacionMedidorIdController)),
        ]),
        const SizedBox(height: Spacing.md),
        AppInput(
            label: 'Empleado Asignado ID (EMPLEADO_ID)*',
            controller: _empleadoIdController,
            validator: (v) => v!.isEmpty ? 'Requerido' : null),
        const SizedBox(height: Spacing.md),
        AppSelect<String>(
            label: 'Estado del Contrato*',
            value: _selectedEstado,
            options: _estadoOptions,
            onChanged: (v) => setState(() => _selectedEstado = v),
            labelBuilder: (s) => s,
            validator: (v) => v == null ? 'Requerido' : null),
        const SizedBox(height: Spacing.md),
        AppInput(
            label: 'Documento Impreso ID (DOCUMENTOIMPRESO_ID)',
            controller: _documentoImpresoIdController),
      ],
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
            text: 'Cancelar',
            onPressed: () => Navigator.of(context).pop(),
            kind: AppButtonKind.secondary,
            width: isMobile ? null : 120),
        const SizedBox(width: Spacing.md),
        AppButton(
          text: widget.contratoExistente == null
              ? 'Crear Contrato'
              : 'Actualizar Contrato',
          onPressed: _guardarContrato,
          kind: AppButtonKind.primary,
          width: isMobile ? null : 180,
        ),
      ],
    );
  }
}
