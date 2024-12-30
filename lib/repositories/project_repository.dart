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
        ..add(Scene(description: "A dimly lit hallway", name: "hallway"))
        ..add(Scene(description: "Secret room behind the office", name: "secret room"))
        ..add(Scene(description: "A small bedroom", name: "bedroom"))
        ..add(Scene(description: "A mountain path", name: "mountain path"))
        ..add(Scene(description: "An attic full of old chests", name: "attic"))
        ..add(Scene(description: "A 21st century art museum displaying work of Leonardo Da Vinci", name: "museum"));

    project.characters.add(Character(
        name: "Francesca",
        description:
            "a 12-year old girl, with long, dark hair, fair skin, wearing a simple dress"));
    project.characters.add(Character(
        name: "Orazio",
        description:
            "a gentleman, tall, middle-aged, with a beard, formal clothes"));
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
