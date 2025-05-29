import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool) onSetEmergency; // Para marcar/desmarcar como emergencia

  const ContactListItem({
    super.key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    required this.onSetEmergency,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    contact.name,
                    style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: AppTheme.textColor.withOpacity(0.7)),
                      onPressed: onEdit,
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.7)),
                      onPressed: onDelete,
                      tooltip: 'Eliminar',
                    ),
                  ],
                )
              ],
            ),
            Text(contact.relationship, style: AppTypography.body.copyWith(color: AppTheme.textColor.withOpacity(0.8))),
            const SizedBox(height: Spacing.xs),
            Text(contact.phone ?? '', style: AppTypography.body),
            if (contact.email != null && contact.email!.isNotEmpty) ...[
              const SizedBox(height: Spacing.xs),
              Text(contact.email!, style: AppTypography.body),
            ],
            const SizedBox(height: Spacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (contact.isEmergencyContact)
                  Text(
                    'Contacto de Emergencia',
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                if (!contact.isEmergencyContact) const Spacer(), // Ocupa espacio si no es de emergencia
                 TextButton(
                    onPressed: () => onSetEmergency(!contact.isEmergencyContact),
                    child: Text(contact.isEmergencyContact ? 'Quitar de emergencia' : 'Marcar como emergencia'),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}