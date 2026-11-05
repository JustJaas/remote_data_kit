import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:remote_data_kit/src/domain/errors/api_exception.dart';
import 'package:remote_data_kit/src/domain/result/result.dart';

/// Cliente que hace peticiones GET y devuelve el JSON ya decodificado.
///
/// Es la pieza reutilizable del paquete: se encarga de lo repetitivo (tiempo
/// límite, códigos de estado, decodificación y traducción de errores) y no
/// conoce ninguna API concreta. Nunca lanza excepciones: devuelve un [Result].
class RemoteClient {
  /// Crea un cliente.
  ///
  /// Si no se pasa [httpClient] se crea uno propio. Se puede inyectar uno
  /// distinto (por ejemplo, un `MockClient` en pruebas). [timeout] es el
  /// tiempo máximo que se espera cada respuesta.
  RemoteClient({
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 10),
  }) : _httpClient = httpClient ?? http.Client();

  /// Tiempo máximo de espera de cada petición.
  final Duration timeout;

  final http.Client _httpClient;

  /// Hace un GET a [uri] y devuelve el cuerpo decodificado como objeto JSON.
  ///
  /// Devuelve un [Failure] si la respuesta no es 200 (con su `statusCode`), si
  /// se agota el tiempo, si no hay conexión o si el cuerpo no es un objeto JSON
  /// válido.
  Future<Result<Map<String, dynamic>>> getJson(Uri uri) async {
    try {
      final http.Response response = await _httpClient.get(uri).timeout(timeout);

      if (response.statusCode != 200) {
        return _failure(
          'El servidor respondió con un error (${response.statusCode}).',
          statusCode: response.statusCode,
        );
      }

      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Success<Map<String, dynamic>>(body);
    } on TimeoutException {
      return _failure('La solicitud tardó demasiado. Intenta de nuevo.');
    } on SocketException {
      return _failure('Sin conexión a internet.');
    } on http.ClientException {
      return _failure('No se pudo conectar con el servidor.');
    } on FormatException {
      return _failure('La respuesta del servidor no es válida.');
    } on TypeError {
      return _failure('La respuesta del servidor tiene un formato inesperado.');
    } catch (_) {
      return _failure('Ocurrió un error inesperado.');
    }
  }

  /// Cierra el cliente HTTP y libera sus recursos.
  void close() => _httpClient.close();

  Failure<Map<String, dynamic>> _failure(String message, {int? statusCode}) {
    return Failure<Map<String, dynamic>>(
      ApiException(message, statusCode: statusCode),
    );
  }
}
