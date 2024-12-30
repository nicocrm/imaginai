import 'character.dart';
import 'scene.dart';

class Project {
  final String name;
  final String context;
  final String style;
  final characters = <Character>[];
  final scenes = <Scene>[];

  Project({required this.name, required this.context, required this.style});
}
