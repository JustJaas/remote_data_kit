import 'package:remote_data_kit/src/domain/entities/character.dart';
import 'package:remote_data_kit/src/domain/result/result.dart';

/// Contrato del repositorio de personajes
abstract class CharacterRepositoryInterface {
  /// Devuelve los personajes de la primera página (hasta 20).
  ///
  /// Si se indica [name], se filtra por nombre. Si la búsqueda no tiene
  /// coincidencias, devuelve un [Success] con una lista vacía (no es un
  /// error). Ante cualquier fallo devuelve un [Failure].
  Future<Result<List<Character>>> getCharacters({String name = ''});
}
