// lib/ui/views/tomas_domiciliarias/form_steps/step1_datos_generales_toma.dart
import 'package:flutter/material.dart';
import '../../../components/inputs/app_input.dart';
import '../../../components/inputs/app_select.dart';
import '../../../theme/spacing.dart';

class Step1DatosGeneralesToma extends StatelessWidget {
  final bool isMobile;
  final TextEditingController documentoImpresoIdController;
  final TextEditingController empleadoController;
  final TextEditingController fechaRegistroController;
  final TextEditingController idaController;
  final TextEditingController tomaDomiciliariaIdController;
  final String? selectedEstado;
  final List<String> estadoOptions;
  final ValueChanged<String?> onEstadoChanged;
  final String? selectedUsoSuministro;
  final List<String> usoSuministroOptions;
  final ValueChanged<String?> onUsoSuministroChanged;

  const Step1DatosGeneralesToma({
    super.key,
    required this.isMobile,
    required this.documentoImpresoIdController,
    required this.empleadoController,
    required this.fechaRegistroController,
    required this.idaController,
    required this.tomaDomiciliariaIdController,
    this.selectedEstado,
    required this.estadoOptions,
    required this.onEstadoChanged,
    this.selectedUsoSuministro,
    required this.usoSuministroOptions,
    required this.onUsoSuministroChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Formatear la fecha como YYYY-MM-DD
      fechaRegistroController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.lg),
        if (isMobile)
          _buildMobileLayout(context)
        else
          _buildDesktopLayout(context),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppInput(
                label: 'Documento Impreso ID',
                controller: documentoImpresoIdController,
                hintText: 'Ej: DOC-001',
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: AppInput(
                label: 'Empleado Asignado',
                controller: empleadoController,
                hintText: 'Nombre del empleado',
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(
              child: AppInput(
                label: 'Fecha de Registro',
                controller: fechaRegistroController,
                hintText: 'YYYY-MM-DD',
                readOnly: true,
                onTap: () => _selectDate(context),
                icon: Icons.calendar_today,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: AppInput(
                label: 'IDA (Identificador de Abonado)',
                controller: idaController,
                hintText: 'Ej: IDA-001',
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(
              child: AppInput(
                label: 'Toma Domiciliaria ID',
                controller: tomaDomiciliariaIdController,
                hintText: 'Ej: TOMA-001',
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: AppSelect<String>(
                label: 'Estado de la Toma',
                value: selectedEstado,
                options: estadoOptions,
                onChanged: onEstadoChanged,
                labelBuilder: (value) => value,
                // hintText: 'Seleccione un estado',
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        AppSelect<String>(
          label: 'Uso de Suministro',
          value: selectedUsoSuministro,
          options: usoSuministroOptions,
          onChanged: onUsoSuministroChanged,
          labelBuilder: (value) => value,
          // hintText: 'Seleccione el uso',
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        AppInput(
          label: 'Documento Impreso ID',
          controller: documentoImpresoIdController,
          hintText: 'Ej: DOC-001',
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Empleado Asignado',
          controller: empleadoController,
          hintText: 'Nombre del empleado',
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Fecha de Registro',
          controller: fechaRegistroController,
          hintText: 'YYYY-MM-DD',
          readOnly: true,
          onTap: () => _selectDate(context),
          icon: Icons.calendar_today,
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'IDA (Identificador de Abonado)',
          controller: idaController,
          hintText: 'Ej: IDA-001',
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Toma Domiciliaria ID',
          controller: tomaDomiciliariaIdController,
          hintText: 'Ej: TOMA-001',
        ),
        const SizedBox(height: Spacing.md),
        AppSelect<String>(
          label: 'Estado de la Toma',
          value: selectedEstado,
          options: estadoOptions,
          onChanged: onEstadoChanged,
          labelBuilder: (value) => value,
          // hintText: 'Seleccione un estado',
        ),
        const SizedBox(height: Spacing.md),
        AppSelect<String>(
          label: 'Uso de Suministro',
          value: selectedUsoSuministro,
          options: usoSuministroOptions,
          onChanged: onUsoSuministroChanged,
          labelBuilder: (value) => value,
          // hintText: 'Seleccione el uso',
        ),
      ],
    );
  }
}

