// lib/providers/toma_domiciliaria_provider.dart

import 'package:flutter/material.dart';
import '../models/toma_domiciliaria.dart';
import '../services/toma_domiciliaria_service.dart';

class TomaDomiciliariaProvider extends ChangeNotifier {
  final TomaDomiciliaria _toma = TomaDomiciliaria();

  TomaDomiciliaria get toma => _toma;

  void setUsoSuministro(String uso) {
    _toma.usoSuministro = uso;
    notifyListeners();
  }

  void setUbicacion({required String direccion, required String coordenadas}) {
    _toma.ubicacion = direccion;
    _toma.coordenadas = coordenadas;
    notifyListeners();
  }

  void setClaveCatastral(String clave) {
    _toma.claveCatastral = clave;
    notifyListeners();
  }

  Future<bool> saveTomaDomiciliaria() async {
    try {
      return await TomaDomiciliariaService().guardarToma(_toma);
    } catch (e) {
      debugPrint('Error al guardar toma domiciliaria: \$e');
      return false;
    }
  }
}
