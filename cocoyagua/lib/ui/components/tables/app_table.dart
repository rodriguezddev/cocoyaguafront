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

      // Asignar FlexColumnWidth por defecto a todas las columnas
      for (int i = 0; i < columns.length; i++) {
        widths[i] = const FlexColumnWidth(1.0);
      }

      // Ajustes específicos basados en el título de la columna (o índice si es más genérico)
      // Esto es un ejemplo, idealmente se pasaría una configuración o se usarían índices si los nombres no son fijos.
      for (int i = 0; i < columns.length; i++) {
        final columnTitle = columns[i].toUpperCase(); // Convertir a mayúsculas para comparación insensible
        if (columnTitle == 'NOMBRE COMPLETO') {
          widths[i] = const FlexColumnWidth(1.8); // Más espacio para Nombre Completo
        } else if (columnTitle == 'GÉNERO') {
          widths[i] = const FlexColumnWidth(0.6); // Menos espacio para Género
        } else if (columnTitle == 'ROLES') {
          widths[i] = const FlexColumnWidth(0.7); // Menos espacio para Roles
        } else if (columnTitle == 'DOCUMENTO' && columns.length > 3) { // Asumiendo que 'DOCUMENTO' es el tipo
          widths[i] = const FlexColumnWidth(0.8);
        }
         // La columna de ID (si es la primera y no es Nombre Completo) podría tener un flex menor
        if (i == 0 && columnTitle != 'NOMBRE COMPLETO' && !columnTitle.contains("ID")) { // Ejemplo si la primera no es ID
            // No hacer nada especial, ya tiene Flex 1.0
        } else if (i == 0 && (columnTitle.contains("ID") || columnTitle.contains("Nº"))) {
             widths[i] = const FlexColumnWidth(0.5); // Menos espacio para IDs
        }
      }

      // Asignar un ancho fijo a la última columna si es para acciones (generalmente vacía o con iconos)
      if (columns.isNotEmpty && columns.last.isEmpty) {
        widths[columns.length - 1] = const FixedColumnWidth(190.0); // Aumentar ligeramente para más espacio en Acciones
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
