# remote_data_kit

Paquete de Dart para consumir APIs REST que devuelven JSON de forma simple y ordenada: un cliente HTTP
con tiempo límite, errores con mensajes legibles sin lanzar excepciones (usa `Result`) y acceso listo para
la [Rick and Morty API](https://rickandmortyapi.com/).

## Ejecutar y probar

```bash
git clone https://github.com/TU-USUARIO/remote_data_kit.git
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