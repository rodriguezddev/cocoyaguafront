import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/typography.dart';

typedef DataRowBuilder<T> = DataRow Function(T item);

class AppTable<T> extends StatelessWidget {
  final List<String> columns;
  final List<T> items;
  final DataRowBuilder<T> buildRow;

  // Opcional: para paginación si quieres extender después
  final int? currentPage;
  final int? rowsPerPage;
  final ValueChanged<int>? onPageChanged;

  const AppTable({
    super.key,
    required this.columns,
    required this.items,
    required this.buildRow,
    this.currentPage,
    this.rowsPerPage,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    Map<int, TableColumnWidth> getDynamicColumnWidths() {
      final Map<int, TableColumnWidth> widths = {};
      if (columns.isEmpty) {
        return widths;
      }

      // Asignar FlexColumnWidth a la mayoría de las columnas
      for (int i = 0; i < columns.length; i++) {
        widths[i] = const FlexColumnWidth(1.0);
      }

      // Dar un poco más de espacio a la primera columna (si existe)
      if (columns.isNotEmpty) {
        widths[0] = const FlexColumnWidth(0.8); // Reducir el flex para la columna ID
      }

      // Asignar un ancho fijo más grande a la última columna (para acciones)
      if (columns.length > 1) { // Asegurarse de que hay al menos dos columnas para que "última" sea distinta de "primera" en algunos casos
        widths[columns.length - 1] = const FixedColumnWidth(190.0); // Aumentar ligeramente para más espacio en Acciones
      } else if (columns.length == 1) { // Si solo hay una columna, que también tenga un ancho fijo razonable o flex
        widths[0] = const FixedColumnWidth(190.0); // O FlexColumnWidth(1.0) si se prefiere que ocupe todo el espacio
      }
      return widths;
    }

    return Table(
      columnWidths: getDynamicColumnWidths(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(
                    0xFFEEEEEE),
              ),
            ),
          ),
          children: columns
              .map(
                (title) => Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    title,
                    style: AppTypography.bodyLg
                        .copyWith(fontWeight: FontWeight.bold, color: AppTheme.texttableColor),
                  ),
                ),
              )
              .toList(),
        ),
        ...items.map((item) {
          final row = buildRow(item);
          return TableRow(
            children: row.cells.map((cell) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: cell.child,
              );
            }).toList(),
          );
        }).toList(),
      ],
    );
  }
}
