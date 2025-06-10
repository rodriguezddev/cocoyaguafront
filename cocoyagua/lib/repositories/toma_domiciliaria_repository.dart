// import 'dart:math';

// import '../models/toma_domiciliaria.dart';

// class TomaDomiciliariaRepository {
//   // Simulación de una base de datos en memoria o un servicio backend.
//   // En una aplicación real, esto interactuaría con una API o una BD.
//   final Map<String, TomaDomiciliaria> _tomasStorage = {};
//   final Random _random = Random();

//   Future<TomaDomiciliaria> createTomaDomiciliaria(
//       TomaDomiciliaria toma) async {
//     // Simula una demora de red/base de datos
//     await Future.delayed(const Duration(seconds: 1));

//     // Genera un ID único (simulado)
//     final newId = DateTime.now().millisecondsSinceEpoch.toString() +
//         _random.nextInt(9999).toString();
    
//     final tomaConId = toma.copyWith(
//       id: newId,
//       fechaRegistro: toma.fechaRegistro ?? DateTime.now(), // Asegura que la fecha de registro esté presente
//       estado: toma.estado, // El estado ya debería estar seteado por el provider
//     );

//     _tomasStorage[newId] = tomaConId;
//     print('Toma Domiciliaria Guardada en Repositorio (simulado): ${tomaConId.toJson()}');
//     return tomaConId;
//   }

//   Future<TomaDomiciliaria?> getTomaDomiciliariaById(String id) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return _tomasStorage[id];
//   }

//   Future<TomaDomiciliaria> updateTomaDomiciliaria(
//       TomaDomiciliaria toma) async {
//     await Future.delayed(const Duration(seconds: 1));
//     if (toma.id == null || !_tomasStorage.containsKey(toma.id)) {
//       throw Exception(
//           'Toma domiciliaria no encontrada para actualizar o ID es nulo.');
//     }
//     _tomasStorage[toma.id!] = toma;
//     print('Toma Domiciliaria Actualizada en Repositorio (simulado): ${toma.toJson()}');
//     return toma;
//   }
// }