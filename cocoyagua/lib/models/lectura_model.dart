import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum UnidadMedida { litros, m3, galones }

enum EstadoLectura { pendiente, realizada, facturada, anomala, anulada }

class Lectura {
  final String lecturaId;
  final DateTime fechaLectura;
  final String medidorId; // ID del medidor asociado
  final double lecturaAnterior;
  final double lecturaActual;
  final double? lecturaInicio; // Opcional
  final UnidadMedida unidadMedida;
  final String? productoId; // Opcional, si se gestionan varios servicios/productos
  final String empleadoId; // Quién toma la lectura
  final EstadoLectura estadoLectura;
  final String? observaciones; // Opcional

  Lectura({
    String? lecturaId,
    required this.fechaLectura,
    required this.medidorId,
    required this.lecturaAnterior,
    required this.lecturaActual,
    this.lecturaInicio,
    required this.unidadMedida,
    this.productoId,
    required this.empleadoId,
    required this.estadoLectura,
    this.observaciones,
  }) : lecturaId = lecturaId ?? const Uuid().v4();

  double get consumo =>
      (lecturaActual - lecturaAnterior) < 0
          ? 0
          : (lecturaActual - lecturaAnterior);

  Lectura copyWith({
    String? lecturaId,
    DateTime? fechaLectura,
    String? medidorId,
    double? lecturaAnterior,
    double? lecturaActual,
    ValueGetter<double?>? lecturaInicio,
    UnidadMedida? unidadMedida,
    ValueGetter<String?>? productoId,
    String? empleadoId,
    EstadoLectura? estadoLectura,
    ValueGetter<String?>? observaciones,
  }) {
    return Lectura(
      lecturaId: lecturaId ?? this.lecturaId,
      fechaLectura: fechaLectura ?? this.fechaLectura,
      medidorId: medidorId ?? this.medidorId,
      lecturaAnterior: lecturaAnterior ?? this.lecturaAnterior,
      lecturaActual: lecturaActual ?? this.lecturaActual,
      lecturaInicio: lecturaInicio != null ? lecturaInicio() : this.lecturaInicio,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      productoId: productoId != null ? productoId() : this.productoId,
      empleadoId: empleadoId ?? this.empleadoId,
      estadoLectura: estadoLectura ?? this.estadoLectura,
      observaciones: observaciones != null ? observaciones() : this.observaciones,
    );
  }
}

// Helper para convertir Enums a String para UI y viceversa
String unidadMedidaToString(UnidadMedida unidad) {
  switch (unidad) {
    case UnidadMedida.litros:
      return 'Litros';
    case UnidadMedida.m3:
      return 'm³';
    case UnidadMedida.galones:
      return 'Galones';
  }
}

UnidadMedida stringToUnidadMedida(String s) {
  if (s == 'Litros') return UnidadMedida.litros;
  if (s == 'm³') return UnidadMedida.m3;
  if (s == 'Galones') return UnidadMedida.galones;
  return UnidadMedida.m3; // Default
}

String estadoLecturaToString(EstadoLectura estado) {
  switch (estado) {
    case EstadoLectura.pendiente: return 'Pendiente';
    case EstadoLectura.realizada: return 'Realizada';
    case EstadoLectura.facturada: return 'Facturada';
    case EstadoLectura.anomala: return 'Anómala';
    case EstadoLectura.anulada: return 'Anulada';
  }
}

EstadoLectura stringToEstadoLectura(String s) {
  if (s == 'Pendiente') return EstadoLectura.pendiente;
  if (s == 'Realizada') return EstadoLectura.realizada;
  if (s == 'Facturada') return EstadoLectura.facturada;
  if (s == 'Anómala') return EstadoLectura.anomala;
  if (s == 'Anulada') return EstadoLectura.anulada;
  return EstadoLectura.pendiente; // Default
}