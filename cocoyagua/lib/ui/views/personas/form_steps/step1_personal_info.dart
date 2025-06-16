import 'package:flutter/material.dart';
import '../../../components/inputs/app_input.dart';
import '../../../components/inputs/app_select.dart';
import '../../../components/shared/responsive.dart';
import '../../../theme/spacing.dart';
import '../personas_view.dart' show RolPersona, rolPersonaToString; // Importar para roles

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
  // Controladores para Persona Jurídica
  final TextEditingController nombreOrganizacionController;
  final TextEditingController fechaFundacionController;
  final TextEditingController representanteController;
  // Para Roles
  final Set<RolPersona> selectedRoles;
  final Function(RolPersona, bool) onRoleSelected;


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
    required this.nombreOrganizacionController,
    required this.fechaFundacionController,
    required this.representanteController,
    required this.selectedRoles,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> formFieldsColumn1 = [];
    List<Widget> formFieldsColumn2 = [];

    // Campo común: Tipo de persona (siempre visible al inicio de la columna 1)
    formFieldsColumn1.add(
      AppSelect<String>(
        label: 'Tipo de persona*',
        value: selectedPersonType,
        options: personTypeOptions,
        labelBuilder: (v) => v,
        onChanged: onPersonTypeChanged,
        hint: const Text('Seleccionar'),
        validator: (v) => v == null ? 'Campo requerido' : null,
      ),
    );
    formFieldsColumn1.add(const SizedBox(height: Spacing.md));

    // Campo común: Tipo de documento (siempre visible al inicio de la columna 2)
     formFieldsColumn2.add(
      AppSelect<String>(
        label: 'Tipo de documento*',
        value: selectedDocumentType,
        options: documentTypeOptions, // Usar las opciones generales, o específicas si cambian
        labelBuilder: (v) => v,
        onChanged: onDocumentTypeChanged,
        hint: const Text('Seleccionar'),
        validator: (v) => v == null ? 'Campo requerido' : null,
      ),
    );
    formFieldsColumn2.add(const SizedBox(height: Spacing.md));
    formFieldsColumn2.add(
      AppInput(
        label: 'Número de documento*',
        hintText: 'Ingresar documento',
        controller: numeroDocumentoController, // Reutilizado
        keyboardType: TextInputType.number,
        validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
      ),
    );
    formFieldsColumn2.add(const SizedBox(height: Spacing.md));


    if (selectedPersonType == 'Natural') {
      formFieldsColumn1.addAll([
        AppInput(
            label: 'Primer nombre*',
            hintText: 'Ingresar primer nombre',
            controller: primerNombreController,
            validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null),
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
      ]);

      formFieldsColumn2.addAll([
        AppInput(
            label: 'Primer apellido*',
            hintText: 'Ingresar primer apellido',
            controller: primerApellidoController,
            validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null),
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
      ]);
    } else if (selectedPersonType == 'Jurídica') {
      formFieldsColumn1.addAll([
        AppInput(
            label: 'Nombre de la Organización*',
            hintText: 'Ingresar nombre',
            controller: nombreOrganizacionController,
            validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null),
        const SizedBox(height: Spacing.md),
        AppInput(
            label: 'Fecha de Fundación',
            hintText: 'DD/MM/AAAA',
            controller: fechaFundacionController,
            keyboardType: TextInputType.datetime),
      ]);
      formFieldsColumn2.addAll([
         AppInput( // Este campo ya está arriba, se podría quitar de aquí si se decide que el Nro Doc es siempre el segundo en Col2
            label: 'Representante (ID o Nombre)', // Simplificado por ahora
            hintText: 'Ingresar datos del representante',
            controller: representanteController),
      ]);
    }
    
    // Sección de Roles (común a ambos tipos de persona)
    // Se podría colocar en una columna específica o al final de una de ellas.
    // Por ahora, la añadiré al final de la primera columna.
    formFieldsColumn1.add(const SizedBox(height: Spacing.md));
    formFieldsColumn1.add(const Text("Roles de la Persona:", style: TextStyle(fontWeight: FontWeight.bold)));
    formFieldsColumn1.add(const SizedBox(height: Spacing.sm));

    for (var rol in RolPersona.values) {
      formFieldsColumn1.add(
        CheckboxListTile(
          title: Text(rolPersonaToString(rol)),
          value: selectedRoles.contains(rol),
          onChanged: (bool? value) {
            onRoleSelected(rol, value ?? false);
          },
        ),
      );
    }

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
