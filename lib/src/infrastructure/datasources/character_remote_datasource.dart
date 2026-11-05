import 'package:remote_data_kit/src/domain/datasources/character_datasource.dart';
import 'package:remote_data_kit/src/domain/entities/character.dart';
import 'package:remote_data_kit/src/domain/errors/api_exception.dart';
import 'package:remote_data_kit/src/domain/result/result.dart';
import 'package:remote_data_kit/src/infrastructure/client/remote_client.dart';
import 'package:remote_data_kit/src/infrastructure/mappers/character_mapper.dart';
import 'package:remote_data_kit/src/infrastructure/models/character_model.dart';

/// Obtiene personajes de la Rick and Morty API usando un [RemoteClient].
class CharacterRemoteDataSource implements CharacterDataSourceInterface {
  /// Crea la fuente de datos con el [RemoteClient] que hará las peticiones.
  CharacterRemoteDataSource(this._client);

  final RemoteClient _client;

  static const String _host = 'rickandmortyapi.com';
  static const String _path = '/api/character';

  @override
  Future<Result<List<Character>>> getCharacters({String name = ''}) async {
    final String query = name.trim();
    final Uri uri = Uri.https(
      _host,
      _path,
      query.isEmpty ? null : <String, String>{'name': query},
    );

    final Result<Map<String, dynamic>> result = await _client.getJson(uri);

    return switch (result) {
      Success<Map<String, dynamic>>(:final Map<String, dynamic> data) =>
        _parse(data),
      Failure<Map<String, dynamic>>(:final ApiException error) =>
        _handleFailure(error),
    };
  }

  Result<List<Character>> _parse(Map<String, dynamic> body) {
    try {
      final List<dynamic> results = body['results'] as List<dynamic>;
      final List<Character> characters = results
          .map<Character>(
            (dynamic item) => CharacterMapper.modelToEntity(
              CharacterModel.fromJson(item as Map<String, dynamic>),
            ),
          )
          .toList();
      return Success<List<Character>>(characters);
    } on TypeError {
      return const Failure<List<Character>>(
        ApiException('Los datos recibidos tienen un formato inesperado.'),
      );
    }
  }

  Result<List<Character>> _handleFailure(ApiException error) {
    // Esta API responde 404 cuando una búsqueda no tiene coincidencias:
    // no es un error, es una lista vacía.
    if (error.statusCode == 404) {
      return Success<List<Character>>(<Character>[]);
    }
    return Failure<List<Character>>(error);
  }
}
