import '../models/character.dart';
import '../models/project.dart';
import '../models/scene.dart';

class ProjectRepository {
  Project loadProject() {
    final project = Project(
        name: "Enquête sur Léonard",
        context: "Italie dans l'era du renaisance",
        style:
            "Un dessin simple, sans couleurs, adapté aux livres de comics tels que ceux publiés dans les années 1960.");
    project.scenes
        ..add(Scene(description: "Une corridor sombre", name: "corridor"))
        ..add(Scene(description: "Une chambre secrète derrière le bureau", name: "chambre secrète"))
        ..add(Scene(description: "Un bureau avec une fenêtre qui donne sur les montagnes", name: "bureau grand-père"))
        ..add(Scene(description: "Une petite chambre", name: "chambre"))
        ..add(Scene(description: "Un chemin montagneux", name: "chemin"))
        ..add(Scene(description: "Un grenier plein de coffres anciens", name: "grenier"))
        ..add(Scene(description: "Un musee moderne affichant le travail de Leonardo Da Vinci", name: "musee"));

    project.characters.add(Character(
        name: "Francesca",
        description:
            "une jeune fille de 12 ans, avec des cheveux longs et noirs, peau claire, portant une simple robe"));
    project.characters.add(Character(
        name: "Orazio",
        description:
            "un homme de taille moyenne, la quarantaine, avec un barbe, vêtements formels"));
    project.characters.add(Character(
        name: "Battista",
        description:
            "le domestique, vieux, rigide, vêtements formels montrant leur age"));
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
