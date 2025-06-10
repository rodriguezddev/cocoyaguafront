class SolicitudConexion {
  final String id;
  final DateTime fechaSolicitud;
  final String direccion; // Podría ser un objeto AddressModel si se reutiliza
  final String descripcionRequerimiento;
  String estado; // Ej: 'Nueva', 'En Proceso', 'Instalada', 'Cancelada'

  SolicitudConexion({
    required this.id,
    required this.fechaSolicitud,
    required this.direccion,
    required this.descripcionRequerimiento,
    required this.estado,
  });

  // Puedes agregar copyWith, toJson, fromJson si es necesario
  SolicitudConexion copyWith({String? estado}) {
    return SolicitudConexion(
      // ...copiar otros campos...
      id: id,
      fechaSolicitud: fechaSolicitud,
      direccion: direccion,
      descripcionRequerimiento: descripcionRequerimiento,
      estado: estado ?? this.estado,
    );
  }
}
