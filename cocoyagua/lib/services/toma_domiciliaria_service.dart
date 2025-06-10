// lib/services/toma_domiciliaria_service.dart

import 'package:flutter/material.dart';
import '../models/toma_domiciliaria.dart';
import 'api_service.dart';

class TomaDomiciliariaService {
  final ApiService _api = ApiService();

  Future<bool> guardarToma(TomaDomiciliaria toma) async {
    try {
      final response = await _api.post('/tomas-domiciliarias', toma.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint('Error al guardar toma: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Excepción al guardar toma: $e');
      return false;
    }
  }
}
