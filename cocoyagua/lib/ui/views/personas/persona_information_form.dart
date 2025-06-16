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
import 'personas_view.dart' show RolPersona, rolPersonaToString; // Importar RolPersona y helper

class PersonInformationForm extends StatefulWidget {
  final String tipoDocumento;
  final String numeroDocumento;
  final String? initialPersonType;
  // Campos para Persona Jurídica
  final String? initialNombreOrganizacion;
  final String? initialFechaFundacion; // Formato 'DD/MM/AAAA' o DateTime
  final String? initialRepresentante; // ID o nombre
  final List<RolPersona>? initialRoles;

  const PersonInformationForm(
      {super.key,
      required this.tipoDocumento,
      required this.numeroDocumento,
      this.initialPersonType,
      this.initialNombreOrganizacion,
      this.initialFechaFundacion,
      this.initialRepresentante,
      this.initialRoles,
      });

  bool get isJuridicaInitial => initialPersonType == 'Jurídica';

  @override
  State<PersonInformationForm> createState() => _PersonInformationFormState();
}

class _PersonInformationFormState extends State<PersonInformationForm> {
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
  // Controladores para Persona Jurídica
  final _nombreOrganizacionController = TextEditingController();
  final _fechaFundacionController = TextEditingController();
  final _representanteController = TextEditingController(); // Para el ID o nombre del representante


  // Selected values for Dropdowns
  String? _selectedPersonType;
  String? _selectedGender;
  String? _selectedDocumentType;
  String? _selectedProfession;
  Set<RolPersona> _selectedRoles = {}; // Para almacenar los roles seleccionados

  List<Address> _addresses = []; // Lista para almacenar direcciones
  List<Contact> _additionalContacts = []; // Lista para contactos adicionales
  List<LegalRepresentative> _legalRepresentatives =
      []; // Lista para representantes legales

  // Options for dropdowns
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
  final List<String> _countryOptions = [
    'Perú',
    'Colombia',
    'Chile',
    'Argentina',
    'Otro'
  ];
  final List<String> _departmentOptions = [
    'Lima',
    'Arequipa',
    'Cusco',
    'Otro'
  ]; // Placeholder

  @override
  void initState() {
    super.initState();
    _selectedDocumentType = widget.tipoDocumento;
    _numeroDocumentoController.text = widget.numeroDocumento;
    _selectedPersonType = widget.initialPersonType; // Usar el tipo de persona inicial

    if (widget.isJuridicaInitial) {
      _nombreOrganizacionController.text = widget.initialNombreOrganizacion ?? '';
      _fechaFundacionController.text = widget.initialFechaFundacion ?? '';
      _representanteController.text = widget.initialRepresentante ?? '';
    }

    if (widget.initialRoles != null) {
      _selectedRoles = widget.initialRoles!.toSet();
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
    _nombreOrganizacionController.dispose();
    _fechaFundacionController.dispose();
    _representanteController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Personas',
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

  // --- Lógica para Contactos Adicionales ---
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
              _additionalContacts.length == 1 && contact.isEmergencyContact) {
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
  // --- Fin Lógica para Contactos Adicionales ---

  // --- Lógica para Representantes Legales ---
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
  // --- Fin Lógica para Representantes Legales ---

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
                leading: BackButton( // Siempre visible
                    color: AppTheme.textPrimaryColor, // Color consistente con otras vistas
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
                                'Completar informacion de personas',
                                style: AppTypography.h2
                                    .copyWith(color: AppTheme.textPrimaryColor),
                              ),
                              const SizedBox(height: Spacing.sm),
                              Text(
                                'La información ingresada no se encuentra en la base de datos.',
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
          // Pasar controladores de persona jurídica
          nombreOrganizacionController: _nombreOrganizacionController,
          fechaFundacionController: _fechaFundacionController,
          representanteController: _representanteController,
          // Pasar roles y callback
          selectedRoles: _selectedRoles,
          onRoleSelected: (RolPersona rol, bool isSelected) {
            setState(() {
              isSelected ? _selectedRoles.add(rol) : _selectedRoles.remove(rol);
            });
          },
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
    // añadir validaciones antes de pasar al siguiente paso
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      print('Finalizar formulario');
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
              text: _currentStep == 4 ? 'Finalizar' : 'Continuar',
              onPressed: _nextStep,
            ),
          ),
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
        child: Text(_currentStep == 4 ? 'Finalizar' : 'Continuar'),
      );

      List<Widget> webButtons = [];
      if (_currentStep > 1) {
        webButtons.add(backButton);
        webButtons.add(const SizedBox(width: Spacing.md));
      }

      if (_currentStep == 1) {
        webButtons.add(cancelButton);
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
