import 'package:flutter/material.dart';

class ImageViewModel extends ChangeNotifier {
  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  Future<void> loadImage() async {
    // TODO: Implement image loading logic
    final randomValue = DateTime.now().millisecondsSinceEpoch;
    _imageUrl = "https://picsum.photos/200/300?rnd=$randomValue";
    notifyListeners();
  }
}