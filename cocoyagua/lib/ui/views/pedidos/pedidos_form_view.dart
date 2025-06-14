import 'package:cocoyagua/models/pedido_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';

class PedidoFormView extends StatefulWidget {
  final Pedido? pedidoToEdit;

  const PedidoFormView({super.key, this.pedidoToEdit});

  @override
  State<PedidoFormView> createState() => _PedidoFormViewState();
}

class _PedidoFormViewState extends State<PedidoFormView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para Pedido
  late TextEditingController _pedidoIdController;
  late TextEditingController _fechaPedidoController;
  late TextEditingController _fechaEnvioController;
  late TextEditingController _fechaPagoController;
  late TextEditingController _gastosEnvioController;
  late TextEditingController _tipoImpositivoController; // Para el % de impuesto
  late TextEditingController _notasController;

  // Datos de envío
  late TextEditingController _nombreEnvioController;
  late TextEditingController _direccionEnvioController;
  late TextEditingController _ciudadEnvioController;
  late TextEditingController _codigoPostalEnvioController;
  late TextEditingController _paisEnvioController;

  // Selected values
  DateTime? _selectedFechaPedido;
  DateTime? _selectedFechaEnvio;
  DateTime? _selectedFechaPago;
  String? _selectedEmpleadoId;
  String? _selectedClienteId;
  String? _selectedTransportistaId;
  String? _selectedTipoPago;
  String? _selectedEstadoImpuestos;
  String? _selectedPdoPeriodoFacturacion;
  String? _selectedPdoPersonaId;
  EstadoPedido _selectedEstadoPedido = EstadoPedido.pendiente;

  List<PedidoDetalle> _detallesPedido = [];

  // Mock data - reemplazar con datos reales
  final List<String> _empleadoOptions = ['EMP001-Juan', 'EMP002-Ana'];
  final List<String> _clienteOptions = ['CLI001-EmpresaA', 'CLI002-EmpresaB'];
  final List<String> _transportistaOptions = ['TRANS01-DHL', 'TRANS02-UPS'];
  final List<String> _tipoPagoOptions = ['Efectivo', 'Tarjeta Crédito', 'Transferencia'];
  final List<String> _estadoImpuestosOptions = ['Pendiente', 'Pagado', 'Exento'];
  final List<String> _periodoFacturacionOptions = ['2023-10', '2023-11', '2023-12'];
  // Para productos en detalles
  final List<String> _productoOptions = ['PROD001-Laptop', 'PROD002-Mouse', 'PROD003-Teclado'];


  @override
  void initState() {
    super.initState();
    _pedidoIdController = TextEditingController(text: widget.pedidoToEdit?.pedidoId ?? ''); // Generalmente autogenerado
    
    _selectedFechaPedido = widget.pedidoToEdit?.fechaPedido ?? DateTime.now();
    _fechaPedidoController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(_selectedFechaPedido!));
    
    _selectedFechaEnvio = widget.pedidoToEdit?.fechaEnvio;
    _fechaEnvioController = TextEditingController(text: _selectedFechaEnvio != null ? DateFormat('dd/MM/yyyy').format(_selectedFechaEnvio!) : '');

    _selectedFechaPago = widget.pedidoToEdit?.fechaPago;
    _fechaPagoController = TextEditingController(text: _selectedFechaPago != null ? DateFormat('dd/MM/yyyy').format(_selectedFechaPago!) : '');

    _gastosEnvioController = TextEditingController(text: widget.pedidoToEdit?.gastosEnvio.toString() ?? '0.0');
    _tipoImpositivoController = TextEditingController(text: widget.pedidoToEdit?.tipoImpositivo?.toString() ?? '0.18'); // Ejemplo 18%
    _notasController = TextEditingController(text: widget.pedidoToEdit?.notas ?? '');

    _nombreEnvioController = TextEditingController(text: widget.pedidoToEdit?.nombreEnvio ?? '');
    _direccionEnvioController = TextEditingController(text: widget.pedidoToEdit?.direccionEnvio ?? '');
    _ciudadEnvioController = TextEditingController(text: widget.pedidoToEdit?.ciudadMunicipioDest ?? '');
    _codigoPostalEnvioController = TextEditingController(text: widget.pedidoToEdit?.codigoPostalDest ?? '');
    _paisEnvioController = TextEditingController(text: widget.pedidoToEdit?.paisDest ?? '');

    // TODO: Adaptar la lógica de inicialización para _selectedEmpleadoId, _selectedClienteId, etc. similar a LecturaFormView si los IDs no coinciden directamente con las opciones.
    _selectedEmpleadoId = widget.pedidoToEdit?.empleadoId;
    _selectedClienteId = widget.pedidoToEdit?.clienteId;
    _selectedTransportistaId = widget.pedidoToEdit?.transportistaId;
    _selectedTipoPago = widget.pedidoToEdit?.tipoPago;
    _selectedEstadoImpuestos = widget.pedidoToEdit?.estadoImpuestos;
    _selectedPdoPeriodoFacturacion = widget.pedidoToEdit?.pdoPeriodoFacturacion;
    _selectedPdoPersonaId = widget.pedidoToEdit?.pdoPersonaId;
    _selectedEstadoPedido = widget.pedidoToEdit?.estadoPedido ?? EstadoPedido.pendiente;

    if (widget.pedidoToEdit != null) {
      _detallesPedido = List<PedidoDetalle>.from(widget.pedidoToEdit!.detalles.map((d) => d.copyWith()));
    }

    // TODO: Listeners para recalcular totales
  }

  @override
  void dispose() {
    // Dispose todos los controllers
    _pedidoIdController.dispose();
    _fechaPedidoController.dispose();
    _fechaEnvioController.dispose();
    _fechaPagoController.dispose();
    _gastosEnvioController.dispose();
    _tipoImpositivoController.dispose();
    _notasController.dispose();
    _nombreEnvioController.dispose();
    _direccionEnvioController.dispose();
    _ciudadEnvioController.dispose();
    _codigoPostalEnvioController.dispose();
    _paisEnvioController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, Function(DateTime) onDateSelected) async {
    DateTime initial = DateTime.now();
    if (controller.text.isNotEmpty) {
      try {
        initial = DateFormat('dd/MM/yyyy').parse(controller.text);
      } catch (e) { /* usa DateTime.now() */ }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _savePedido() {
    if (_formKey.currentState!.validate()) {
      // TODO: Lógica de validación de fechas (pedido <= envio <= pago)
      // TODO: Lógica de validación de dirección si es con envío

      final pedido = Pedido(
        pedidoId: _pedidoIdController.text.isNotEmpty ? _pedidoIdController.text : null,
        fechaPedido: _selectedFechaPedido!,
        empleadoId: _selectedEmpleadoId!, // Asumir que se seleccionó
        clienteId: _selectedClienteId!,   // Asumir que se seleccionó
        fechaEnvio: _selectedFechaEnvio,
        fechaPago: _selectedFechaPago,
        estadoPedido: _selectedEstadoPedido,
        transportistaId: _selectedTransportistaId,
        nombreEnvio: _nombreEnvioController.text,
        direccionEnvio: _direccionEnvioController.text,
        ciudadMunicipioDest: _ciudadEnvioController.text,
        codigoPostalDest: _codigoPostalEnvioController.text,
        paisDest: _paisEnvioController.text,
        tipoPago: _selectedTipoPago,
        tipoImpositivo: double.tryParse(_tipoImpositivoController.text),
        estadoImpuestos: _selectedEstadoImpuestos,
        detalles: _detallesPedido,
        gastosEnvio: double.tryParse(_gastosEnvioController.text) ?? 0.0,
        notas: _notasController.text,
        pdoPeriodoFacturacion: _selectedPdoPeriodoFacturacion,
        pdoPersonaId: _selectedPdoPersonaId,
      );

      print('Guardando pedido: ${pedido.pedidoId}');
      // TODO: Llamar a servicio/provider para guardar
      Navigator.of(context).pop(true); // Indicar que se guardó
    }
  }

   Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.pedidoToEdit == null ? 'Registrar Pedido' : 'Editar Pedido',
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
      ],
    );
  }

  // Placeholder para la sección de detalles del pedido
  Widget _buildDetallesPedidoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Productos del Pedido', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
        const SizedBox(height: Spacing.sm),
        // TODO: Implementar UI para añadir/editar/listar PedidoDetalle
        // Esto podría ser un ListView.builder de los _detallesPedido
        // con campos para producto, cantidad, precio, descuento y un botón para añadir nuevo.
        if (_detallesPedido.isEmpty)
          const Text('No hay productos añadidos.'),
        ..._detallesPedido.map((detalle) => ListTile(
          title: Text('${detalle.productoNombre} (x${detalle.cantidad})'),
          subtitle: Text('Precio: ${detalle.precioUnitario.toStringAsFixed(2)}, Total: ${detalle.totalLinea.toStringAsFixed(2)}'),
          // TODO: Añadir botones para editar/eliminar detalle
        )).toList(),
        const SizedBox(height: Spacing.sm),
        AppButton(text: 'Añadir Producto', onPressed: () { /* TODO: Mostrar diálogo para añadir producto */ }),
        const SizedBox(height: Spacing.md),
      ],
    );
  }

  // Placeholder para la sección de totales
  Widget _buildTotalesSection() {
    // TODO: Estos valores deberían actualizarse en tiempo real
    double subtotal = 0;
    double descuentos = 0;
    double impuestos = 0;
    double total = 0;

    if (widget.pedidoToEdit != null) { // O calcular desde _detallesPedido y otros campos
        subtotal = widget.pedidoToEdit!.subtotalBruto;
        descuentos = widget.pedidoToEdit!.totalDescuentos;
        impuestos = widget.pedidoToEdit!.montoImpuestos;
        total = widget.pedidoToEdit!.totalNeto;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen del Pedido', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
        Text('Subtotal Bruto: ${subtotal.toStringAsFixed(2)}'),
        Text('Total Descuentos: ${descuentos.toStringAsFixed(2)}'),
        Text('Impuestos: ${impuestos.toStringAsFixed(2)}'),
        AppInput(label: 'Gastos de Envío', controller: _gastosEnvioController, keyboardType: TextInputType.number),
        const Divider(),
        Text('TOTAL NETO: ${total.toStringAsFixed(2)}', style: AppTypography.h2.copyWith(color: AppTheme.primaryColor)),
        const SizedBox(height: Spacing.md),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final title = widget.pedidoToEdit == null ? 'Registrar Nuevo Pedido' : 'Editar Pedido';

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
                title: _buildHeader(),
                toolbarHeight: 80,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
                      const SizedBox(height: Spacing.md),

                      // --- Sección Datos Generales ---
                      Text('Datos Generales', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
                      AppInput(label: 'ID Pedido (Autogenerado)', controller: _pedidoIdController, readOnly: true),
                      AppInput(label: 'Fecha Pedido*', controller: _fechaPedidoController, readOnly: true, onTap: () => _selectDate(context, _fechaPedidoController, (date) => _selectedFechaPedido = date), validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                      AppSelect<String>(label: 'Empleado*', value: _selectedEmpleadoId, options: _empleadoOptions, labelBuilder: (v) => v, onChanged: (val) => setState(() => _selectedEmpleadoId = val), validator: (v) => v == null ? 'Campo requerido' : null, hint: const Text("Seleccionar empleado")),
                      AppSelect<String>(label: 'Cliente*', value: _selectedClienteId, options: _clienteOptions, labelBuilder: (v) => v, onChanged: (val) => setState(() => _selectedClienteId = val), validator: (v) => v == null ? 'Campo requerido' : null, hint: const Text("Seleccionar cliente")),
                      AppSelect<EstadoPedido>(label: 'Estado Pedido*', value: _selectedEstadoPedido, options: EstadoPedido.values, labelBuilder: (v) => estadoPedidoToString(v), onChanged: (val) => setState(() => _selectedEstadoPedido = val!), validator: (v) => v == null ? 'Campo requerido' : null),
                      const SizedBox(height: Spacing.lg),

                      // --- Sección Detalles del Pedido ---
                      _buildDetallesPedidoSection(),
                      const SizedBox(height: Spacing.lg),

                      // --- Sección Datos de Envío ---
                      Text('Datos de Envío', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
                      AppInput(label: 'Fecha Envío', controller: _fechaEnvioController, readOnly: true, onTap: () => _selectDate(context, _fechaEnvioController, (date) => _selectedFechaEnvio = date)),
                      AppSelect<String>(label: 'Transportista', value: _selectedTransportistaId, options: _transportistaOptions, labelBuilder: (v) => v, onChanged: (val) => setState(() => _selectedTransportistaId = val), hint: const Text("Seleccionar transportista")),
                      AppInput(label: 'Nombre Envío (Recibe)', controller: _nombreEnvioController),
                      AppInput(label: 'Dirección Envío', controller: _direccionEnvioController),
                      AppInput(label: 'Ciudad/Municipio Destino', controller: _ciudadEnvioController),
                      AppInput(label: 'Código Postal Destino', controller: _codigoPostalEnvioController),
                      AppInput(label: 'País Destino', controller: _paisEnvioController),
                      const SizedBox(height: Spacing.lg),

                      // --- Sección Datos de Facturación ---
                      Text('Datos de Facturación', style: AppTypography.h2.copyWith(color: AppTheme.textPrimaryColor)),
                      AppInput(label: 'Fecha Pago', controller: _fechaPagoController, readOnly: true, onTap: () => _selectDate(context, _fechaPagoController, (date) => _selectedFechaPago = date)),
                      AppSelect<String>(label: 'Tipo de Pago', value: _selectedTipoPago, options: _tipoPagoOptions, labelBuilder: (v) => v, onChanged: (val) => setState(() => _selectedTipoPago = val), hint: const Text("Seleccionar tipo de pago")),
                      AppInput(label: 'Tipo Impositivo (%)', controller: _tipoImpositivoController, keyboardType: TextInputType.number),
                      AppSelect<String>(label: 'Estado Impuestos', value: _selectedEstadoImpuestos, options: _estadoImpuestosOptions, labelBuilder: (v) => v, onChanged: (val) => setState(() => _selectedEstadoImpuestos = val), hint: const Text("Seleccionar estado")),
                      AppSelect<String>(label: 'Período Facturación (PDO)', value: _selectedPdoPeriodoFacturacion, options: _periodoFacturacionOptions, labelBuilder: (v) => v, onChanged: (val) => setState(() => _selectedPdoPeriodoFacturacion = val), hint: const Text("Seleccionar período")),
                      // AppSelect para PDO_PERSONA_ID (podría ser la misma lista de clientes o empleados)
                      const SizedBox(height: Spacing.lg),

                       // --- Sección Totales y Notas ---
                      _buildTotalesSection(),
                      AppInput(label: 'Notas Adicionales', controller: _notasController, maxLines: 3),
                      const SizedBox(height: Spacing.xl),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
                          const SizedBox(width: Spacing.md),
                          AppButton(text: 'Guardar Pedido', onPressed: _savePedido),
                        ],
                      ),
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