class ContratoModel {
  final String id; // CONTRATO_ID
  final DateTime fechaContrato;
  final DateTime? fechaFinalizacion;
  final String clienteId;
  final String? clienteNombre; // Para mostrar en listas, opcional
  final String titularId; // TOMADOTITULAR_ID
  final String? titularNombre; // Para mostrar en listas, opcional
  final String tomaDomiciliariaId;
  final String? medidorId; // MEDIDOR_ID
  final String? asignacionMedidorId; // ASIGNACIONMEDIDOR_ID
  final String empleadoId;
  final String estado; // Ej: 'Activo', 'Finalizado', 'Suspendido'
  final String? documentoImpresoId;
  // Campos adicionales que podrían ser útiles para la lógica de negocio o visualización
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  ContratoModel({
    required this.id,
    required this.fechaContrato,
    this.fechaFinalizacion,
    required this.clienteId,
    this.clienteNombre,
    required this.titularId,
    this.titularNombre,
    required this.tomaDomiciliariaId,
    this.medidorId,
    this.asignacionMedidorId,
    required this.empleadoId,
    required this.estado,
    this.documentoImpresoId,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  // TODO: Implementar fromJson y toJson si se interactúa con una API
  // factory ContratoModel.fromJson(Map<String, dynamic> json) => ...
  // Map<String, dynamic> toJson() => ...

  // Método de copia para facilitar actualizaciones
  ContratoModel copyWith({
    String? id,
    DateTime? fechaContrato,
    DateTime? fechaFinalizacion,
    String? clienteId,
    String? clienteNombre,
    String? titularId,
    String? titularNombre,
    String? tomaDomiciliariaId,
    String? medidorId,
    String? asignacionMedidorId,
    String? empleadoId,
    String? estado,
    String? documentoImpresoId,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return ContratoModel(
      id: id ?? this.id,
      fechaContrato: fechaContrato ?? this.fechaContrato,
      fechaFinalizacion: fechaFinalizacion ?? this.fechaFinalizacion,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      titularId: titularId ?? this.titularId,
      titularNombre: titularNombre ?? this.titularNombre,
      tomaDomiciliariaId: tomaDomiciliariaId ?? this.tomaDomiciliariaId,
      medidorId: medidorId ?? this.medidorId,
      asignacionMedidorId: asignacionMedidorId ?? this.asignacionMedidorId,
      empleadoId: empleadoId ?? this.empleadoId,
      estado: estado ?? this.estado,
      documentoImpresoId: documentoImpresoId ?? this.documentoImpresoId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
