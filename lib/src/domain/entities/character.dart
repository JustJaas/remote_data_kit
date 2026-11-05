/// Personaje de la Rick and Morty API.
///
/// Es una entidad simple
class Character {
  /// Crea un personaje con todos sus datos.
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.image,
  });

  /// Identificador único del personaje.
  final int id;

  /// Nombre del personaje.
  final String name;

  /// Estado: `Alive`, `Dead` o `unknown`.
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
