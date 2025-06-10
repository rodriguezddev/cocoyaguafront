// lib/models/toma_domiciliaria.dart

class TomaDomiciliaria {
  String usoSuministro;
  String ubicacion;
  String coordenadas;
  String claveCatastral;

  TomaDomiciliaria({
    this.usoSuministro = '',
    this.ubicacion = '',
    this.coordenadas = '',
    this.claveCatastral = '',
  });

  factory TomaDomiciliaria.fromJson(Map<String, dynamic> json) =>
      TomaDomiciliaria(
        usoSuministro: json['usoSuministro'] ?? '',
        ubicacion: json['ubicacion'] ?? '',
        coordenadas: json['coordenadas'] ?? '',
        claveCatastral: json['claveCatastral'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'usoSuministro': usoSuministro,
        'ubicacion': ubicacion,
        'coordenadas': coordenadas,
        'claveCatastral': claveCatastral,
      };

  bool get isComplete =>
      usoSuministro.isNotEmpty &&
      ubicacion.isNotEmpty &&
      coordenadas.isNotEmpty &&
      claveCatastral.isNotEmpty;
}
