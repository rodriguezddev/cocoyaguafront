import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../models/contact_model.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
// No necesitamos AppSelect para el tipo aquí, se pasa como parámetro
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../components/shared/responsive.dart';

class AddContactDialog extends StatefulWidget {
  final Contact? contactToEdit;
  final String contactType; // 'Teléfono' o 'Correo'

  const AddContactDialog({
    super.key,
    this.contactToEdit,
    required this.contactType,
  });

  static Future<Contact?> show(
    BuildContext context, {
    Contact? contactToEdit,
    required String contactType, // Requerir el tipo de contacto
  }) {
    return showDialog<Contact?>(
      context: context,
      builder: (context) => AddContactDialog(contactToEdit: contactToEdit, contactType: contactType),
    );
  }

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _relationshipController; // O usar AppSelect
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _descriptionController;
  bool _isEmergencyContact = false;

  // Opciones para relación si usas AppSelect
  // final List<String> _relationshipOptions = ['Familiar', 'Amigo', 'Trabajo', 'Otro'];
  // String? _selectedRelationship;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contactToEdit?.name);
    _relationshipController =
        TextEditingController(text: widget.contactToEdit?.relationship);
    // _selectedRelationship = widget.contactToEdit?.relationship;
    _phoneController = TextEditingController(text: widget.contactToEdit?.phone);
    _emailController = TextEditingController(text: widget.contactToEdit?.email);
    _descriptionController =
        TextEditingController(text: widget.contactToEdit?.description);
    _isEmergencyContact = widget.contactToEdit?.isEmergencyContact ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_formKey.currentState!.validate()) {
      final newContact = Contact(
        id: widget.contactToEdit?.id ?? const Uuid().v4(),
        name: _nameController.text,
        relationship: _relationshipController.text, // o _selectedRelationship!
        type: widget.contactType, // Usar el tipo pasado al diálogo
        phone: widget.contactType == 'Teléfono' ? _phoneController.text : null,
        email: widget.contactType == 'Correo' ? _emailController.text : null,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        isEmergencyContact: _isEmergencyContact,
      );
      Navigator.of(context).pop(newContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final String title = widget.contactToEdit == null
        ? (widget.contactType == 'Teléfono' ? 'Agregar nuevo número' : 'Agregar nuevo correo')
        : (widget.contactType == 'Teléfono' ? 'Editar número' : 'Editar correo');

    // Campos comunes
    final commonFields = [
      AppInput(
        label: 'Nombre*',
        controller: _nameController,
        hintText: 'Ej: Juan Pérez',
        validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
      ),
      const SizedBox(height: Spacing.md),
      AppInput(
        label: 'Relación*',
        controller: _relationshipController,
        hintText: 'Ej: Hijo, Gerente de Ventas',
        validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
      ),
      const SizedBox(height: Spacing.md),
    ];

    // Campo específico del tipo (teléfono o correo)
    Widget typeSpecificField;
    if (widget.contactType == 'Teléfono') {
      typeSpecificField = AppInput(
        label: 'Número de Teléfono*',
        controller: _phoneController,
        hintText: 'Ej: 987654321',
        keyboardType: TextInputType.phone,
        validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
      );
    } else { // Correo
      typeSpecificField = AppInput(
        label: 'Correo Electrónico*',
        controller: _emailController,
        hintText: 'Ej: juan.perez@ejemplo.com',
        keyboardType: TextInputType.emailAddress,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Campo requerido';
          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(v)) {
            return 'Ingrese un correo válido';
          }
          return null;
        },
      );
    }

    final descriptionField = AppInput(
      label: 'Descripción (Opcional)',
      controller: _descriptionController,
      hintText: 'Información adicional sobre el contacto',
      maxLines: 3, // Permitir múltiples líneas
    );

    return AlertDialog(
      title: Text(title, style: AppTypography.h2),
      content: SingleChildScrollView(
        child: SizedBox(
          width: isMobile ? null : MediaQuery.of(context).size.width * 0.4, // Ancho del diálogo en web
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...commonFields,
                typeSpecificField,
                const SizedBox(height: Spacing.md),
                descriptionField,
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Checkbox(
                      value: _isEmergencyContact,
                      onChanged: (bool? value) {
                        setState(() {
                          _isEmergencyContact = value ?? false;
                        });
                      },
                    ),
                    const Text('Contacto de emergencia'),
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
