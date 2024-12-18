import 'package:flutter/material.dart';

class ImageViewModel extends ChangeNotifier {
  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  Future<void> loadImage() async {
    // TODO: Implement image loading logic
    _imageUrl = 'https://picsum.photos/id/237/200/300';
    notifyListeners();
  }
}
