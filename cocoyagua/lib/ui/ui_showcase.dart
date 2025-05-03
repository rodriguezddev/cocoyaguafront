import 'package:flutter/material.dart';
import 'package:cocoyagua/ui/ui_kit.dart';

class UIShowcasePage extends StatefulWidget {
  const UIShowcasePage({super.key});

  @override
  State<UIShowcasePage> createState() => _UIShowcasePageState();
}

class _UIShowcasePageState extends State<UIShowcasePage> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedOption = 'A';
  int _page = 0;

  final List<Map<String, String>> _tableData = List.generate(15, (i) => {
        'name': 'Item $i',
        'email': 'item$i@example.com',
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UI Kit Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buttons', style: AppTypography.headline),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                AppButton(text: 'Primary', onPressed: () {}),
                const SizedBox(width: Spacing.sm),
                AppButton(text: 'Secondary', primary: false, onPressed: () {}),
              ],
            ),

            const SizedBox(height: Spacing.lg),
            const Text('Inputs', style: AppTypography.headline),
            const SizedBox(height: Spacing.sm),
            AppInput(
              label: 'Nombre',
              controller: _inputController,
              hintText: 'Ingresa tu nombre',
            ),

            const SizedBox(height: Spacing.md),
            AppSelect<String>(
              label: 'Selecciona una opción',
              value: _selectedOption,
              options: ['A', 'B', 'C'],
              labelBuilder: (v) => 'Opción $v',
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedOption = val);
                }
              }
            ),

            const SizedBox(height: Spacing.lg),
            const Text('Card', style: AppTypography.headline),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Este es un card.', style: AppTypography.body),
                  SizedBox(height: Spacing.sm),
                  Text('Puede contener cualquier widget.'),
                ],
              ),
            ),

            const SizedBox(height: Spacing.lg),
            const Text('Tabla + paginador', style: AppTypography.headline),
            AppTable<Map<String, String>>(
              columns: const ['Nombre', 'Correo'],
              items: _tableData,
              currentPage: _page,
              rowsPerPage: 5,
              onPageChanged: (newPage) => setState(() => _page = newPage),
              buildRow: (item) => DataRow(
                cells: [
                  DataCell(Text(item['name']!)),
                  DataCell(Text(item['email']!)),
                ],
              ),
            ),

            const SizedBox(height: Spacing.lg),
            AppButton(
              text: 'Mostrar modal de éxito',
              onPressed: () => showAppModal(
                context,
                title: '¡Éxito!',
                message: 'La operación se realizó correctamente.',
                isSuccess: true,
              ),
            ),

            const SizedBox(height: Spacing.sm),
            AppButton(
              text: 'Mostrar modal de error',
              primary: false,
              onPressed: () => showAppModal(
                context,
                title: 'Error',
                message: 'Algo salió mal.',
                isSuccess: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
