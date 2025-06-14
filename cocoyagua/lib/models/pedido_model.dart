import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum EstadoPedido {
  pendiente,
  enPreparacion,
  enviado,
  entregado,
  cancelado,
  facturado, // Adicional para integración
}

String estadoPedidoToString(EstadoPedido estado) {
  switch (estado) {
    case EstadoPedido.pendiente:
      return 'Pendiente';
    case EstadoPedido.enPreparacion:
      return 'En Preparación';
    case EstadoPedido.enviado:
      return 'Enviado';
    case EstadoPedido.entregado:
      return 'Entregado';
    case EstadoPedido.cancelado:
      return 'Cancelado';
    case EstadoPedido.facturado:
      return 'Facturado';
  }
}

EstadoPedido stringToEstadoPedido(String s) {
  // Considerar hacer esto case-insensitive si los datos pueden variar
  if (s == 'Pendiente') return EstadoPedido.pendiente;
  if (s == 'En Preparación') return EstadoPedido.enPreparacion;
  if (s == 'Enviado') return EstadoPedido.enviado;
  if (s == 'Entregado') return EstadoPedido.entregado;
  if (s == 'Cancelado') return EstadoPedido.cancelado;
  if (s == 'Facturado') return EstadoPedido.facturado;
  return EstadoPedido.pendiente; // Default
}

class PedidoDetalle {
  final String pedidoDetalleId;
  final String productoId;
  final String productoNombre; // Para mostrar en el form y detalles
  int cantidad;
  double precioUnitario;
  double? descuentoPorcentaje; // Ej: 0.1 para 10%
  String? situacionId; // Estado del item específico

  PedidoDetalle({
    String? pedidoDetalleId,
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
    this.descuentoPorcentaje,
    this.situacionId,
  }) : pedidoDetalleId = pedidoDetalleId ?? const Uuid().v4();

  double get subtotalLinea => cantidad * precioUnitario;
  double get descuentoAplicadoLinea =>
      subtotalLinea * (descuentoPorcentaje ?? 0);
  double get totalLinea => subtotalLinea - descuentoAplicadoLinea;

  PedidoDetalle copyWith({
    String? pedidoDetalleId,
    String? productoId,
    String? productoNombre,
    int? cantidad,
    double? precioUnitario,
    ValueGetter<double?>? descuentoPorcentaje,
    ValueGetter<String?>? situacionId,
  }) {
    return PedidoDetalle(
      pedidoDetalleId: pedidoDetalleId ?? this.pedidoDetalleId,
      productoId: productoId ?? this.productoId,
      productoNombre: productoNombre ?? this.productoNombre,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      descuentoPorcentaje: descuentoPorcentaje != null ? descuentoPorcentaje() : this.descuentoPorcentaje,
      situacionId: situacionId != null ? situacionId() : this.situacionId,
    );
  }
}

class Pedido {
  final String pedidoId;
  final DateTime fechaPedido;
  DateTime? fechaEnvio;
  DateTime? fechaPago;
  final String empleadoId;
  final String clienteId; // Nombre o ID del cliente
  EstadoPedido estadoPedido;

  // Datos de envío
  String? transportistaId;
  String? nombreEnvio; // Persona que recibe
  String? direccionEnvio;
  String? ciudadMunicipioDest;
  String? codigoPostalDest;
  String? paisDest;

  // Datos de facturación
  String? tipoPago; // Ej: 'Efectivo', 'Tarjeta'
  double? tipoImpositivo; // Ej: 0.18 para 18% IVA
  String? estadoImpuestos; // Ej: 'Pendiente', 'Pagado'

  List<PedidoDetalle> detalles;
  double gastosEnvio;
  String? notas;
  String? pdoPeriodoFacturacion; // Para integración con módulo de Facturación
  String? pdoPersonaId; // Podría ser el mismo clienteId o un contacto diferente

  Pedido({
    String? pedidoId,
    required this.fechaPedido,
    this.fechaEnvio,
    this.fechaPago,
    required this.empleadoId,
    required this.clienteId,
    this.estadoPedido = EstadoPedido.pendiente,
    this.transportistaId,
    this.nombreEnvio,
    this.direccionEnvio,
    this.ciudadMunicipioDest,
    this.codigoPostalDest,
    this.paisDest,
    this.tipoPago,
    this.tipoImpositivo,
    this.estadoImpuestos,
    List<PedidoDetalle>? detalles,
    this.gastosEnvio = 0.0,
    this.notas,
    this.pdoPeriodoFacturacion,
    this.pdoPersonaId,
  })  : pedidoId = pedidoId ?? const Uuid().v4(),
        detalles = detalles ?? [];

  double get subtotalBruto {
    return detalles.fold(0.0, (sum, item) => sum + item.subtotalLinea);
  }

  double get totalDescuentos {
    return detalles.fold(
        0.0, (sum, item) => sum + item.descuentoAplicadoLinea);
  }

  double get montoImpuestos {
    final baseImponible = subtotalBruto - totalDescuentos;
    return baseImponible * (tipoImpositivo ?? 0.0);
  }

  double get totalNeto {
    return (subtotalBruto - totalDescuentos) + montoImpuestos + gastosEnvio;
  }

  // copyWith y otros métodos según necesidad
   Pedido copyWith({
    String? pedidoId,
    // ... otros campos
    List<PedidoDetalle>? detalles,
    // ... otros campos
  }) {
    return Pedido(
      pedidoId: pedidoId ?? this.pedidoId,
      fechaPedido: fechaPedido, // Asume que estos no cambian o se pasan explícitamente
      empleadoId: empleadoId,
      clienteId: clienteId,
      // ... copia todos los demás campos
      detalles: detalles ?? List<PedidoDetalle>.from(this.detalles.map((d) => d.copyWith())), // Copia profunda de detalles
      // ... copia todos los demás campos
    );
  }
}