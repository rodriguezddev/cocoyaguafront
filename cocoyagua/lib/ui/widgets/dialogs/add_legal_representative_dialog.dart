import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../models/legal_representative_model.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class AddLegalRepresentativeDialog extends StatefulWidget {
  final LegalRepresentative? representativeToEdit;

  const AddLegalRepresentativeDialog({super.key, this.representativeToEdit});

  static Future<LegalRepresentative?> show(BuildContext context,
      {LegalRepresentative? representativeToEdit}) {
    return showDialog<LegalRepresentative?>(
      context: context,
      builder: (context) => AddLegalRepresentativeDialog(
          representativeToEdit: representativeToEdit),
    );
  }

  @override
  State<AddLegalRepresentativeDialog> createState() =>
      _AddLegalRepresentativeDialogState();
}

class _AddLegalRepresentativeDialogState
    extends State<AddLegalRepresentativeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _documentNumberController;
  late TextEditingController _positionController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  String? _selectedDocumentType;
  final List<String> _documentTypeOptions = [
    'DNI',
    'RUC',
    'Pasaporte',
    'Carnet de Extranjería'
  ]; // Ajusta según necesidad

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.representativeToEdit?.fullName);
    _selectedDocumentType = widget.representativeToEdit?.documentType;
    _documentNumberController = TextEditingController(
        text: widget.representativeToEdit?.documentNumber);
    _positionController =
        TextEditingController(text: widget.representativeToEdit?.position);
    _phoneController =
        TextEditingController(text: widget.representativeToEdit?.phone);
    _emailController =
        TextEditingController(text: widget.representativeToEdit?.email);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _documentNumberController.dispose();
    _positionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_formKey.currentState!.validate()) {
      final newRepresentative = LegalRepresentative(
        id: widget.representativeToEdit?.id ?? const Uuid().v4(),
        fullName: _fullNameController.text,
        documentType: _selectedDocumentType!,
        documentNumber: _documentNumberController.text,
        position: _positionController.text,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
      );
      Navigator.of(context).pop(newRepresentative);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.representativeToEdit == null
              ? 'Agregar Representante Legal'
              : 'Editar Representante Legal',
          style: AppTypography.h2),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInput(
                  label: 'Nombre completo*',
                  controller: _fullNameController,
                  hintText: 'Ingresar nombre completo',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: Spacing.md),
              AppSelect<String>(
                  label: 'Tipo de Documento*',
                  value: _selectedDocumentType,
                  options: _documentTypeOptions,
                  labelBuilder: (v) => v,
                  onChanged: (val) =>
                      setState(() => _selectedDocumentType = val),
                  hint: const Text('Seleccionar'),
                  validator: (v) => v == null ? 'Campo requerido' : null),
              const SizedBox(height: Spacing.md),
              AppInput(
                  label: 'Número de Documento*',
                  controller: _documentNumberController,
                  hintText: 'Ingresar número',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: Spacing.md),
              AppInput(
                  label: 'Cargo o Posición*',
                  controller: _positionController,
                  hintText: 'Ej: Gerente General',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null),
              const SizedBox(height: Spacing.md),
              AppInput(
                  label: 'Teléfono (Opcional)',
                  controller: _phoneController,
                  hintText: 'Ingresar teléfono',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: Spacing.md),
              AppInput(
                  label: 'Correo electrónico (Opcional)',
                  controller: _emailController,
                  hintText: 'Ingresar correo',
                  keyboardType: TextInputType.emailAddress),
            ],
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
