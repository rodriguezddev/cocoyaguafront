import 'package:flutter/material.dart';
import '../../../../models/contact_model.dart';
import '../../../components/shared/responsive.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';
import '../../../theme/typography.dart';
import '../../../widgets/dialogs/add_contact_dialog.dart';
import '../../../widgets/list_items/contact_list_item.dart';

class Step3ContactsInfo extends StatelessWidget {
  final bool isMobile;
  final List<Contact> additionalContacts;
  final Function(Contact, {Contact? oldContact}) onAddOrUpdateContact;
  final Function(Contact) onDeleteContact;
  final Function(Contact, bool) onSetEmergencyContact;

  const Step3ContactsInfo({
    super.key,
    required this.isMobile,
    required this.additionalContacts,
    required this.onAddOrUpdateContact,
    required this.onDeleteContact,
    required this.onSetEmergencyContact,
  });

  @override
  Widget build(BuildContext context) {
    final phoneContacts = additionalContacts.where((c) {
      final typeLower = c.type?.toLowerCase();
      if (typeLower == null) return false;
      return typeLower.contains('teléfono') || typeLower.contains('telefono') || typeLower.contains('phone');
    }).toList();
    final emailContacts = additionalContacts.where((c) {
      final typeLower = c.type?.toLowerCase();
      if (typeLower == null) return false;
      return typeLower.contains('correo') || typeLower.contains('email');
    }).toList();

    Widget buildContactList(List<Contact> contacts, String contactTypeForDialog) {
      return isMobile
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ContactListItem(
                  contact: contact,
                  onEdit: () async {
                    final updatedContact = await AddContactDialog.show(context, contactToEdit: contact, contactType: contactTypeForDialog);
                    if (updatedContact != null) {
                      onAddOrUpdateContact(updatedContact, oldContact: contact);
                    }
                  },
                  onDelete: () => onDeleteContact(contact),
                  onSetEmergency: (isEmergency) => onSetEmergencyContact(contact, isEmergency),
                );
              },
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contacts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 210, // Ajusta según el alto de tu ContactListItem
                mainAxisSpacing: Spacing.md,
                crossAxisSpacing: Spacing.md,
              ),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ContactListItem(
                  contact: contact,
                  onEdit: () async {
                    final updatedContact = await AddContactDialog.show(context, contactToEdit: contact, contactType: contactTypeForDialog);
                    if (updatedContact != null) {
                      onAddOrUpdateContact(updatedContact, oldContact: contact);
                    }
                  },
                  onDelete: () => onDeleteContact(contact),
                  onSetEmergency: (isEmergency) => onSetEmergencyContact(contact, isEmergency),
                );
              },
            );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.lg),
        // --- Sección Números de Teléfono ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Números de Teléfono', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
            TextButton.icon(
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Agregar nuevo número'),
              onPressed: () async {
                final newContact = await AddContactDialog.show(context, contactType: 'Teléfono');
                if (newContact != null) {
                  onAddOrUpdateContact(newContact);
                }
              },
            )
          ],
        ),
        const SizedBox(height: Spacing.md),
        phoneContacts.isEmpty ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: Spacing.lg), child: Text('No hay números de teléfono agregados.', style: AppTypography.body.copyWith(fontStyle: FontStyle.italic)))) : buildContactList(phoneContacts, 'Teléfono'),
        const SizedBox(height: Spacing.xl),
        // --- Sección Correos Electrónicos ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Correos Electrónicos', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
            TextButton.icon(
              icon: const Icon(Icons.alternate_email_outlined),
              label: const Text('Agregar nuevo correo'),
              onPressed: () async {
                final newContact = await AddContactDialog.show(context, contactType: 'Correo');
                if (newContact != null) {
                  onAddOrUpdateContact(newContact);
                }
              },
            )
          ],
        ),
        const SizedBox(height: Spacing.md),
        emailContacts.isEmpty ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: Spacing.lg), child: Text('No hay correos electrónicos agregados.', style: AppTypography.body.copyWith(fontStyle: FontStyle.italic)))) : buildContactList(emailContacts, 'Correo'),
        const SizedBox(height: Spacing.lg),
      ],
    );
  }
}