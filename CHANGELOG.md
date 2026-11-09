# Changelog

## [1.0.1] - 2026-11-09

### Fixed
- Correccion del versionamiento del paquete 

## [1.0.0] - 2026-11-05

### Added
- `RemoteClient`: cliente GET con tiempo límite que devuelve JSON decodificado dentro de un `Result`.
- `Result`, `Success` y `Failure`: resultado de una operación (éxito o error), sin lanzar excepciones.
- `ApiException`: error con mensaje legible y `statusCode` opcional.
- `Character`: entidad de Rick and Morty API.
- `CharacterRepositoryInterface` y `CharacterRepositoryImpl.getCharacters`: consulta de personajes con búsqueda por nombre.
- App de ejemplo en `example/` y pruebas automáticas.
