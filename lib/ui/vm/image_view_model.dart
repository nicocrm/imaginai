import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;

import '../../core/result.dart';
import '../../models/character.dart';
import '../../models/project.dart';
import '../../models/scene.dart';
import '../../repositories/project_repository.dart';
import '../../services/openai_service.dart';
import '../../services/prompt_builder.dart';

class ImageViewModel extends ChangeNotifier {
  final OpenAIService _openAIService;
  final PromptBuilder _promptBuilder;
  final Project _project;
  bool _saved = false;
  bool get saved => _saved;
  String _promptText = "";
  Scene? _scene;
  final _characters = <Character>{};
  Result<String>? _imageResult;
  Result<String>? get imageResult => _imageResult;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Project get project => _project;
  Scene? get scene => _scene;
  set scene(Scene? value) {
    _scene = value;
    notifyListeners();
  }

  Set<Character> get characters => UnmodifiableSetView(_characters);
  String get promptText => _promptText;
  set promptText(String value) {
    _promptText = value;
    notifyListeners();
  }

  ImageViewModel(this._openAIService, this._promptBuilder, this._project);

  Future<Result<String>> loadImage(String promptText) async {
    if (_scene == null) {
      return Result.failure("No scene selected");
    }

    _isLoading = true;
    _saved = false;
    notifyListeners();

    try {
      final prompt = _promptBuilder.makePrompt(_project, _scene!);
      for (final character in _characters) {
        prompt.addCharacter(character);
      }
      _imageResult =
          await _openAIService.generateImage(prompt.buildPrompt(promptText));
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _imageResult!;
  }

  Future<Uint8List> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }
      return response.bodyBytes;
    } catch (e) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        context: ErrorSummary('error downloading image'),
      ));
      rethrow;
    }
  }

  void toggleCharacter(Character character) {
    if (_characters.contains(character)) {
      _characters.remove(character);
    } else {
      _characters.add(character);
    }
    notifyListeners();
  }

  Future<void> saveImage() async {
    if (!await _requestPermission()) {
      debugPrint("Permission denied");
      return;
    }
    if (imageResult == null || imageResult!.isFailure) {
      debugPrint("No image to save");
      return;
    }
    final imageUrl = (imageResult as Success<String>).value;
    final imageBytes = await _downloadImage(imageUrl);

    await Gal.putImageBytes(imageBytes);
    _saved = true;
  }

  Future<bool> _requestPermission() async {
    final status = await Gal.requestAccess();
    return status;
  }

  void reset() {
    _imageResult = null;
    _promptText = "";
    _scene = null;
    _characters.clear();
    _saved = false;
    notifyListeners();
  }
}

class RestorableImageViewModel extends RestorableListenable<ImageViewModel> {
  @override
  ImageViewModel createDefaultValue() {
    final openAIService = OpenAIService();
    final project = ProjectRepository().loadProject();
    final promptBuilder = PromptBuilder();
    return ImageViewModel(openAIService, promptBuilder, project);
  }

  @override
  ImageViewModel fromPrimitives(Object? data) {
    ImageViewModel viewModel = createDefaultValue();
    final map = data as Map;
    viewModel._promptText = map["promptText"] as String;
    viewModel._saved = map["saved"] as bool;
    if (map["imageResult"] != null) {
      viewModel._imageResult = Success<String>(map["imageResult"] as String);
    }
    viewModel._isLoading = map["isLoading"] as bool;
    if (map["scene"] != null) {
      viewModel._scene = viewModel.project.scenes
          .firstWhere((element) => element.name == map["scene"] as String);
    }
    if (map["characters"] != null) {
      viewModel._characters.addAll((map["characters"] as List)
          .map((e) => viewModel.project.characters
              .firstWhere((element) => element.name == e))
          .toList());
    }
    return viewModel;
  }

  @override
  Object? toPrimitives() {
    final vm = value;
    return {
      "promptText": vm._promptText,
      // "scene": vm._scene,
      // "characters": vm._characters,
      "saved": vm._saved,
      "imageResult": vm._imageResult is Success<String>
          ? (vm._imageResult as Success<String>).value
          : null,
      "isLoading": vm._isLoading,
      "scene": vm._scene?.name,
      "characters": vm._characters.map((e) => e.name).toList(),
    };
  }
}
