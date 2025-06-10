// lib/ui/views/tomas_domiciliarias/form_steps/step2_ubicacion_toma.dart
import 'package:flutter/material.dart';
import '../../../components/inputs/app_input.dart';
import '../../../components/inputs/app_select.dart';
import '../../../theme/spacing.dart';

class Step2UbicacionToma extends StatelessWidget {
  final bool isMobile;
  final String? selectedDepartamento;
  final List<String> departamentoOptions;
  final ValueChanged<String?> onDepartamentoChanged;
  final String? selectedMunicipio;
  final List<String> municipioOptions;
  final ValueChanged<String?> onMunicipioChanged;
  final TextEditingController localidad1Controller;
  final TextEditingController localidad2Controller;
  final TextEditingController localidad3Controller;
  final TextEditingController claveCatastralController;
  final TextEditingController coordenadasController;

  const Step2UbicacionToma({
    super.key,
    required this.isMobile,
    this.selectedDepartamento,
    required this.departamentoOptions,
    required this.onDepartamentoChanged,
    this.selectedMunicipio,
    required this.municipioOptions,
    required this.onMunicipioChanged,
    required this.localidad1Controller,
    required this.localidad2Controller,
    required this.localidad3Controller,
    required this.claveCatastralController,
    required this.coordenadasController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.lg),
        if (isMobile) _buildMobileLayout() else _buildDesktopLayout(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppSelect<String>(
                label: 'Departamento',
                value: selectedDepartamento,
                options: departamentoOptions,
                onChanged: onDepartamentoChanged,
                labelBuilder: (value) => value,
                 // hintText: 'Seleccione departamento',
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: AppSelect<String>(
                label: 'Municipio',
                value: selectedMunicipio,
                options:
                    municipioOptions, // Esta lista se actualiza dinámicamente
                onChanged: onMunicipioChanged,
                labelBuilder: (value) => value,
                // hintText: 'Seleccione municipio',
                //disabled: selectedDepartamento ==
                //    null, // Deshabilitar si no hay departamento
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Localidad / Barrio / Colonia',
          controller: localidad1Controller,
          hintText: 'Escriba la localidad principal',
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(
              child: AppInput(
                label: 'Localidad 2 (Opcional)',
                controller: localidad2Controller,
                hintText: 'Escriba otra localidad',
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: AppInput(
                label: 'Localidad 3 (Opcional)',
                controller: localidad3Controller,
                hintText: 'Escriba otra localidad',
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(
              child: AppInput(
                label: 'Clave Catastral',
                controller: claveCatastralController,
                hintText: 'Ej: 0101-001-00203',
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: AppInput(
                label: 'Coordenadas (Lat, Lon)',
                controller: coordenadasController,
                hintText: 'Ej: 15.7833, -86.7833',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        AppSelect<String>(
          label: 'Departamento',
          value: selectedDepartamento,
          options: departamentoOptions,
          onChanged: onDepartamentoChanged,
          labelBuilder: (value) => value,
          // hintText: 'Seleccione departamento',
        ),
        const SizedBox(height: Spacing.md),
        AppSelect<String>(
          label: 'Municipio',
          value: selectedMunicipio,
          options: municipioOptions,
          onChanged: onMunicipioChanged,
          labelBuilder: (value) => value,
          // hintText: 'Seleccione municipio',
          // disabled: selectedDepartamento == null,
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Localidad / Barrio / Colonia',
          controller: localidad1Controller,
          hintText: 'Escriba la localidad principal',
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Localidad 2 (Opcional)',
          controller: localidad2Controller,
          hintText: 'Escriba otra localidad',
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Localidad 3 (Opcional)',
          controller: localidad3Controller,
          hintText: 'Escriba otra localidad',
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Clave Catastral',
          controller: claveCatastralController,
          hintText: 'Ej: 0101-001-00203',
        ),
        const SizedBox(height: Spacing.md),
        AppInput(
          label: 'Coordenadas (Lat, Lon)',
          controller: coordenadasController,
          hintText: 'Ej: 15.7833, -86.7833',
        ),
      ],
    );
  }
}
