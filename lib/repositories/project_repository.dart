import '../models/character.dart';
import '../models/project.dart';
import '../models/scene.dart';

class ProjectRepository {
  Project loadProject() {
    final project = Project(
        name: "Leonardo's inquiry",
        context: "Italy in the renaissance era",
        style:
            "A simple drawing, without colors, suitable for a comic book such as the ones published in the 1960s.");
    project.scenes
        .add(Scene(description: "A dimly lit hallway", name: "hallway"));
    project.characters.add(Character(
        name: "Francesca",
        description:
            "a 12-year old girl, with long, dark hair, fair skin, wearing a simple dress"));
    project.characters.add(Character(
        name: "Orazio",
        description:
            "a painter, tall, middle-aged, with a beard, wearing a beret and a smock"));
    project.characters.add(Character(
        name: "Battista",
        description:
            "the butler, old, stiff, very formal clothes but showing their age"));
    return project;
  }

  Project setProject(Project project) {
    return project;
  }

  /// add or replace character in project and save it
  void setCharacter(Project project, Character character) {}

  /// add or replace scene in project and save it
  void setScene(Project project, Scene scene) {}
}
