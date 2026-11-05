import 'dart:convert';

/// Datos de prueba que imitan las respuestas de la Rick and Morty API.
class SampleData {
  /// Un personaje en formato JSON, tal como lo envía la API.
  static Map<String, dynamic> character(int id, String name) {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': 'Alive',
      'species': 'Human',
      'gender': 'Male',
      'origin': <String, dynamic>{'name': 'Earth (C-137)', 'url': ''},
      'location': <String, dynamic>{'name': 'Citadel of Ricks', 'url': ''},
      'image': 'https://rickandmortyapi.com/api/character/avatar/$id.jpeg',
    };
  }

  /// Respuesta de lista completa (con `info` y `results`) como texto JSON.
  static String listResponse(List<Map<String, dynamic>> characters) {
    return jsonEncode(<String, dynamic>{
      'info': <String, dynamic>{
        'count': characters.length,
        'pages': 1,
        'next': null,
        'prev': null,
      },
      'results': characters,
    });
  }
}
