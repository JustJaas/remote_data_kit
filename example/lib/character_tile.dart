import 'package:flutter/material.dart';
import 'package:remote_data_kit/remote_data_kit.dart';

class CharacterTile extends StatelessWidget {
  const CharacterTile({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(character.image)),
      title: Text(character.name),
      subtitle: Text('${character.status} - ${character.species}'),
    );
  }
}
