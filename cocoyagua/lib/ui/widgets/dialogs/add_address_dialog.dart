import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../models/address_model.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../components/shared/responsive.dart'; // Asegúrate de importar Responsive

class AddAddressDialog extends StatefulWidget {
  final Address? addressToEdit; // Opcional, para editar

  const AddAddressDialog({super.key, this.addressToEdit});

  static Future<Address?> show(BuildContext context, {Address? addressToEdit}) {
    return showDialog<Address?>(
      context: context,
      builder: (context) => AddAddressDialog(addressToEdit: addressToEdit),
    );
  }

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _streetAddressController;
  late TextEditingController _referenceController;

  String? _selectedCountry;
  String? _selectedDepartment;
  String? _selectedProvince;
  String? _selectedDistrict;
  bool _isPrimary = false;

  // TODO: Reemplazar con datos reales o cargados dinámicamente
  final List<String> _countryOptions = ['Perú', 'Colombia', 'Chile'];
  final List<String> _departmentOptions = ['Lima', 'Arequipa', 'Cusco'];
  final List<String> _provinceOptions = ['Lima', 'Callao', 'Huarochirí'];
  final List<String> _districtOptions = ['Miraflores', 'Surco', 'San Isidro'];

  @override
  void initState() {
    super.initState();
    _streetAddressController =
        TextEditingController(text: widget.addressToEdit?.streetAddress);
    _referenceController =
        TextEditingController(text: widget.addressToEdit?.reference);
    _selectedCountry = widget.addressToEdit?.country;
    _selectedDepartment = widget.addressToEdit?.department;
    _selectedProvince = widget.addressToEdit?.province;
    _selectedDistrict = widget.addressToEdit?.district;
    _isPrimary = widget.addressToEdit?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _streetAddressController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_formKey.currentState!.validate()) {
      final newAddress = Address(
        id: widget.addressToEdit?.id ??
            const Uuid().v4(), // Reusa ID si edita, o genera nuevo
        country: _selectedCountry!,
        department: _selectedDepartment!,
        province: _selectedProvince!,
        district: _selectedDistrict!,
        streetAddress: _streetAddressController.text,
        reference: _referenceController.text.isNotEmpty
            ? _referenceController.text
            : null,
        isPrimary: _isPrimary,
      );
      Navigator.of(context).pop(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    // Define los campos para la primera columna
    final formFieldsColumn1 = [
      AppSelect<String>(
          label: 'País*',
          value: _selectedCountry,
          options: _countryOptions,
          labelBuilder: (v) => v,
          onChanged: (val) => setState(() => _selectedCountry = val),
          hint: const Text('Seleccionar'),
          validator: (v) => v == null ? 'Campo requerido' : null),
      const SizedBox(height: Spacing.md),
      AppSelect<String>(
          label: 'Provincia*',
          value: _selectedProvince,
          options: _provinceOptions,
          labelBuilder: (v) => v,
          onChanged: (val) => setState(() => _selectedProvince = val),
          hint: const Text('Seleccionar'),
          validator: (v) => v == null ? 'Campo requerido' : null),
      const SizedBox(height: Spacing.md),
      AppInput(
          label: 'Dirección*',
          controller: _streetAddressController,
          hintText: 'Ej: Av. Principal 123',
          validator: (v) =>
              v == null || v.isEmpty ? 'Campo requerido' : null),
    ];

    // Define los campos para la segunda columna
    final formFieldsColumn2 = [
      AppSelect<String>(
          label: 'Departamento*',
          value: _selectedDepartment,
          options: _departmentOptions,
          labelBuilder: (v) => v,
          onChanged: (val) => setState(() => _selectedDepartment = val),
          hint: const Text('Seleccionar'),
          validator: (v) => v == null ? 'Campo requerido' : null),
      const SizedBox(height: Spacing.md),
      AppSelect<String>(
          label: 'Distrito*',
          value: _selectedDistrict,
          options: _districtOptions,
          labelBuilder: (v) => v,
          onChanged: (val) => setState(() => _selectedDistrict = val),
          hint: const Text('Seleccionar'),
          validator: (v) => v == null ? 'Campo requerido' : null),
      const SizedBox(height: Spacing.md),
      AppInput(
          label: 'Referencia',
          controller: _referenceController,
          hintText: 'Ej: Frente al parque'),
    ];

    return AlertDialog(
      title: Text(
          widget.addressToEdit == null
              ? 'Agregar nueva dirección'
              : 'Editar dirección',
          style: AppTypography.h2),
      content: SingleChildScrollView(
        child: SizedBox( // SizedBox para dar un ancho al contenido del diálogo si es necesario en web
          width: isMobile ? null : MediaQuery.of(context).size.width * 0.5, // Ejemplo: 50% del ancho en web
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMobile) ...[
                  ...formFieldsColumn1,
                  const SizedBox(height: Spacing.md), // Espacio entre "columnas" en móvil
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
                const SizedBox(height: Spacing.md), // Espacio antes del checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isPrimary,
                      onChanged: (bool? value) {
                        setState(() {
                          _isPrimary = value ?? false;
                        });
                      },
                    ),
                    const Text('Usar como dirección principal'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        AppButton(
          text: 'Confirmar',
          onPressed: _confirm,
        ),
      ],
    );
  }
}

// Extensión para añadir validador a AppSelect y AppInput si no lo tienen
extension CustomValidation on Widget {
  Widget addValidator(String? Function(String?)? validator) {
    if (this is AppInput) {
      final input = this as AppInput;
      // Asumiendo que AppInput puede ser modificado para aceptar un validador
      // o que se envuelve en un TextFormField si es necesario.
      // Por simplicidad, este ejemplo no modifica AppInput directamente.
      // En una implementación real, AppInput debería tener un parámetro validator.
    } else if (this is AppSelect) {
      final select = this as AppSelect;
      // Similar a AppInput, AppSelect necesitaría un parámetro validator.
    }
    // Este es un placeholder. La validación real se maneja en los constructores
    // de AppSelect y AppInput si se les añade el parámetro `validator`.
    // El `Form` widget se encargará de llamar a estos validadores.
    return this;
  }
}
