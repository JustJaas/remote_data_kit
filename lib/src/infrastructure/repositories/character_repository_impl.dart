import 'package:remote_data_kit/src/domain/datasources/character_datasource.dart';
import 'package:remote_data_kit/src/domain/entities/character.dart';
import 'package:remote_data_kit/src/domain/repositories/character_repository.dart';
import 'package:remote_data_kit/src/domain/result/result.dart';
import 'package:remote_data_kit/src/infrastructure/client/remote_client.dart';
import 'package:remote_data_kit/src/infrastructure/datasources/character_remote_datasource.dart';

/// Forma clara de consultar [Rick and Morty API](https://rickandmortyapi.com/).
///
/// Implementa [CharacterRepositoryInterface]: quien lo use puede depender del
/// contrato y no de esta clase.
class CharacterRepositoryImpl implements CharacterRepositoryInterface {
  /// Crea el repositorio.
  ///
  /// Si no se pasa [client] se usa un [RemoteClient] con la configuración
  /// por defecto.
  CharacterRepositoryImpl({RemoteClient? client})
    : _client = client ?? RemoteClient();

  final RemoteClient _client;

  late final CharacterDataSourceInterface _dataSource =
      CharacterRemoteDataSource(_client);

  @override
  Future<Result<List<Character>>> getCharacters({String name = ''}) {
    return _dataSource.getCharacters(name: name);
  }

  /// Cierra el cliente y libera sus recursos.
  void close() => _client.close();
}
