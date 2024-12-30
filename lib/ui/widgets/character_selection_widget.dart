import 'package:flutter/material.dart';

import '../../models/character.dart';
import '../vm/image_view_model.dart';

class CharacterSelectionWidget extends StatelessWidget {
  const CharacterSelectionWidget({super.key, required this.vm});

  final ImageViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: vm.project.characters.map(buildCharacterCheckbox).toList(),
    );
  }

  CheckboxListTile buildCharacterCheckbox(Character character) {
    return CheckboxListTile(
      title: Text(character.name),
      value: vm.characters.contains(character),
      onChanged: (value) => vm.toggleCharacter(character),
    );
  }
}
