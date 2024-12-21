import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:imaginai/core/result.dart';
import 'package:imaginai/services/openai_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageViewModel extends ChangeNotifier {
  final OpenAIService _openAIService;
  Result<Uint8List>? _imageResult;
  Result<Uint8List>? get imageResult => _imageResult;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ImageViewModel(this._openAIService);

  Future<Result<Uint8List>> loadImage(String prompt) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Use OpenAIService to generate an image
      prompt +=
          "\nIn the style of a Tintin comic book.  Simple drawing only, minimal background.";
      final result = await _openAIService.generateImage(prompt);
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
    ImageGallerySaver.saveImage(imageBytes,
        quality: 100, name: 'downloaded_image');
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}
