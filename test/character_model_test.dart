import 'package:remote_data_kit/src/infrastructure/models/character_model.dart';
import 'package:test/test.dart';

import 'helpers/sample_data.dart';

void main() {
  group('CharacterModel.fromJson', () {
    test('lee los campos simples y los objetos anidados', () {
      final CharacterModel model = CharacterModel.fromJson(
        SampleData.character(1, 'Rick Sanchez'),
      );

      expect(model.id, 1);
      expect(model.name, 'Rick Sanchez');
      expect(model.status, 'Alive');
      expect(model.originName, 'Earth (C-137)');
      expect(model.locationName, 'Citadel of Ricks');
    });

    test('usa valores por defecto cuando faltan campos opcionales', () {
      final CharacterModel model =
          CharacterModel.fromJson(<String, dynamic>{'id': 7});

      expect(model.name, 'Desconocido');
      expect(model.status, 'unknown');
      expect(model.originName, 'unknown');
      expect(model.image, '');
    });
  });
}
