import 'package:flutter/material.dart';
import '../../../models/address_model.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class AddressListItem extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool) onSetPrimary;

  const AddressListItem({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetPrimary,
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
                if (address.isPrimary)
                  Text(
                    'Dirección Principal',
                    style: AppTypography.bodyLg.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                if (!address
                    .isPrimary) // Espaciador para alinear si no es principal
                  const SizedBox.shrink(),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit,
                          color: AppTheme.textColor.withOpacity(0.7)),
                      onPressed: onEdit,
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete,
                          color: Colors.red.withOpacity(0.7)),
                      onPressed: onDelete,
                      tooltip: 'Eliminar',
                    ),
                  ],
                )
              ],
            ),
            if (address.isPrimary) const SizedBox(height: Spacing.sm),
            Text(
              '${address.streetAddress}, ${address.district}, ${address.province}, ${address.department}, ${address.country}',
              style: AppTypography.bodyLg,
            ),
            if (address.reference != null && address.reference!.isNotEmpty) ...[
              const SizedBox(height: Spacing.xs),
              Text(
                'Ref: ${address.reference}',
                style: AppTypography.body
                    .copyWith(color: AppTheme.textColor.withOpacity(0.8)),
              ),
            ],
            if (!address.isPrimary) ...[
              const SizedBox(height: Spacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => onSetPrimary(true),
                  child: const Text('Marcar como principal'),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
