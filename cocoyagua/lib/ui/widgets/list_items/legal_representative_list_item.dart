import 'package:flutter/material.dart';
import '../../../models/legal_representative_model.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class LegalRepresentativeListItem extends StatelessWidget {
  final LegalRepresentative representative;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LegalRepresentativeListItem({
    super.key,
    required this.representative,
    required this.onEdit,
    required this.onDelete,
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
                    representative.fullName,
                    style: AppTypography.bodyLg
                        .copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
            Text(representative.position,
                style: AppTypography.body
                    .copyWith(color: AppTheme.textColor.withOpacity(0.8))),
            const SizedBox(height: Spacing.xs),
            Text(
                '${representative.documentType}: ${representative.documentNumber}',
                style: AppTypography.body),
            if (representative.phone != null &&
                representative.phone!.isNotEmpty) ...[
              const SizedBox(height: Spacing.xs),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: AppTheme.textColor),
                  const SizedBox(width: Spacing.xs),
                  Text(representative.phone!, style: AppTypography.body),
                ],
              ),
            ],
            if (representative.email != null &&
                representative.email!.isNotEmpty) ...[
              const SizedBox(height: Spacing.xs),
              Row(
                children: [
                  const Icon(Icons.email, size: 16, color: AppTheme.textColor),
                  const SizedBox(width: Spacing.xs),
                  Text(representative.email!, style: AppTypography.body),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
