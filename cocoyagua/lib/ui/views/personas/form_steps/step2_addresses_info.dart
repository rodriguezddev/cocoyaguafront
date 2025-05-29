import 'package:flutter/material.dart';
import '../../../../models/address_model.dart';
import '../../../components/shared/responsive.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';
import '../../../theme/typography.dart';
import '../../../widgets/dialogs/add_address_dialog.dart';
import '../../../widgets/list_items/address_list_item.dart';

class Step2AddressesInfo extends StatelessWidget {
  final bool isMobile;
  final List<Address> addresses;
  final Function(Address, {Address? oldAddress}) onAddOrUpdateAddress;
  final Function(Address) onDeleteAddress;
  final Function(Address) onSetPrimaryAddress;

  const Step2AddressesInfo({
    super.key,
    required this.isMobile,
    required this.addresses,
    required this.onAddOrUpdateAddress,
    required this.onDeleteAddress,
    required this.onSetPrimaryAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Direcciones', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
            TextButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Agregar una nueva dirección'),
              onPressed: () async {
                final newAddress = await AddAddressDialog.show(context);
                if (newAddress != null) {
                  onAddOrUpdateAddress(newAddress);
                }
              },
            )
          ],
        ),
        const SizedBox(height: Spacing.md),
        addresses.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
                  child: Text('No hay direcciones agregadas.', style: AppTypography.body.copyWith(fontStyle: FontStyle.italic)),
                ),
              )
            : isMobile
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return AddressListItem(
                        address: address,
                        onEdit: () async {
                          final updatedAddress = await AddAddressDialog.show(context, addressToEdit: address);
                          if (updatedAddress != null) {
                            onAddOrUpdateAddress(updatedAddress, oldAddress: address);
                          }
                        },
                        onDelete: () => onDeleteAddress(address),
                        onSetPrimary: (_) => onSetPrimaryAddress(address),
                      );
                    },
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addresses.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 200, // Ajusta según el alto de tu AddressListItem
                      mainAxisSpacing: Spacing.md,
                      crossAxisSpacing: Spacing.md,
                    ),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return AddressListItem(
                        address: address,
                        onEdit: () async {
                          final updatedAddress = await AddAddressDialog.show(context, addressToEdit: address);
                          if (updatedAddress != null) {
                            onAddOrUpdateAddress(updatedAddress, oldAddress: address);
                          }
                        },
                        onDelete: () => onDeleteAddress(address),
                        onSetPrimary: (_) => onSetPrimaryAddress(address),
                      );
                    },
                  ),
        const SizedBox(height: Spacing.lg),
      ],
    );
  }
}