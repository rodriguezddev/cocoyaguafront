import '../../../models/lectura_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';

class LecturaFormView extends StatefulWidget {
  final Lectura? lecturaToEdit;

  const LecturaFormView({super.key, this.lecturaToEdit});

  @override
  State<LecturaFormView> createState() => _LecturaFormViewState();
}

class _LecturaFormViewState extends State<LecturaFormView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _lecturaIdController;
  late TextEditingController _fechaLecturaController;
  late TextEditingController _lecturaAnteriorController;
  late TextEditingController _lecturaActualController;
  late TextEditingController _lecturaInicioController;
  late TextEditingController _consumoController; // Solo para mostrar
  late TextEditingController _observacionesController;

  DateTime? _selectedDate;
  String? _selectedMedidorId;
  UnidadMedida _selectedUnidadMedida = UnidadMedida.m3;
  String? _selectedProductoId;
  String? _selectedEmpleadoId;
  EstadoLectura _selectedEstadoLectura = EstadoLectura.pendiente;

  // Mock data for selectors - replace with actual data fetching
  final List<String> _medidorOptions = ['MED001', 'MED002', 'MED003', 'MED004'];
  final List<String> _empleadoOptions = [
    'EMP001-Juan',
    'EMP002-Ana',
    'EMP003-Luis'
  ];
  final List<String> _productoOptions = ['AGUA_POTABLE', 'ALCANTARILLADO'];
  final List<UnidadMedida> _unidadMedidaOptions = UnidadMedida.values;
  final List<EstadoLectura> _estadoLecturaOptions = EstadoLectura.values;

  @override
  void initState() {
    super.initState();

    _lecturaIdController = TextEditingController(
        text: widget.lecturaToEdit?.lecturaId ?? ''); // Podría ser autogenerado
    _selectedDate = widget.lecturaToEdit?.fechaLectura ?? DateTime.now();
    _fechaLecturaController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(_selectedDate!));
    _selectedMedidorId = widget.lecturaToEdit?.medidorId;

    _lecturaAnteriorController = TextEditingController(
        text: widget.lecturaToEdit?.lecturaAnterior.toString() ?? '0.0');
    _lecturaActualController = TextEditingController(
        text: widget.lecturaToEdit?.lecturaActual.toString() ?? '0.0');

    _lecturaInicioController = TextEditingController(
        text: widget.lecturaToEdit?.lecturaInicio?.toString() ?? '');
    _selectedUnidadMedida =
        widget.lecturaToEdit?.unidadMedida ?? UnidadMedida.m3;
    _selectedProductoId = widget.lecturaToEdit?.productoId;

    final String? initialEmpleadoCode = widget.lecturaToEdit?.empleadoId;
    if (initialEmpleadoCode != null && initialEmpleadoCode.isNotEmpty) {
      _selectedEmpleadoId = _empleadoOptions.firstWhere(
        (option) => option.startsWith("$initialEmpleadoCode-"),
        orElse: () => '', 
      );
    } else {
      _selectedEmpleadoId = null;
    }

    _selectedEstadoLectura =
        widget.lecturaToEdit?.estadoLectura ?? EstadoLectura.pendiente;
    _observacionesController =
        TextEditingController(text: widget.lecturaToEdit?.observaciones ?? '');

    _consumoController = TextEditingController();
    _calculateAndSetConsumo();

    _lecturaAnteriorController.addListener(_calculateAndSetConsumo);
    _lecturaActualController.addListener(_calculateAndSetConsumo);
  }

  void _calculateAndSetConsumo() {
    final anterior = double.tryParse(_lecturaAnteriorController.text) ?? 0.0;
    final actual = double.tryParse(_lecturaActualController.text) ?? 0.0;
    final consumo = (actual - anterior) < 0 ? 0.0 : (actual - anterior);
    _consumoController.text = consumo.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _lecturaIdController.dispose();
    _fechaLecturaController.dispose();
    _lecturaAnteriorController.removeListener(_calculateAndSetConsumo);
    _lecturaAnteriorController.dispose();
    _lecturaActualController.removeListener(_calculateAndSetConsumo);
    _lecturaActualController.dispose();
    _lecturaInicioController.dispose();
    _consumoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fechaLecturaController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _saveLectura() {
    if (_formKey.currentState!.validate()) {
      // Lógica para guardar la lectura (nueva o actualizada)
      // Esto implicaría llamar a un servicio o provider

      // Extraer solo el código del empleado si _selectedEmpleadoId tiene el formato "CODIGO-Nombre"
      String empleadoIdToSave;
      if (_selectedEmpleadoId != null && _selectedEmpleadoId!.contains('-')) {
        empleadoIdToSave = _selectedEmpleadoId!.split('-')[0];
      } else {
        empleadoIdToSave = _selectedEmpleadoId!; // Asume que es el ID o null (manejado por validador)
      }

      final lectura = Lectura(
        lecturaId: _lecturaIdController.text.isNotEmpty
            ? _lecturaIdController.text
            : null, // Permite autogeneración si está vacío
        fechaLectura: _selectedDate!,
        medidorId: _selectedMedidorId!,
        lecturaAnterior: double.parse(_lecturaAnteriorController.text),
        lecturaActual: double.parse(_lecturaActualController.text),
        lecturaInicio: _lecturaInicioController.text.isNotEmpty
            ? double.parse(_lecturaInicioController.text)
            : null,
        unidadMedida: _selectedUnidadMedida,
        productoId: _selectedProductoId,
        empleadoId: empleadoIdToSave,
        estadoLectura: _selectedEstadoLectura,
        observaciones: _observacionesController.text,
      );
      print('Guardando lectura: ${lectura.lecturaId}');
      Navigator.of(context).pop(true); // Indicar que se guardó
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            widget.lecturaToEdit == null
                ? 'Registrar Lectura'
                : 'Editar Lectura',
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        // Puedes agregar aquí info del usuario si es necesario, como en PersonasView
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final title = widget.lecturaToEdit == null
        ? 'Registrar Nueva Lectura'
        : 'Editar Lectura';

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
                      Text(title,
                          style: AppTypography.h2
                              .copyWith(color: AppTheme.textPrimaryColor)),
                      const SizedBox(height: Spacing.md),
                      AppInput(
                          label: 'ID Lectura (Opcional)',
                          controller: _lecturaIdController,
                          hintText: 'Se autogenerará si se deja vacío'),
                      const SizedBox(height: Spacing.md),
                      AppInput(
                        label: 'Fecha de Lectura*',
                        controller: _fechaLecturaController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AppSelect<String>(
                        label: 'Medidor ID*',
                        value: _selectedMedidorId,
                        options: _medidorOptions,
                        labelBuilder: (v) => v,
                        onChanged: (val) =>
                            setState(() => _selectedMedidorId = val),
                        validator: (v) => v == null ? 'Campo requerido' : null,
                        hint: const Text('Seleccionar medidor'),
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          Expanded(
                              child: AppInput(
                                  label: 'Lectura Anterior*',
                                  controller: _lecturaAnteriorController,
                                  keyboardType: TextInputType.number,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Campo requerido'
                                      : null)),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                              child: AppInput(
                                  label: 'Lectura Actual*',
                                  controller: _lecturaActualController,
                                  keyboardType: TextInputType.number,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Campo requerido'
                                      : null)),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          Expanded(
                              child: AppInput(
                                  label: 'Lectura Inicio (Opcional)',
                                  controller: _lecturaInicioController,
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                              child: AppInput(
                                  label: 'Consumo',
                                  controller: _consumoController,
                                  readOnly: true,
                                  hintText: 'Calculado')),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      AppSelect<UnidadMedida>(
                        label: 'Unidad de Medida*',
                        value: _selectedUnidadMedida,
                        options: _unidadMedidaOptions,
                        labelBuilder: (v) => unidadMedidaToString(v),
                        onChanged: (val) =>
                            setState(() => _selectedUnidadMedida = val!),
                        validator: (v) => v == null ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AppSelect<String>(
                        label: 'Producto ID (Opcional)',
                        value: _selectedProductoId,
                        options: _productoOptions,
                        labelBuilder: (v) => v,
                        onChanged: (val) =>
                            setState(() => _selectedProductoId = val),
                        hint: const Text('Seleccionar producto'),
                      ),
                      const SizedBox(height: Spacing.md),
                      AppSelect<String>(
                        label: 'Empleado ID*',
                        value: _selectedEmpleadoId,
                        options: _empleadoOptions,
                        labelBuilder: (v) => v,
                        onChanged: (val) =>
                            setState(() => _selectedEmpleadoId = val),
                        validator: (v) => v == null ? 'Campo requerido' : null,
                        hint: const Text('Seleccionar empleado'),
                      ),
                      const SizedBox(height: Spacing.md),
                      AppSelect<EstadoLectura>(
                        label: 'Estado de Lectura*',
                        value: _selectedEstadoLectura,
                        options: _estadoLecturaOptions,
                        labelBuilder: (v) => estadoLecturaToString(v),
                        onChanged: (val) =>
                            setState(() => _selectedEstadoLectura = val!),
                        validator: (v) => v == null ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AppInput(
                          label: 'Observaciones (Opcional)',
                          controller: _observacionesController,
                          maxLines: 3),
                      const SizedBox(height: Spacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: const Text('Cancelar'),
    ),
                          const SizedBox(width: Spacing.md),
                          AppButton(
                              text: 'Guardar Lectura', onPressed: _saveLectura),
                        ],
                      ),
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
