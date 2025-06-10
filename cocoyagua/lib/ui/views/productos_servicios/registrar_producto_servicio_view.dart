import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';
import 'productos_servicios_view.dart'; // Para el tipo ProductoServicioRowData

class RegistrarProductoServicioView extends StatefulWidget {
  final ProductoServicioRowData? productoExistente;

  const RegistrarProductoServicioView({super.key, this.productoExistente});

  @override
  State<RegistrarProductoServicioView> createState() =>
      _RegistrarProductoServicioViewState();
}

class _RegistrarProductoServicioViewState
    extends State<RegistrarProductoServicioView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codigoController;
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioListadoController;
  late TextEditingController _costoEstandarController;
  late TextEditingController _puntoPedidoController;
  late TextEditingController _nivelObjetivoController;
  late TextEditingController _cantidadPorUnidadController;
  late TextEditingController _cantidadMinimaReposicionController;

  String? _selectedProveedorId;
  String? _selectedCategoria;
  bool _isSuspendido = false;

  // TODO: Cargar estas listas desde una fuente de datos real
  final List<String> _proveedorOptions = ['PROV-001', 'PROV-002', 'PROV-003'];
  final List<String> _categoriaOptions = [
    'Electrónicos',
    'Servicios Varios',
    'Materiales Oficina',
    'Software',
    'Consultoría'
  ];

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(
        text: widget.productoExistente?.codigoProducto ?? '');
    _nombreController =
        TextEditingController(text: widget.productoExistente?.nombre ?? '');
    _descripcionController = TextEditingController(
        text: widget.productoExistente?.descripcion ?? '');
    _precioListadoController = TextEditingController(
        text: widget.productoExistente?.precioListado.toString() ?? '');
    _costoEstandarController = TextEditingController(
        text: widget.productoExistente?.costoEstandar.toString() ?? '');
    _puntoPedidoController = TextEditingController(
        text: widget.productoExistente?.puntoPedido.toString() ?? '');
    _nivelObjetivoController = TextEditingController(
        text: widget.productoExistente?.nivelObjetivo.toString() ?? '');
    _cantidadPorUnidadController = TextEditingController(
        text: widget.productoExistente?.cantidadPorUnidad ?? '');
    _cantidadMinimaReposicionController = TextEditingController(
        text: widget.productoExistente?.cantidadMinimaReposicion.toString() ??
            '');

    _selectedProveedorId = widget.productoExistente?.proveedorId;
    _selectedCategoria = widget.productoExistente?.categoria;
    _isSuspendido = widget.productoExistente?.suspendido ?? false;
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioListadoController.dispose();
    _costoEstandarController.dispose();
    _puntoPedidoController.dispose();
    _nivelObjetivoController.dispose();
    _cantidadPorUnidadController.dispose();
    _cantidadMinimaReposicionController.dispose();
    super.dispose();
  }

  void _guardarProductoServicio() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implementar lógica de guardado (crear o actualizar)
      // TODO: Implementar lógica para evitar duplicidad de PRODUCTO_ID
      final String mensaje = widget.productoExistente == null
          ? 'Producto/Servicio creado (simulación)'
          : 'Producto/Servicio actualizado (simulación)';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
      Navigator.of(context).pop(); // Volver a la lista
    }
  }

  Widget _buildHeader() {
    // Adaptado de PersonInformationForm
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Productos y Servicios', // Título del módulo
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
                Text('Operador', // Ejemplo de rol, puedes cambiarlo
                    style: AppTypography.bodySm.copyWith(color: AppTheme.textPrimaryColor)), // Color de rol ajustado
              ],
            ),
            const SizedBox(width: Spacing.md),
            const CircleAvatar( // Avatar de ejemplo
              backgroundColor: AppTheme.primaryColor,
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
    final String formTitle = widget.productoExistente == null
        ? 'Registrar Nuevo Producto/Servicio' // Título para el cuerpo del formulario
        : 'Editar Producto/Servicio'; // Título para el cuerpo del formulario

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
                leading: BackButton(
                    color: AppTheme.textPrimaryColor,
                    onPressed: () => Navigator.of(context).pop()),
                title: _buildHeader(), // Muestra "Productos y Servicios" y la info de usuario
                toolbarHeight: 80,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Form(
                  // El Form ahora envuelve también la nueva sección de texto y el formulario real
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección de título y descripción similar a PersonInformationForm
                      Text(
                        formTitle, // Título dinámico del formulario
                        style: AppTypography.h2
                            .copyWith(color: AppTheme.textPrimaryColor),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        'Complete la información requerida para el producto o servicio.', // Descripción
                        style: AppTypography.bodyLg
                            .copyWith(color: AppTheme.textPrimaryColor),
                      ),
                      const SizedBox(height: Spacing.xl), // Espacio antes del formulario

                      // Inicio de los campos del formulario
                      Row(
                        children: [
                          Expanded(
                            child: AppInput(
                                label: 'Código del Producto*',
                                controller: _codigoController,
                                validator: (v) => v!.isEmpty
                                    ? 'Campo requerido'
                                    : null), // TODO: Validar duplicidad
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: AppInput(
                                label: 'Nombre*',
                                controller: _nombreController,
                                validator: (v) =>
                                    v!.isEmpty ? 'Campo requerido' : null),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      AppInput(
                          label: 'Descripción',
                          controller: _descripcionController,
                          maxLines: 3),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: AppSelect<String>(
                                label: 'Proveedor*',
                                value: _selectedProveedorId,
                                options: _proveedorOptions,
                                onChanged: (v) =>
                                    setState(() => _selectedProveedorId = v),
                                labelBuilder: (v) => v,
                                // hintText: 'Seleccione un proveedor',
                                validator: (v) =>
                                    v == null ? 'Campo requerido' : null),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: AppSelect<String>(
                                label: 'Categoría*',
                                value: _selectedCategoria,
                                options: _categoriaOptions,
                                onChanged: (v) =>
                                    setState(() => _selectedCategoria = v),
                                labelBuilder: (v) => v,
                                // hintText: 'Seleccione una categoría',
                                validator: (v) =>
                                    v == null ? 'Campo requerido' : null),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          Expanded(
                              child: AppInput(
                                  label: 'Precio Listado*',
                                  controller: _precioListadoController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  validator: (v) =>
                                      v!.isEmpty ? 'Campo requerido' : null)),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                              child: AppInput(
                                  label: 'Costo Estándar*',
                                  controller: _costoEstandarController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  validator: (v) =>
                                      v!.isEmpty ? 'Campo requerido' : null)),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          Expanded(
                              child: AppInput(
                                  label: 'Punto de Pedido',
                                  controller: _puntoPedidoController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ])),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                              child: AppInput(
                                  label: 'Nivel Objetivo',
                                  controller: _nivelObjetivoController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ])),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: AppInput(
                                label: 'Cantidad por Unidad',
                                controller: _cantidadPorUnidadController),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: AppInput(
                                label: 'Cantidad Mínima de Reposición',
                                controller:
                                    _cantidadMinimaReposicionController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      SwitchListTile(
                        title: Text('Suspendido',
                            style: AppTypography.bodyLg
                                .copyWith(color: AppTheme.textPrimaryColor)),
                        value: _isSuspendido,
                        onChanged: (bool value) {
                          setState(() {
                            _isSuspendido = value;
                          });
                        },
                        activeColor: AppTheme.primaryColor,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: Spacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            text: 'Cancelar',
                            onPressed: () => Navigator.of(context).pop(),
                            kind: AppButtonKind.secondary,
                            width: isMobile ? null : 120,
                          ),
                          const SizedBox(width: Spacing.md),
                          AppButton(
                            text: widget.productoExistente == null
                                ? 'Crear Producto'
                                : 'Actualizar Producto',
                            onPressed: _guardarProductoServicio,
                            kind: AppButtonKind.primary,
                            width: isMobile ? null : 180,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
