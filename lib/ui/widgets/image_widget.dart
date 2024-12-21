import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:imaginai/core/result.dart';

class ImageWidget extends StatelessWidget {
  final Result<Uint8List>? imageResult;

  const ImageWidget({
    super.key, 
    required this.imageResult
  });

  @override
  Widget build(BuildContext context) {
    if (imageResult == null) {
      return const Text('No image loaded');
    }

    return imageResult!.when(
      success: (imageBytes) => Image.memory(
        imageBytes,
        fit: BoxFit.contain,
      ),
      failure: (error) => Text(
        error,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}