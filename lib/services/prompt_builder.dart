import '../models/character.dart';
import '../models/project.dart';
import '../models/scene.dart';

class PromptBuilder {
  PromptBuilderInstance makePrompt(Project project, Scene scene) {
    return PromptBuilderInstance(project, scene);
  }
}

class PromptBuilderInstance {
  Project project;
  Scene scene;
  List<Character> characters = [];

  PromptBuilderInstance(this.project, this.scene);

  void addCharacter(Character character) {
    characters.add(character);
  }

  String buildPrompt(String prompt) {
    final buf = StringBuffer();
    buf.write("DO NOT add any detail to this prompt, just use it AS IT IS.\n");
    buf.write("Contexte: ${project.context}\n");
    buf.write("Style: ${project.style}\n");
    buf.write("Scène: ${scene.description}\n");
    for (final character in characters) {
      buf.write(
          "Personnage: ${character.name} - description: ${character.description}\n");
    }
    buf.write("Action: $prompt\n");
    return buf.toString();
  }
}
