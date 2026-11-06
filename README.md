# remote_data_kit

Paquete de Dart para consumir APIs REST que devuelven JSON de forma simple y ordenada: un cliente HTTP
con tiempo límite, errores con mensajes legibles sin lanzar excepciones (usa `Result`) y acceso listo para
la [Rick and Morty API](https://rickandmortyapi.com/).

## Ejemplo

https://github.com/user-attachments/assets/9b41a99d-857a-4a03-9cf3-295f75154cad

## Ejecutar y probar

```bash
git clone https://github.com/JustJaas/remote_data_kit.git
cd remote_data_kit

dart pub get
dart analyze        # análisis estático (debe terminar sin avisos)
dart test           # pruebas automáticas; no necesitan internet
```

### App de ejemplo

La app muestra la lista de personajes, permite buscar por nombre (escribe y pulsa Enter) y presenta los estados de
carga, error (con botón Reintentar) y sin resultados.

```bash
cd example
flutter pub get
flutter run
```

## Licencia

MIT. Ver [LICENSE](LICENSE).


## Instalación

### Requisitos

- **Dart 3.5 o superior** viene incluido en Flutter 3.24 o superior.
- **Git** instalado, porque el paquete se descarga desde GitHub.

### Opción 1: con un comando (recomendada)

Dentro de la carpeta de tu proyecto:

```bash
flutter pub add remote_data_kit \
  --git-url=https://github.com/JustJaas/remote_data_kit.git \
  --git-ref=v1.0.0
```

### Opción 2: editando el `pubspec.yaml`

Agrega esto en `dependencies:` (respetando la indentación):

```yaml
dependencies:
  flutter:
    sdk: flutter

  remote_data_kit:
    git:
      url: https://github.com/JustJaas/remote_data_kit.git
      ref: v1.0.0   # etiqueta de la versión que quieres usar
```

Luego descarga el paquete:

```bash
flutter pub get      # o: dart pub get
```

### Comprobar que quedó instalado

Para una prueba completa desde cero, crea un proyecto vacío:

```bash
dart create probar_kit
cd probar_kit
dart pub add remote_data_kit \
  --git-url=https://github.com/JustJaas/remote_data_kit.git \
  --git-ref=v1.0.0
```

En tu código importa el paquete:

```dart
import 'package:remote_data_kit/remote_data_kit.dart';
```

Si no marca error, está instalado. 

Reemplaza el contenido de `bin/probar_kit.dart` por:

```dart
import 'package:remote_data_kit/remote_data_kit.dart';

Future<void> main() async {
  final CharacterRepositoryImpl repository = CharacterRepositoryImpl();

  final Result<List<Character>> result =
      await repository.getCharacters(name: 'rick');

  switch (result) {
    case Success<List<Character>>(:final List<Character> data):
      print('Personajes encontrados: ${data.length}');
    case Failure<List<Character>>(:final ApiException error):
      print('Error: ${error.message}');
  }

  repository.close();
}
```

Ejecútalo con `dart run`. Debe imprimir `Personajes encontrados: ...`.
