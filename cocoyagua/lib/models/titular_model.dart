class TitularModel {
  final String id; // TOMADOTITULAR_ID
  final String clienteId; // TTDM_CLIENTE_ID (Referencia a Cliente)
  final String
      tomaDomiciliariaId; // TTDM_TOMADOMICILIARIA_ID (Referencia a TomaDomiciliaria)
  final String empleadoId; // TTDM_EMPLEADO_ID (Referencia a Empleado)

  // Documento de propiedad
  final String tipoDocumentoPropiedad; // TIPODOCUMENTO_PROPIEDAD
  final String numeroDocumentoPropiedad; // NUMERODOCUMENTO_PROPIEDAD

  final String claveCatastral; // TTDM_CLAVE_CATASTRAL
  final DateTime fechaAsignacion; // FECHA_ASIGNACION
  final String estadoGeneral; // ESTADO (Podría ser 'Activo', 'Inactivo')
  final String
      estadoRegistro; // TTDM_ESTADOREGISTRO (Más específico, ej: 'Vigente', 'Suspendido por deuda')
  final String? verificacionId; // TTDM_VERIFICACIONID (Opcional)
  final DateTime? fechaUltimaFactura; // TTDM_FECHA_ULTIMAFACTURA (Opcional)
  final String
      tipoFacturacion; // TTDM_TIPO_FACTURACION (Ej: 'Residencial', 'Comercial')
  final bool cambioCliente; // CAMBIO_CLIENTE

  // Para la UI, podríamos querer tener los nombres en lugar de solo IDs
  final String? clienteNombre;
  final String? tomaDescripcion; // o algún identificador de la toma

  TitularModel({
    required this.id,
    required this.clienteId,
    required this.tomaDomiciliariaId,
    required this.empleadoId,
    required this.tipoDocumentoPropiedad,
    required this.numeroDocumentoPropiedad,
    required this.claveCatastral,
    required this.fechaAsignacion,
    required this.estadoGeneral,
    required this.estadoRegistro,
    this.verificacionId,
    this.fechaUltimaFactura,
    required this.tipoFacturacion,
    required this.cambioCliente,
    this.clienteNombre,
    this.tomaDescripcion,
  });

  // Método copyWith para facilitar la actualización de instancias
  TitularModel copyWith({
    String? id,
    // ...otros campos...
    String? estadoRegistro,
    String? tipoFacturacion,
  }) {
    return TitularModel(
      id: id ?? this.id,
      // ...copiar todos los demás campos...
      clienteId: clienteId,
      tomaDomiciliariaId: tomaDomiciliariaId,
      empleadoId: empleadoId,
      tipoDocumentoPropiedad: tipoDocumentoPropiedad,
      numeroDocumentoPropiedad: numeroDocumentoPropiedad,
      claveCatastral: claveCatastral,
      fechaAsignacion: fechaAsignacion,
      estadoGeneral: estadoGeneral,
      verificacionId: verificacionId,
      fechaUltimaFactura: fechaUltimaFactura,
      cambioCliente: cambioCliente,
      clienteNombre: clienteNombre,
      tomaDescripcion: tomaDescripcion,
      estadoRegistro: estadoRegistro ?? this.estadoRegistro,
      tipoFacturacion: tipoFacturacion ?? this.tipoFacturacion,
    );
  }
}
