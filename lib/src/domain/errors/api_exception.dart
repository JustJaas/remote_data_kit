/// Error con un mensaje legible para el usuario.
///
/// Viaja dentro de un `Failure`: el paquete no lo lanza, lo devuelve como
/// parte del resultado.
class ApiException implements Exception {
  /// Crea una excepción con un [message] legible y, opcionalmente, el
  /// [statusCode] HTTP que la originó.
  const ApiException(this.message, {this.statusCode});

  /// Mensaje apto para mostrar en la interfaz.
  final String message;

  /// Código HTTP de la respuesta, si el error vino de una respuesta del
  /// servidor. Es `null` en errores que no tienen respuesta (por ejemplo,
  /// cuando no hay conexión).
  final int? statusCode;

  @override
  String toString() => message;
}
