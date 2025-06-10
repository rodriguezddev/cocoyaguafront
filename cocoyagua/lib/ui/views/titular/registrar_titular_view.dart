import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../models/titular_model.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';

class RegistrarTitularView extends StatefulWidget {
  final TitularModel? titularExistente;

  const RegistrarTitularView({super.key, this.titularExistente});

  @override
  State<RegistrarTitularView> createState() => _RegistrarTitularViewState();
}

class _RegistrarTitularViewState extends State<RegistrarTitularView> {
  // TODO: Implementar controladores, estado y lógica del formulario
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _idController;
  late TextEditingController _clienteIdController;
  late TextEditingController _tomaDomiciliariaIdController;
  late TextEditingController _empleadoIdController;
  late TextEditingController _numeroDocumentoPropiedadController;
  late TextEditingController _claveCatastralController;
  late TextEditingController _fechaAsignacionController;
  late TextEditingController _verificacionIdController;
  late TextEditingController _fechaUltimaFacturaController;

  // Selected values
  String? _selectedTipoDocumentoPropiedad;
  String? _selectedEstadoGeneral;
  String? _selectedEstadoRegistro;
  String? _selectedTipoFacturacion;
  bool _cambioCliente = false;

  // Options for dropdowns
  // TODO: Cargar estas listas desde una fuente de datos real
  final List<String> _tipoDocumentoPropiedadOptions = ['Escritura Pública', 'Contrato Privado', 'Minuta', 'Otro'];
  final List<String> _estadoGeneralOptions = ['Activo', 'Inactivo', 'Pendiente'];
  final List<String> _estadoRegistroOptions = ['Vigente', 'Suspendido por Deuda', 'En Proceso de Baja', 'Baja Efectiva'];
  final List<String> _tipoFacturacionOptions = ['Residencial', 'Comercial', 'Industrial', 'Gubernamental'];

  @override
  void initState() {
    super.initState();
    final titular = widget.titularExistente;

    _idController = TextEditingController(text: titular?.id ?? ''); // Podría ser no editable si es autogenerado
    _clienteIdController = TextEditingController(text: titular?.clienteId ?? '');
    _tomaDomiciliariaIdController = TextEditingController(text: titular?.tomaDomiciliariaId ?? '');
    _empleadoIdController = TextEditingController(text: titular?.empleadoId ?? '');
    _numeroDocumentoPropiedadController = TextEditingController(text: titular?.numeroDocumentoPropiedad ?? '');
    _claveCatastralController = TextEditingController(text: titular?.claveCatastral ?? '');
    _fechaAsignacionController = TextEditingController(
        text: titular != null
            ? DateFormat('dd/MM/yyyy').format(titular.fechaAsignacion)
            : DateFormat('dd/MM/yyyy').format(DateTime.now()));
    _verificacionIdController = TextEditingController(text: titular?.verificacionId ?? '');
    _fechaUltimaFacturaController = TextEditingController(
        text: titular?.fechaUltimaFactura != null
            ? DateFormat('dd/MM/yyyy').format(titular!.fechaUltimaFactura!)
            : '');

    _selectedTipoDocumentoPropiedad = titular?.tipoDocumentoPropiedad;
    _selectedEstadoGeneral = titular?.estadoGeneral ?? _estadoGeneralOptions.first;
    _selectedEstadoRegistro = titular?.estadoRegistro ?? _estadoRegistroOptions.first;
    _selectedTipoFacturacion = titular?.tipoFacturacion ?? _tipoFacturacionOptions.first;
    _cambioCliente = titular?.cambioCliente ?? false;
  }

  @override
  void dispose() {
    _idController.dispose();
    _clienteIdController.dispose();
    _tomaDomiciliariaIdController.dispose();
    _empleadoIdController.dispose();
    _numeroDocumentoPropiedadController.dispose();
    _claveCatastralController.dispose();
    _fechaAsignacionController.dispose();
    _verificacionIdController.dispose();
    _fechaUltimaFacturaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(controller.text);
      } catch (e) {
        // Mantener la fecha inicial si el parseo falla
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _guardarTitular() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Convertir fechas de String a DateTime antes de guardar
      // TODO: Crear o actualizar el objeto TitularModel
      // TODO: Implementar lógica de guardado (API call, base de datos local, etc.)

      final String mensaje = widget.titularExistente == null
          ? 'Titular creado (simulación)'
          : 'Titular actualizado (simulación)';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
      Navigator.of(context).pop(); // Volver a la lista
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Gestión de Titulares',
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

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final String formTitle = widget.titularExistente == null
        ? 'Registrar Nuevo Titular'
        : 'Editar Titular';

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
                        'Complete la información requerida para el titular.',
                        style: AppTypography.bodyLg
                            .copyWith(color: AppTheme.textColor),
                      ),
                      const SizedBox(height: Spacing.xl),

                      // Campos del formulario
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
    return Column(
      children: [
        AppInput(
          label: 'ID Titular (TOMADOTITULAR_ID)*',
          controller: _idController,
          // readOnly: widget.titularExistente != null, // Si es autogenerado y no editable después
          validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(
                child: AppInput(
              label: 'Cliente ID (TTDM_CLIENTE_ID)*',
              controller: _clienteIdController,
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            )),
            const SizedBox(width: Spacing.md),
            Expanded(
                child: AppInput(
              label: 'Toma Domiciliaria ID (TTDM_TOMADOMICILIARIA_ID)*',
              controller: _tomaDomiciliariaIdController,
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            )),
          ],
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Empleado Asignado ID (TTDM_EMPLEADO_ID)*',
          controller: _empleadoIdController,
          validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(
                child: AppSelect<String>(
              label: 'Tipo Documento Propiedad*',
              value: _selectedTipoDocumentoPropiedad,
              options: _tipoDocumentoPropiedadOptions,
              onChanged: (v) =>
                  setState(() => _selectedTipoDocumentoPropiedad = v),
              labelBuilder: (s) => s,
              validator: (v) => v == null ? 'Campo requerido' : null,
            )),
            const SizedBox(width: Spacing.md),
            Expanded(
                child: AppInput(
              label: 'Número Documento Propiedad*',
              controller: _numeroDocumentoPropiedadController,
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            )),
          ],
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Clave Catastral (TTDM_CLAVE_CATASTRAL)*',
          controller: _claveCatastralController,
          validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Fecha de Asignación*',
          controller: _fechaAsignacionController,
          readOnly: true,
          onTap: () => _selectDate(context, _fechaAsignacionController),
          validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(
                child: AppSelect<String>(
              label: 'Estado General (ESTADO)*',
              value: _selectedEstadoGeneral,
              options: _estadoGeneralOptions,
              onChanged: (v) => setState(() => _selectedEstadoGeneral = v),
              labelBuilder: (s) => s,
              validator: (v) => v == null ? 'Campo requerido' : null,
            )),
            const SizedBox(width: Spacing.md),
            Expanded(
                child: AppSelect<String>(
              label: 'Estado Registro (TTDM_ESTADOREGISTRO)*',
              value: _selectedEstadoRegistro,
              options: _estadoRegistroOptions,
              onChanged: (v) => setState(() => _selectedEstadoRegistro = v),
              labelBuilder: (s) => s,
              validator: (v) => v == null ? 'Campo requerido' : null,
            )),
          ],
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'ID Verificación (TTDM_VERIFICACIONID)',
          controller: _verificacionIdController,
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Fecha Última Factura',
          controller: _fechaUltimaFacturaController,
          readOnly: true,
          onTap: () => _selectDate(context, _fechaUltimaFacturaController),
        ),
        const SizedBox(height: Spacing.md),
        AppSelect<String>(
          label: 'Tipo de Facturación (TTDM_TIPO_FACTURACION)*',
          value: _selectedTipoFacturacion,
          options: _tipoFacturacionOptions,
          onChanged: (v) => setState(() => _selectedTipoFacturacion = v),
          labelBuilder: (s) => s,
          validator: (v) => v == null ? 'Campo requerido' : null,
        ),
        const SizedBox(height: Spacing.md),
        SwitchListTile(
          title: Text('Indicador Cambio de Cliente',
              style: AppTypography.bodyLg
                  .copyWith(color: AppTheme.textPrimaryColor)),
          value: _cambioCliente,
          onChanged: (bool value) => setState(() => _cambioCliente = value),
          activeColor: AppTheme.primaryColor,
          contentPadding: EdgeInsets.zero,
        ),
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
          width: isMobile ? null : 120,
        ),
        const SizedBox(width: Spacing.md),
        AppButton(
          text: widget.titularExistente == null
              ? 'Crear Titular'
              : 'Actualizar Titular',
          onPressed: _guardarTitular,
          kind: AppButtonKind.primary,
          width: isMobile ? null : 180,
        ),
      ],
    );
  }
}
