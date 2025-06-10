class SolicitudBaja {
  final String id;
  final DateTime fechaSolicitud;
  final String clienteId; // Referencia externa (ID del cliente)
  final String titularId; // Referencia externa (ID del titular)
  final String tomaDomiciliariaId;
  final String descripcionMotivo;
  String estado; // Ej: 'Pendiente', 'Aprobada', 'Rechazada', 'Completada'

  SolicitudBaja({
    required this.id,
    required this.fechaSolicitud,
    required this.clienteId,
    required this.titularId,
    required this.tomaDomiciliariaId,
    required this.descripcionMotivo,
    required this.estado,
  });

  // Puedes agregar copyWith, toJson, fromJson si es necesario para la persistencia
  SolicitudBaja copyWith({String? estado}) {
    return SolicitudBaja(
      // ...copiar otros campos...
      id: id,
      fechaSolicitud: fechaSolicitud,
      clienteId: clienteId,
      titularId: titularId,
      tomaDomiciliariaId: tomaDomiciliariaId,
      descripcionMotivo: descripcionMotivo,
      estado: estado ?? this.estado,
    );
  }
}
