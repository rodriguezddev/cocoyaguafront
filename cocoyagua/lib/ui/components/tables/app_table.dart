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
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
        5: FixedColumnWidth(80),
      },
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
