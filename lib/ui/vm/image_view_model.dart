import 'package:flutter/material.dart';
import 'package:imaginai/core/result.dart';
import 'package:imaginai/services/openai_service.dart';

class ImageViewModel extends ChangeNotifier {
  final OpenAIService _openAIService;
  Result<String>? _imageResult;
  Result<String>? get imageResult => _imageResult;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ImageViewModel(this._openAIService);

  Future<Result<String>> loadImage(String prompt) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Use OpenAIService to generate an image
      _imageResult = await _openAIService.generateImage(prompt);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
    return _imageResult!;
  }
}