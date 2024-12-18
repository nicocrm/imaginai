import 'package:flutter/material.dart';
import 'package:image_generator/core/result.dart';
import 'package:image_generator/services/openai_service.dart';

class ImageViewModel extends ChangeNotifier {
  final OpenAIService _openAIService;
  Result<String>? _imageResult;
  Result<String>? get imageResult => _imageResult;

  ImageViewModel(this._openAIService);

  Future<Result<String>> loadImage() async {
    // Use OpenAIService to generate an image
    final prompt = 'A beautiful landscape with mountains and a lake';
    _imageResult = await _openAIService.generateImage(prompt);
    
    notifyListeners();
    return _imageResult!;
  }
}