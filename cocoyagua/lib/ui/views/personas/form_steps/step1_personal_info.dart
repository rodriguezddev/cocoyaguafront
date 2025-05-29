import 'package:flutter/material.dart';
import '../../../components/inputs/app_input.dart';
import '../../../components/inputs/app_select.dart';
import '../../../components/shared/responsive.dart';
import '../../../theme/spacing.dart';

class Step1PersonalInfo extends StatelessWidget {
  final bool isMobile;
  final String? selectedPersonType;
  final Function(String?) onPersonTypeChanged;
  final TextEditingController primerNombreController;
  final String? selectedGender;
  final Function(String?) onGenderChanged;
  final TextEditingController fechaNacimientoController;
  final String? selectedProfession;
  final Function(String?) onProfessionChanged;
  final TextEditingController numeroDocumentoController;
  final TextEditingController primerApellidoController;
  final String? selectedDocumentType;
  final Function(String?) onDocumentTypeChanged;
  final TextEditingController segundoNombreController;
  final TextEditingController segundoApellidoController;

  // Options for dropdowns - can be passed or defined locally if static
  final List<String> personTypeOptions;
  final List<String> genderOptions;
  final List<String> documentTypeOptions;
  final List<String> professionOptions;

  const Step1PersonalInfo({
    super.key,
    required this.isMobile,
    required this.selectedPersonType,
    required this.onPersonTypeChanged,
    required this.primerNombreController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.fechaNacimientoController,
    required this.selectedProfession,
    required this.onProfessionChanged,
    required this.numeroDocumentoController,
    required this.primerApellidoController,
    required this.selectedDocumentType,
    required this.onDocumentTypeChanged,
    required this.segundoNombreController,
    required this.segundoApellidoController,
    required this.personTypeOptions,
    required this.genderOptions,
    required this.documentTypeOptions,
    required this.professionOptions,
  });

  @override
  Widget build(BuildContext context) {
    final formFieldsColumn1 = [
      AppSelect<String>(
        label: 'Tipo de persona',
        value: selectedPersonType,
        options: personTypeOptions,
        labelBuilder: (v) => v,
        onChanged: onPersonTypeChanged,
        hint: const Text('Seleccionar'),
      ),
      const SizedBox(height: Spacing.md),
      AppInput(
          label: 'Primer nombre',
          hintText: 'Ingresar primer nombre',
          controller: primerNombreController),
      const SizedBox(height: Spacing.md),
      AppSelect<String>(
        label: 'Género',
        value: selectedGender,
        options: genderOptions,
        labelBuilder: (v) => v,
        onChanged: onGenderChanged,
        hint: const Text('Seleccionar'),
      ),
      const SizedBox(height: Spacing.md),
      AppInput(
          label: 'Fecha de nacimiento',
          hintText: 'DD/MM/AAAA',
          controller: fechaNacimientoController,
          keyboardType: TextInputType.datetime),
      const SizedBox(height: Spacing.md),
      AppSelect<String>(
        label: 'Profesión u oficio',
        value: selectedProfession,
        options: professionOptions,
        labelBuilder: (v) => v,
        onChanged: onProfessionChanged,
        hint: const Text('Seleccionar'),
      ),
    ];

    final formFieldsColumn2 = [
      AppInput(
          label: 'Número de documento',
          hintText: 'Ingresar documento',
          controller: numeroDocumentoController,
          keyboardType: TextInputType.number),
      const SizedBox(height: Spacing.md),
      AppInput(
          label: 'Primer apellido',
          hintText: 'Ingresar primer apellido',
          controller: primerApellidoController),
      const SizedBox(height: Spacing.md),
      AppSelect<String>(
        label: 'Tipo de documento',
        value: selectedDocumentType,
        options: documentTypeOptions,
        labelBuilder: (v) => v,
        onChanged: onDocumentTypeChanged,
        hint: const Text('Seleccionar'),
      ),
      const SizedBox(height: Spacing.md),
      AppInput(
          label: 'Segundo nombre (Opcional)',
          hintText: 'Ingresar segundo nombre',
          controller: segundoNombreController),
      const SizedBox(height: Spacing.md),
      AppInput(
          label: 'Segundo apellido (Opcional)',
          hintText: 'Ingresar segundo apellido',
          controller: segundoApellidoController),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.lg),
        if (isMobile) ...[
          ...formFieldsColumn1,
          const SizedBox(height: Spacing.md),
          ...formFieldsColumn2,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: formFieldsColumn1)),
              const SizedBox(width: Spacing.md),
              Expanded(child: Column(children: formFieldsColumn2)),
            ],
          ),
        const SizedBox(height: Spacing.lg),
      ],
    );
  }
}
