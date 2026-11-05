import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:remote_data_kit/remote_data_kit.dart';
import 'package:test/test.dart';

void main() {
  final Uri uri = Uri.parse('https://example.com/data');

  group('RemoteClient.getJson', () {
    test('devuelve Success con el JSON decodificado cuando responde 200', () async {
      final RemoteClient client = RemoteClient(
        httpClient: MockClient((http.Request request) async {
          return http.Response(jsonEncode(<String, dynamic>{'ok': true}), 200);
        }),
      );

      final Result<Map<String, dynamic>> result = await client.getJson(uri);

      expect(
        result,
        isA<Success<Map<String, dynamic>>>().having(
          (Success<Map<String, dynamic>> success) => success.data['ok'],
          'data.ok',
          true,
        ),
      );
    });

    test('devuelve Failure con el statusCode cuando el servidor responde con error', () async {
      final RemoteClient client = RemoteClient(
        httpClient: MockClient((http.Request request) async {
          return http.Response('error', 500);
        }),
      );

      final Result<Map<String, dynamic>> result = await client.getJson(uri);

      expect(
        result,
        isA<Failure<Map<String, dynamic>>>().having(
          (Failure<Map<String, dynamic>> failure) => failure.error.statusCode,
          'statusCode',
          500,
        ),
      );
    });

    test('traduce la falta de conexión a un mensaje legible', () async {
      final RemoteClient client = RemoteClient(
        httpClient: MockClient((http.Request request) async {
          throw const SocketException('sin red');
        }),
      );

      final Result<Map<String, dynamic>> result = await client.getJson(uri);

      expect(
        result,
        isA<Failure<Map<String, dynamic>>>().having(
          (Failure<Map<String, dynamic>> failure) => failure.error.message,
          'message',
          'Sin conexión a internet.',
        ),
      );
    });

    test('devuelve Failure cuando se agota el tiempo de espera', () async {
      final RemoteClient client = RemoteClient(
        timeout: const Duration(milliseconds: 10),
        httpClient: MockClient((http.Request request) async {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          return http.Response('{}', 200);
        }),
      );

      final Result<Map<String, dynamic>> result = await client.getJson(uri);

      expect(
        result,
        isA<Failure<Map<String, dynamic>>>().having(
          (Failure<Map<String, dynamic>> failure) => failure.error.message,
          'message',
          contains('tardó demasiado'),
        ),
      );
    });

    test('devuelve Failure cuando el cuerpo no es JSON válido', () async {
      final RemoteClient client = RemoteClient(
        httpClient: MockClient((http.Request request) async {
          return http.Response('esto no es json', 200);
        }),
      );

      final Result<Map<String, dynamic>> result = await client.getJson(uri);

      expect(result, isA<Failure<Map<String, dynamic>>>());
    });

    test('devuelve Failure cuando el JSON no es un objeto', () async {
      final RemoteClient client = RemoteClient(
        httpClient: MockClient((http.Request request) async {
          return http.Response('[1, 2, 3]', 200);
        }),
      );

      final Result<Map<String, dynamic>> result = await client.getJson(uri);

      expect(result, isA<Failure<Map<String, dynamic>>>());
    });
  });
}
