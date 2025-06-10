import 'package:flutter/material.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/layout/app_card.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';
import 'registrar_producto_servicio_view.dart';
import '../../components/tables/app_table.dart';

// Data class for table rows
class ProductoServicioRowData {
  final String id; // Internal ID for easier handling
  final String codigoProducto;
  final String nombre;
  final double precioListado;
  final String categoria;
  final bool suspendido;
  // Additional fields for details modal and form
  final String descripcion;
  final String
      proveedorId; // For simplicity, using ID. In real app, might be an object.
  final double costoEstandar;
  final int puntoPedido;
  final int nivelObjetivo;
  final String cantidadPorUnidad;
  final int cantidadMinimaReposicion;

  ProductoServicioRowData({
    required this.id,
    required this.codigoProducto,
    required this.nombre,
    required this.precioListado,
    required this.categoria,
    required this.suspendido,
    required this.descripcion,
    required this.proveedorId,
    required this.costoEstandar,
    required this.puntoPedido,
    required this.nivelObjetivo,
    required this.cantidadPorUnidad,
    required this.cantidadMinimaReposicion,
  });
}

class ProductosServiciosView extends StatefulWidget {
  const ProductosServiciosView({super.key});

  @override
  _ProductosServiciosViewState createState() => _ProductosServiciosViewState();
}

class _ProductosServiciosViewState extends State<ProductosServiciosView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoriaFilter = 'Todas';
  String? _selectedEstadoFilter = 'Todos'; // Todos, Activos, Inactivos
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  // Sample data for the table
  // TODO: Replace with actual data fetching
  final List<ProductoServicioRowData> _productosServiciosList =
      List.generate(15, (index) {
    return ProductoServicioRowData(
      id: 'prod_id_${index + 1}',
      codigoProducto: 'COD-${1000 + index}',
      nombre: 'Producto Ejemplo ${index + 1}',
      precioListado: 100.0 + (index * 10),
      categoria: (index % 3 == 0)
          ? 'Electrónicos'
          : (index % 3 == 1 ? 'Servicios Varios' : 'Materiales Oficina'),
      suspendido: index % 4 == 0,
      descripcion: 'Descripción detallada del producto ejemplo ${index + 1}.',
      proveedorId: 'PROV-00${(index % 5) + 1}',
      costoEstandar: 70.0 + (index * 5),
      puntoPedido: 10 + index,
      nivelObjetivo: 50 + (index * 2),
      cantidadPorUnidad: '1 Unidad',
      cantidadMinimaReposicion: 5,
    );
  });

  List<String> get _categoriasUnicas {
    final categorias =
        _productosServiciosList.map((p) => p.categoria).toSet().toList();
    categorias.sort();
    return ['Todas', ...categorias];
  }

  void _mostrarDialogoDetalles(
      BuildContext context, ProductoServicioRowData producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de ${producto.nombre}',
              style:
                  AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  _buildDetailRow('Código Producto:', producto.codigoProducto),
                  _buildDetailRow('Nombre:', producto.nombre),
                  _buildDetailRow('Descripción:', producto.descripcion),
                  _buildDetailRow('Categoría:', producto.categoria),
                  _buildDetailRow('Precio Listado:',
                      'L ${producto.precioListado.toStringAsFixed(2)}'),
                  _buildDetailRow('Costo Estándar:',
                      'L ${producto.costoEstandar.toStringAsFixed(2)}'),
                  _buildDetailRow('Proveedor ID:', producto.proveedorId),
                  _buildDetailRow(
                      'Punto de Pedido:', producto.puntoPedido.toString()),
                  _buildDetailRow(
                      'Nivel Objetivo:', producto.nivelObjetivo.toString()),
                  _buildDetailRow(
                      'Cantidad por Unidad:', producto.cantidadPorUnidad),
                  _buildDetailRow('Cant. Mínima Reposición:',
                      producto.cantidadMinimaReposicion.toString()),
                  _buildDetailRow(
                      'Suspendido:', producto.suspendido ? 'Sí' : 'No'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            AppButton(
              text: 'Cerrar',
              onPressed: () => Navigator.of(context).pop(),
              kind: AppButtonKind.ghost,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style:
              AppTypography.body.copyWith(color: AppTheme.textColor),
          children: [
            TextSpan(
                text: '$label ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _eliminarProductoServicio(
      BuildContext context, ProductoServicioRowData producto) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirmar Eliminación',
              style:
                  AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
          content: Text(
              '¿Está seguro de que desea eliminar el producto/servicio "${producto.nombre}"?'),
          actions: <Widget>[
            AppButton(
              text: 'Cancelar',
              onPressed: () => Navigator.of(dialogContext).pop(),
              kind: AppButtonKind.ghost,
            ),
            AppButton(
              text: 'Eliminar',
              onPressed: () {
                // TODO: Implement actual delete logic
                setState(() {
                  _productosServiciosList
                      .removeWhere((p) => p.id == producto.id);
                });
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Producto/Servicio "${producto.nombre}" eliminado (simulación).')),
                );
              },
              kind: AppButtonKind
                  .primary, // Or a destructive kind if you have one
              // style: AppButton.styleFrom(backgroundColor: Colors.red), // Example for destructive
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    // Adaptado del que proporcionaste
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Productos y Servicios', // Título cambiado
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        // Puedes ajustar la información del usuario si es necesario
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Santiago Meza Alvés', // Ejemplo de usuario
                    style: AppTypography.bodyLg
                        .copyWith(color: AppTheme.textPrimaryColor)),
                Text('Administrador', // Ejemplo de rol
                    style: AppTypography.bodySm
                        .copyWith(color: AppTheme.textPrimaryColor)), // Color ajustado para el rol
              ],
            ),
            const SizedBox(width: Spacing.md),
            const CircleAvatar( // Avatar de ejemplo
              backgroundColor: AppTheme.primaryColor, // Color del avatar
              child: Icon(Icons.person, color: Colors.white),
              radius: 20,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    // TODO: Implement actual filtering logic
    final List<ProductoServicioRowData> filteredList =
        _productosServiciosList.where((p) {
      final searchLower = _searchController.text.toLowerCase();
      final matchesSearch = searchLower.isEmpty ||
          p.nombre.toLowerCase().contains(searchLower) ||
          p.codigoProducto.toLowerCase().contains(searchLower) ||
          p.categoria.toLowerCase().contains(searchLower);

      final matchesCategoria = _selectedCategoriaFilter == 'Todas' ||
          p.categoria == _selectedCategoriaFilter;

      final matchesEstado = _selectedEstadoFilter == 'Todos' ||
          (_selectedEstadoFilter == 'Activos' && !p.suspendido) ||
          (_selectedEstadoFilter == 'Inactivos' && p.suspendido);

      return matchesSearch && matchesCategoria && matchesEstado;
    }).toList();

    return Scaffold(
      drawer: isMobile ? const Drawer(child: SidebarMenu()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const SidebarMenu(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: _buildHeader(), // Usando el nuevo header
                toolbarHeight: 80,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: ListView(
                  children: [
                    // Filters and Create Button
                    if (isMobile)
                      _buildMobileFiltersAndActions()
                    else
                      _buildDesktopFiltersAndActions(),
                    const SizedBox(height: Spacing.lg),
                    AppCard(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildAppTable(filteredList),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFiltersAndActions() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch, // Se elimina para permitir alineación a la derecha
      children: [
        // Container 1: Search Input (ocupa todo el ancho)
        AppInput(
            hintText: 'Buscar por nombre, código, categoría...',
            controller: _searchController,
            icon: Icons.search,
            label: 'Buscar',
            isLabelVisible: false,
            onChanged: (_) => setState(() {})
        ),
        const SizedBox(height: Spacing.md),
        // Container 2: Selects and Button (alineados a la derecha)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end, // Alinea los hijos a la derecha
          children: [
            AppSelect<String>(
              value: _selectedCategoriaFilter,
              label: 'Categoría',
              options: _categoriasUnicas,
              labelBuilder: (v) => v,
              onChanged: (value) =>
                  setState(() => _selectedCategoriaFilter = value),
            ),
            const SizedBox(height: Spacing.md),
            AppSelect<String>(
              value: _selectedEstadoFilter,
              label: 'Estado',
              options: const ['Todos', 'Activos', 'Inactivos'],
              labelBuilder: (v) => v,
              onChanged: (value) => setState(() => _selectedEstadoFilter = value),
            ),
            const SizedBox(height: Spacing.md),
            AppButton(
              text: 'Crear Producto/Servicio',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const RegistrarProductoServicioView()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopFiltersAndActions() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: AppInput(
              hintText: 'Buscar por nombre, código, categoría...',
              controller: _searchController,
              icon: Icons.search,
              label: 'Buscar',
              onChanged: (_) => setState(() {})),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          flex: 2,
          child: AppSelect<String>(
            value: _selectedCategoriaFilter,
            label: 'Categoría',
            options: _categoriasUnicas,
            labelBuilder: (v) => v,
            onChanged: (value) =>
                setState(() => _selectedCategoriaFilter = value),
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          flex: 2,
          child: AppSelect<String>(
            value: _selectedEstadoFilter,
            label: 'Estado',
            options: const ['Todos', 'Activos', 'Inactivos'],
            labelBuilder: (v) => v,
            onChanged: (value) => setState(() => _selectedEstadoFilter = value),
          ),
        ),
        const SizedBox(width: Spacing.md),
        Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Alinea el botón al inicio
          children: [
            const SizedBox(
                height:
                    28), // Espaciador para alinear con los labels de los inputs/selects
            AppButton(
              text: 'Crear producto',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const RegistrarProductoServicioView()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppTable(List<ProductoServicioRowData> items) {
    return AppTable<ProductoServicioRowData>(
      columns: const [
        'CÓDIGO',
        'NOMBRE',
        'PRECIO LISTADO',
        'CATEGORÍA',
        'SUSPENDIDO',
        'ACCIONES',
      ],
      items: items,
      currentPage: _currentPage,
      rowsPerPage: _rowsPerPage,
      onPageChanged: (page) => setState(() => _currentPage = page),
      buildRow: (item) {
        return DataRow(
          cells: [
            DataCell(Text(item.codigoProducto,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(item.nombre,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text('L ${item.precioListado.toStringAsFixed(2)}',
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(item.categoria,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Icon(
                item.suspendido ? Icons.check_circle : Icons.cancel_outlined,
                color: item.suspendido ? Colors.red : Colors.green,
                size: 20)),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero, // Reducir padding
                      constraints: const BoxConstraints(), // Reducir constraints de tamaño
                      icon: const Icon(Icons.visibility_outlined,
                          color: AppTheme.primaryColor, size: 18), // Ícono más pequeño
                      tooltip: 'Ver', // Tooltip más corto
                      onPressed: () => _mostrarDialogoDetalles(context, item)),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.edit_outlined,
                          color: AppTheme.primaryColor, size: 18),
                      tooltip: 'Editar',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegistrarProductoServicioView(
                                        productoExistente: item)));
                      }),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.delete_outline,
                          color: AppTheme.dangerColor, size: 18),
                      tooltip: 'Eliminar',
                      onPressed: () =>
                          _eliminarProductoServicio(context, item)),
                ],
              ),
            ),
            // Ajustar el espaciado entre celdas si es necesario a través de AppTable o DataTable
            // Por ejemplo, si AppTable es un DataTable, podrías ajustar `columnSpacing`.
            // Sin embargo, la modificación directa de los IconButtons es más localizada.
          ],
        );
      },
    );
  }
}
