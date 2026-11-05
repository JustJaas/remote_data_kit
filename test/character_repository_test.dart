import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:remote_data_kit/remote_data_kit.dart';
import 'package:test/test.dart';

import 'helpers/sample_data.dart';

void main() {
  CharacterRepositoryImpl buildRepository(
    Future<http.Response> Function(http.Request request) handler,
  ) {
    return CharacterRepositoryImpl(
      client: RemoteClient(httpClient: MockClient(handler)),
    );
  }

  group('CharacterRepositoryImpl.getCharacters', () {
    test('devuelve Success con la lista de personajes', () async {
      final CharacterRepositoryImpl repository = buildRepository(
        (http.Request request) async {
          return http.Response(
            SampleData.listResponse(<Map<String, dynamic>>[
              SampleData.character(1, 'Rick Sanchez'),
              SampleData.character(2, 'Morty Smith'),
            ]),
            200,
          );
        },
      );

      final Result<List<Character>> result = await repository.getCharacters();

      expect(result, isA<Success<List<Character>>>());
      final List<Character> characters = (result as Success<List<Character>>).data;
      expect(characters, hasLength(2));
      expect(characters.first.name, 'Rick Sanchez');
      expect(characters.last.name, 'Morty Smith');
    });

    test('envía el parámetro name sin espacios sobrantes', () async {
      Uri? requestedUri;
      final CharacterRepositoryImpl repository = buildRepository(
        (http.Request request) async {
          requestedUri = request.url;
          return http.Response(
            SampleData.listResponse(<Map<String, dynamic>>[]),
            200,
          );
        },
      );

      await repository.getCharacters(name: '  morty  ');

      expect(requestedUri?.queryParameters['name'], 'morty');
    });

    test('no envía parámetros cuando la búsqueda está vacía', () async {
      Uri? requestedUri;
      final CharacterRepositoryImpl repository = buildRepository(
        (http.Request request) async {
          requestedUri = request.url;
          return http.Response(
            SampleData.listResponse(<Map<String, dynamic>>[]),
            200,
          );
        },
      );

      await repository.getCharacters();

      expect(requestedUri?.hasQuery, false);
    });

    test('devuelve Success con lista vacía cuando la API responde 404', () async {
      final CharacterRepositoryImpl repository = buildRepository(
        (http.Request request) async {
          return http.Response('{"error":"There is nothing here"}', 404);
        },
      );

      final Result<List<Character>> result =
          await repository.getCharacters(name: 'zzzz');

      expect(
        result,
        isA<Success<List<Character>>>().having(
          (Success<List<Character>> success) => success.data,
          'data',
          isEmpty,
        ),
      );
    });

    test('devuelve Failure ante otros errores del servidor', () async {
      final CharacterRepositoryImpl repository = buildRepository(
        (http.Request request) async => http.Response('error', 500),
      );

      final Result<List<Character>> result = await repository.getCharacters();

      expect(
        result,
        isA<Failure<List<Character>>>().having(
          (Failure<List<Character>> failure) => failure.error.statusCode,
          'statusCode',
          500,
        ),
      );
    });

    test('devuelve Failure si la respuesta no trae la lista esperada', () async {
      final CharacterRepositoryImpl repository = buildRepository(
        (http.Request request) async => http.Response('{"otra": []}', 200),
      );

      final Result<List<Character>> result = await repository.getCharacters();

      expect(
        result,
        isA<Failure<List<Character>>>().having(
          (Failure<List<Character>> failure) => failure.error.message,
          'message',
          contains('formato inesperado'),
        ),
      );
    });
  });
}
