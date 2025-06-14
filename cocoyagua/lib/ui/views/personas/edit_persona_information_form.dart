import 'package:cocoyagua/models/address_model.dart';
import 'package:cocoyagua/models/contact_model.dart';
import 'package:cocoyagua/models/legal_representative_model.dart';
import 'package:flutter/material.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/dialogs/add_address_dialog.dart';
import '../../widgets/dialogs/add_contact_dialog.dart';
import '../../widgets/dialogs/add_legal_representative_dialog.dart';
import '../../widgets/list_items/address_list_item.dart';
import '../../widgets/list_items/contact_list_item.dart';
import '../../widgets/list_items/legal_representative_list_item.dart';
import '../../widgets/sidebar_menu.dart';
import 'form_steps/step1_personal_info.dart';
import 'form_steps/step2_addresses_info.dart';
import 'form_steps/step3_contacts_info.dart';
import 'form_steps/step4_legal_representatives_info.dart';
import 'personas_view.dart'; // Required for Persona model

class EditPersonInformationForm extends StatefulWidget {
  final Persona personaToEdit;
  // Optional fields for more complete pre-filling, if available
  final String? initialPrimerNombre;
  final String? initialSegundoNombre;
  final String? initialPrimerApellido;
  final String? initialSegundoApellido;
  final String? initialFechaNacimiento;
  final String? initialTelefono;
  final String? initialCorreo;
  final String? initialSelectedProfession;
  final List<Address>? initialAddresses;
  final List<Contact>? initialAdditionalContacts;
  final List<LegalRepresentative>? initialLegalRepresentatives;

  const EditPersonInformationForm({
    super.key,
    required this.personaToEdit,
    this.initialPrimerNombre,
    this.initialSegundoNombre,
    this.initialPrimerApellido,
    this.initialSegundoApellido,
    this.initialFechaNacimiento,
    this.initialTelefono,
    this.initialCorreo,
    this.initialSelectedProfession,
    this.initialAddresses,
    this.initialAdditionalContacts,
    this.initialLegalRepresentatives,
  });

  @override
  State<EditPersonInformationForm> createState() =>
      _EditPersonInformationFormState();
}

class _EditPersonInformationFormState extends State<EditPersonInformationForm> {
  int _currentStep = 1;

  // Controllers for TextFields
  final _numeroDocumentoController = TextEditingController();
  final _primerNombreController = TextEditingController();
  final _segundoNombreController = TextEditingController();
  final _primerApellidoController = TextEditingController();
  final _segundoApellidoController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();

  // Selected values for Dropdowns
  String? _selectedPersonType;
  String? _selectedGender;
  String? _selectedDocumentType;
  String? _selectedProfession;

  List<Address> _addresses = [];
  List<Contact> _additionalContacts = [];
  List<LegalRepresentative> _legalRepresentatives = [];

  // Options for dropdowns (same as PersonInformationForm)
  final List<String> _personTypeOptions = ['Natural', 'Jurídica'];
  final List<String> _genderOptions = ['Masculino', 'Femenino', 'Otro'];
  final List<String> _documentTypeOptions = [
    'DNI',
    'Pasaporte',
    'Carnet de Extranjería'
  ];
  final List<String> _professionOptions = [
    'Ingeniero',
    'Doctor',
    'Abogado',
    'Estudiante',
    'Otro'
  ];
   final List<String> _countryOptions = [ // Kept for consistency, though not directly used in Step1
    'Perú',
    'Colombia',
    'Chile',
    'Argentina',
    'Otro'
  ];
  final List<String> _departmentOptions = [ // Kept for consistency
    'Lima',
    'Arequipa',
    'Cusco',
    'Otro'
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill from personaToEdit (from the list)
    _selectedDocumentType = widget.personaToEdit.tipoDocumento;
    _numeroDocumentoController.text = widget.personaToEdit.nroDocumento;
    _selectedGender = widget.personaToEdit.genero;
    _selectedPersonType = widget.personaToEdit.tipoPersona;

    // Pre-fill from optional detailed initial data
    // For names, if specific initial names aren't provided, use nombreCompleto as a fallback for primerNombre.
    // A more robust solution would involve parsing nombreCompleto or having separate fields in the Persona model.
    _primerNombreController.text = widget.initialPrimerNombre ?? widget.personaToEdit.nombreCompleto;
    _segundoNombreController.text = widget.initialSegundoNombre ?? "";
    _primerApellidoController.text = widget.initialPrimerApellido ?? "";
    _segundoApellidoController.text = widget.initialSegundoApellido ?? "";
    
    _fechaNacimientoController.text = widget.initialFechaNacimiento ?? '';
    _telefonoController.text = widget.initialTelefono ?? '';
    _correoController.text = widget.initialCorreo ?? '';
    _selectedProfession = widget.initialSelectedProfession;

    _addresses = widget.initialAddresses != null ? List<Address>.from(widget.initialAddresses!) : [];
    _additionalContacts = widget.initialAdditionalContacts != null ? List<Contact>.from(widget.initialAdditionalContacts!) : [];
    _legalRepresentatives = widget.initialLegalRepresentatives != null ? List<LegalRepresentative>.from(widget.initialLegalRepresentatives!) : [];

    // Ensure primary address logic is applied if addresses are pre-filled
    if (_addresses.isNotEmpty && _addresses.where((a) => a.isPrimary).isEmpty) {
      _addresses[0] = _addresses[0].copyWith(isPrimary: true);
    }
    // Ensure emergency contact logic is applied if contacts are pre-filled
     if (_additionalContacts.isNotEmpty && _additionalContacts.where((c) => c.isEmergencyContact).isEmpty) {
      // Heuristic: mark first as emergency if none are, or based on specific logic if available
      // For now, let's not auto-mark one unless explicitly set or only one contact exists.
    }
  }

  @override
  void dispose() {
    _numeroDocumentoController.dispose();
    _primerNombreController.dispose();
    _segundoNombreController.dispose();
    _primerApellidoController.dispose();
    _segundoApellidoController.dispose();
    _fechaNacimientoController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Personas', // Main section title
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Santiago Meza Alvés',
                    style: AppTypography.bodyLg
                        .copyWith(color: AppTheme.textPrimaryColor)),
                Text('Administrador',
                    style: AppTypography.bodySm
                        .copyWith(color: AppTheme.textPrimaryColor)),
              ],
            ),
            const SizedBox(width: Spacing.md),
            const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
              radius: 20,
            ),
          ],
        ),
      ],
    );
  }

  void _addOrUpdateAddress(Address address, {Address? oldAddress}) {
    setState(() {
      if (address.isPrimary) {
        _addresses =
            _addresses.map((addr) => addr.copyWith(isPrimary: false)).toList();
      }

      if (oldAddress != null) {
        final index = _addresses.indexWhere((a) => a.id == oldAddress.id);
        if (index != -1) {
          _addresses[index] = address;
        }
      } else {
        _addresses.add(address);
        if (_addresses.where((a) => a.isPrimary).isEmpty &&
            _addresses.isNotEmpty) {
          if (address.isPrimary || _addresses.length == 1) {
            _addresses[_addresses.indexWhere((a) => a.id == address.id)] =
                address.copyWith(isPrimary: true);
          }
        }
      }
    });
  }

  void _deleteAddress(Address address) {
    setState(() {
      _addresses.removeWhere((a) => a.id == address.id);
      if (address.isPrimary &&
          _addresses.isNotEmpty &&
          _addresses.where((a) => a.isPrimary).isEmpty) {
        _addresses[0] = _addresses[0].copyWith(isPrimary: true);
      }
    });
  }

  void _setPrimaryAddress(Address address) {
    setState(() {
      _addresses = _addresses.map((addr) {
        return addr.copyWith(isPrimary: addr.id == address.id);
      }).toList();
    });
  }

  void _addOrUpdateContact(Contact contact, {Contact? oldContact}) {
    setState(() {
      if (contact.isEmergencyContact) {
        _additionalContacts = _additionalContacts
            .map((c) => c.copyWith(isEmergencyContact: false))
            .toList();
      }

      if (oldContact != null) {
        final index =
            _additionalContacts.indexWhere((c) => c.id == oldContact.id);
        if (index != -1) {
          _additionalContacts[index] = contact;
        }
      } else {
        _additionalContacts.add(contact);
        if (_additionalContacts.where((c) => c.isEmergencyContact).isEmpty &&
            _additionalContacts.isNotEmpty) {
          if (contact.isEmergencyContact ||
              (_additionalContacts.length == 1 && contact.isEmergencyContact)) { // Fixed condition
            _additionalContacts[
                    _additionalContacts.indexWhere((c) => c.id == contact.id)] =
                contact.copyWith(isEmergencyContact: true);
          }
        }
      }
    });
  }

  void _deleteContact(Contact contact) {
    setState(() {
      _additionalContacts.removeWhere((c) => c.id == contact.id);
      // Add logic to set new emergency contact if the deleted one was it
       if (contact.isEmergencyContact && _additionalContacts.isNotEmpty && _additionalContacts.where((c) => c.isEmergencyContact).isEmpty) {
        _additionalContacts[0] = _additionalContacts[0].copyWith(isEmergencyContact: true);
      }
    });
  }

  void _setEmergencyContact(Contact contact, bool isEmergency) {
    setState(() {
      _additionalContacts = _additionalContacts.map((c) {
        return c.copyWith(
            isEmergencyContact: c.id == contact.id
                ? isEmergency
                : (isEmergency ? false : c.isEmergencyContact));
      }).toList();
    });
  }

  void _addOrUpdateLegalRepresentative(LegalRepresentative representative,
      {LegalRepresentative? oldRepresentative}) {
    setState(() {
      if (oldRepresentative != null) {
        final index = _legalRepresentatives
            .indexWhere((r) => r.id == oldRepresentative.id);
        if (index != -1) {
          _legalRepresentatives[index] = representative;
        }
      } else {
        _legalRepresentatives.add(representative);
      }
    });
  }

  void _deleteLegalRepresentative(LegalRepresentative representative) {
    setState(() {
      _legalRepresentatives.removeWhere((r) => r.id == representative.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Editar Información de Persona', // Changed Title
                                style: AppTypography.h2
                                    .copyWith(color: AppTheme.textPrimaryColor),
                              ),
                              const SizedBox(height: Spacing.sm),
                              Text(
                                'Modifique los datos de la persona seleccionada.', // Changed Subtitle
                                style: AppTypography.bodyLg
                                    .copyWith(color: AppTheme.textPrimaryColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Spacing.lg),
                        _buildStepIndicatorRow(),
                      ],
                    ),
                    _buildStepContent(context, isMobile),
                    const SizedBox(height: Spacing.lg),
                    _buildActionButtons(isMobile),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, bool isMobile) {
    switch (_currentStep) {
      case 1:
        return Step1PersonalInfo(
          isMobile: isMobile,
          selectedPersonType: _selectedPersonType,
          onPersonTypeChanged: (value) =>
              setState(() => _selectedPersonType = value),
          primerNombreController: _primerNombreController,
          selectedGender: _selectedGender,
          onGenderChanged: (value) => setState(() => _selectedGender = value),
          fechaNacimientoController: _fechaNacimientoController,
          selectedProfession: _selectedProfession,
          onProfessionChanged: (value) =>
              setState(() => _selectedProfession = value),
          numeroDocumentoController: _numeroDocumentoController,
          primerApellidoController: _primerApellidoController,
          selectedDocumentType: _selectedDocumentType,
          onDocumentTypeChanged: (value) =>
              setState(() => _selectedDocumentType = value),
          segundoNombreController: _segundoNombreController,
          segundoApellidoController: _segundoApellidoController,
          personTypeOptions: _personTypeOptions,
          genderOptions: _genderOptions,
          documentTypeOptions: _documentTypeOptions,
          professionOptions: _professionOptions,
        );
      case 2:
        return Step2AddressesInfo(
          isMobile: isMobile,
          addresses: _addresses,
          onAddOrUpdateAddress: _addOrUpdateAddress,
          onDeleteAddress: _deleteAddress,
          onSetPrimaryAddress: _setPrimaryAddress,
        );
      case 3:
        return Step3ContactsInfo(
          isMobile: isMobile,
          additionalContacts: _additionalContacts,
          onAddOrUpdateContact: _addOrUpdateContact,
          onDeleteContact: _deleteContact,
          onSetEmergencyContact: _setEmergencyContact,
        );
      case 4:
        return Step4LegalRepresentativesInfo(
          isMobile: isMobile,
          selectedPersonType: _selectedPersonType,
          legalRepresentatives: _legalRepresentatives,
          onAddOrUpdateLegalRepresentative: _addOrUpdateLegalRepresentative,
          onDeleteLegalRepresentative: _deleteLegalRepresentative,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Final step: Save changes
      print('Guardar Cambios - Persona: ${_numeroDocumentoController.text}');
      // Here you would typically call an API to update the person's data
      // For now, just pop the screen as an example
      Navigator.of(context).pop(); 
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildStepIndicatorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator(1, isActive: _currentStep == 1),
        _buildStepIndicator(2, isActive: _currentStep == 2),
        _buildStepIndicator(3, isActive: _currentStep == 3),
        _buildStepIndicator(4, isActive: _currentStep == 4),
      ],
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    final String continueText = _currentStep == 4 ? 'Guardar Cambios' : 'Continuar';

    final Widget backButton = OutlinedButton(
      onPressed: _previousStep,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: const Text(' Atrás '),
    );

    final Widget cancelButton = OutlinedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: const Text('Cancelar'),
    );

    if (isMobile) {
      return Row(
        children: [
          if (_currentStep > 1) Expanded(child: backButton),
          if (_currentStep > 1) const SizedBox(width: Spacing.md),
          Expanded(
            child: AppButton(
              text: continueText,
              onPressed: _nextStep,
            ),
          ),
           // Show cancel button always on mobile if it's the first step, similar to create form
          if (_currentStep == 1) ...[
            const SizedBox(width: Spacing.md),
            Expanded(child: cancelButton),
          ],
        ],
      );
    } else {
      final Widget continueButtonWeb = ElevatedButton(
        onPressed: _nextStep,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: Text(continueText),
      );

      List<Widget> webButtons = [];
      // Always show Cancel button on web for edit form for consistency, or only on first step
      webButtons.add(cancelButton);
      webButtons.add(const SizedBox(width: Spacing.md));

      if (_currentStep > 1) {
        webButtons.add(backButton);
        webButtons.add(const SizedBox(width: Spacing.md));
      }
      
      webButtons.add(continueButtonWeb);

      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: webButtons,
      );
    }
  }

  Widget _buildStepIndicator(int step, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}