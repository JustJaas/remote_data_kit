import 'package:remote_data_kit/src/domain/errors/api_exception.dart';

/// Resultado de una operación: o salió bien ([Success]) o falló
/// ([Failure]), nunca las dos cosas.
///
/// Es una `sealed class`: el compilador conoce todos sus casos y obliga a
/// manejar ambos al usar un `switch`.
sealed class Result<T> {
  /// Constructor base de los resultados.
  const Result();
}

/// Caso exitoso: contiene el dato obtenido.
class Success<T> extends Result<T> {
  /// Crea un resultado exitoso con el [data] obtenido.
  const Success(this.data);

  /// Dato obtenido.
  final T data;
}

/// Caso fallido: contiene el error.
class Failure<T> extends Result<T> {
  /// Crea un resultado fallido con el [error] ocurrido.
  const Failure(this.error);

  /// Error con un mensaje legible para el usuario.
  final ApiException error;
}
