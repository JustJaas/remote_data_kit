import 'package:remote_data_kit/src/domain/entities/character.dart';
import 'package:remote_data_kit/src/domain/result/result.dart';

/// Contrato de la fuente de datos de personajes
abstract class CharacterDataSourceInterface {
  /// Obtiene personajes, opcionalmente filtrados por [name].
  Future<Result<List<Character>>> getCharacters({String name = ''});
}
