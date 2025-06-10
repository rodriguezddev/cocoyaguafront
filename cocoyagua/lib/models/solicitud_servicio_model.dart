class SolicitudServicio {
  final String id;
  DateTime fechaSolicitud;
  DateTime? fechaAprobacion;

  // Datos personales
  String tipoPersona; // 'Natural', 'Jurídica'
  String tipoDocumento;
  String numeroDocumento;
  String nombres; // o Razón Social para Jurídica
  String apellidos; // Vacío para Jurídica
  String telefono;
  String correo;
  String? organizacion; // Opcional

  // Ubicación
  String provincia;
  String ciudad;
  String ubicacion1; // Dirección principal
  String ubicacion2; // Referencia adicional

  String tomaDomiciliariaId; // Referencia
  String estado; // 'Activo', 'En Revisión', 'Completado', 'Cancelado'

  SolicitudServicio({
    required this.id,
    required this.fechaSolicitud,
    this.fechaAprobacion,
    required this.tipoPersona,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.correo,
    this.organizacion,
    required this.provincia,
    required this.ciudad,
    required this.ubicacion1,
    required this.ubicacion2,
    required this.tomaDomiciliariaId,
    required this.estado,
  });

  // Puedes agregar copyWith, toJson, fromJson si es necesario
  SolicitudServicio copyWith({String? estado, DateTime? fechaAprobacion}) {
    return SolicitudServicio(
      // ...copiar otros campos...
      id: id,
      fechaSolicitud: fechaSolicitud,
      fechaAprobacion: fechaAprobacion ?? this.fechaAprobacion,
      tipoPersona: tipoPersona,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      nombres: nombres,
      apellidos: apellidos,
      telefono: telefono,
      correo: correo,
      organizacion: organizacion,
      provincia: provincia,
      ciudad: ciudad,
      ubicacion1: ubicacion1,
      ubicacion2: ubicacion2,
      tomaDomiciliariaId: tomaDomiciliariaId,
      estado: estado ?? this.estado,
    );
  }
}
