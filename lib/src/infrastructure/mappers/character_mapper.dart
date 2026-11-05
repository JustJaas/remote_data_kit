import 'package:remote_data_kit/src/domain/entities/character.dart';
import 'package:remote_data_kit/src/infrastructure/models/character_model.dart';

/// Traductor entre el formato de la API y el dominio.
///
/// Su única responsabilidad es convertir un [CharacterModel] en un
/// [Character].
class CharacterMapper {
  /// Convierte un [model] en la entidad [Character] del dominio.
  static Character modelToEntity(CharacterModel model) {
    return Character(
      id: model.id,
      name: model.name,
      status: model.status,
      species: model.species,
      gender: model.gender,
      originName: model.originName,
      locationName: model.locationName,
      image: model.image,
    );
  }
}
