/// Datos de un personaje tal como los envía la API (formato JSON).
///
/// Su única responsabilidad es leer el JSON. La conversión a la entidad del
/// dominio la hace `CharacterMapper`.
class CharacterModel {
  /// Crea un modelo con todos sus datos.
  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.image,
  });

  /// Crea un modelo a partir del JSON que devuelve la API.
  ///
  /// Si falta algún campo se usa un valor por defecto, para que un dato
  /// ausente no rompa la app.
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    // origin y location vienen anidados: {"name": "...", "url": "..."}
    final Map<String, dynamic>? origin = json['origin'] as Map<String, dynamic>?;
    final Map<String, dynamic>? location =
        json['location'] as Map<String, dynamic>?;

    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Desconocido',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? 'unknown',
      gender: json['gender'] as String? ?? 'unknown',
      originName: origin?['name'] as String? ?? 'unknown',
      locationName: location?['name'] as String? ?? 'unknown',
      image: json['image'] as String? ?? '',
    );
  }

  /// Identificador único del personaje.
  final int id;

  /// Nombre del personaje.
  final String name;

  /// Estado del personaje.
  final String status;

  /// Especie del personaje.
  final String species;

  /// Género del personaje.
  final String gender;

  /// Nombre del lugar de origen.
  final String originName;

  /// Nombre de la última ubicación conocida.
  final String locationName;

  /// URL de la imagen del personaje.
  final String image;
}
