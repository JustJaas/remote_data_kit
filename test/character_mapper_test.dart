import 'package:remote_data_kit/remote_data_kit.dart';
import 'package:remote_data_kit/src/infrastructure/mappers/character_mapper.dart';
import 'package:remote_data_kit/src/infrastructure/models/character_model.dart';
import 'package:test/test.dart';

import 'helpers/sample_data.dart';

void main() {
  group('CharacterMapper.modelToEntity', () {
    test('convierte un modelo en una entidad con los mismos datos', () {
      final CharacterModel model = CharacterModel.fromJson(
        SampleData.character(2, 'Morty Smith'),
      );

      final Character entity = CharacterMapper.modelToEntity(model);

      expect(entity.id, 2);
      expect(entity.name, 'Morty Smith');
      expect(entity.species, 'Human');
      expect(entity.locationName, 'Citadel of Ricks');
      expect(entity.image, model.image);
    });
  });
}
