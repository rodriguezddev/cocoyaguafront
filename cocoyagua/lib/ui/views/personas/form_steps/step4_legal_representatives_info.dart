import 'package:flutter/material.dart';
import '../../../../models/legal_representative_model.dart';
import '../../../components/shared/responsive.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';
import '../../../theme/typography.dart';
import '../../../widgets/dialogs/add_legal_representative_dialog.dart';
import '../../../widgets/list_items/legal_representative_list_item.dart';

class Step4LegalRepresentativesInfo extends StatelessWidget {
  final bool isMobile;
  final String? selectedPersonType;
  final List<LegalRepresentative> legalRepresentatives;
  final Function(LegalRepresentative, {LegalRepresentative? oldRepresentative}) onAddOrUpdateLegalRepresentative;
  final Function(LegalRepresentative) onDeleteLegalRepresentative;

  const Step4LegalRepresentativesInfo({
    super.key,
    required this.isMobile,
    required this.selectedPersonType,
    required this.legalRepresentatives,
    required this.onAddOrUpdateLegalRepresentative,
    required this.onDeleteLegalRepresentative,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedPersonType != 'Jurídica') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
        child: Center(
          child: Text(
            'La sección de Representante Legal solo aplica para personas de tipo Jurídica.',
            style: AppTypography.body.copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Representantes Legales', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
            TextButton.icon(
              icon: const Icon(Icons.manage_accounts_outlined),
              label: const Text('Agregar Representante'),
              onPressed: () async {
                final newRepresentative = await AddLegalRepresentativeDialog.show(context);
                if (newRepresentative != null) {
                  onAddOrUpdateLegalRepresentative(newRepresentative);
                }
              },
            )
          ],
        ),
        const SizedBox(height: Spacing.md),
        legalRepresentatives.isEmpty
            ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: Spacing.lg), child: Text('No hay representantes legales agregados.', style: AppTypography.body.copyWith(fontStyle: FontStyle.italic))))
            : isMobile
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: legalRepresentatives.length,
                    itemBuilder: (context, index) {
                      final representative = legalRepresentatives[index];
                      return LegalRepresentativeListItem(representative: representative, onEdit: () async { final updatedRep = await AddLegalRepresentativeDialog.show(context, representativeToEdit: representative); if (updatedRep != null) { onAddOrUpdateLegalRepresentative(updatedRep, oldRepresentative: representative); } }, onDelete: () => onDeleteLegalRepresentative(representative));
                    },
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: legalRepresentatives.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 180, // Ajusta según el alto de tu LegalRepresentativeListItem
                      mainAxisSpacing: Spacing.md,
                      crossAxisSpacing: Spacing.md,
                    ),
                    itemBuilder: (context, index) {
                      final representative = legalRepresentatives[index];
                      return LegalRepresentativeListItem(representative: representative, onEdit: () async { final updatedRep = await AddLegalRepresentativeDialog.show(context, representativeToEdit: representative); if (updatedRep != null) { onAddOrUpdateLegalRepresentative(updatedRep, oldRepresentative: representative); } }, onDelete: () => onDeleteLegalRepresentative(representative));
                    },
                  ),
        const SizedBox(height: Spacing.lg),
      ],
    );
  }
}