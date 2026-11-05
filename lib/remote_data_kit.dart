/// Cliente HTTP y acceso a la Rick and Morty API con manejo de errores simple.
///
/// Ninguna operación lanza excepciones: todas devuelven un [Result], que es
/// un [Success] con el dato o un [Failure] con un [ApiException].
///
/// Ejemplo:
///
/// ```dart
/// final CharacterRepositoryImpl repository = CharacterRepositoryImpl();
/// final Result<List<Character>> result =
///     await repository.getCharacters(name: 'morty');
///
/// switch (result) {
///   case Success<List<Character>>(:final List<Character> data):
///     print('Encontrados: ${data.length}');
///   case Failure<List<Character>>(:final ApiException error):
///     print(error.message);
/// }
/// ```
library;

export 'src/domain/entities/character.dart';
export 'src/domain/errors/api_exception.dart';
export 'src/domain/repositories/character_repository.dart';
export 'src/domain/result/result.dart';
export 'src/infrastructure/client/remote_client.dart';
export 'src/infrastructure/repositories/character_repository_impl.dart';
