import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;

import '../../core/result.dart';
import '../../models/character.dart';
import '../../models/project.dart';
import '../../models/scene.dart';
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
  Result<Uint8List>? _imageResult;
  Result<Uint8List>? get imageResult => _imageResult;

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

  Future<Result<Uint8List>> loadImage(String promptText) async {
    if(_scene == null) {
      return Result.failure("No scene selected");
    }

    _isLoading = true;
    _saved = false;
    notifyListeners();

    try {
      final prompt = _promptBuilder.makePrompt(_project, _scene!);
      for(final character in _characters) {
        prompt.addCharacter(character);
      }
      final result = await _openAIService.generateImage(prompt.buildPrompt(promptText));
      await result.when(
        success: (imageUrl) async {
          _imageResult = await _downloadImage(imageUrl);
        },
        failure: (error) {
          _imageResult = Result.failure(error);
        },
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _imageResult!;
  }

  Future<Result<Uint8List>> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        return Result.failure("Failed to download image");
      }
      return Result.success(response.bodyBytes);
    } catch (e) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        context: ErrorSummary('error downloading image'),
      ));
      return Result.failure("Failed to download image");
    }
  }

  void toggleCharacter(Character character) {
    if(_characters.contains(character)) {
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
    final imageBytes = (imageResult as Success<Uint8List>).value;
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
