import 'package:flutter/material.dart';

class AppTable<T> extends StatelessWidget {
  final List<String> columns;
  final List<T> items;
  final int currentPage;
  final int rowsPerPage;
  final void Function(int) onPageChanged;
  final DataRow Function(T item) buildRow;

  const AppTable({
    super.key,
    required this.columns,
    required this.items,
    required this.currentPage,
    required this.rowsPerPage,
    required this.onPageChanged,
    required this.buildRow,
  });

  List<T> get currentItems {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, items.length);
    return items.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
            rows: currentItems.map(buildRow).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
              icon: const Icon(Icons.arrow_back),
            ),
            Text('${currentPage + 1}'),
            IconButton(
              onPressed: (currentPage + 1) * rowsPerPage < items.length
                  ? () => onPageChanged(currentPage + 1)
                  : null,
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}
