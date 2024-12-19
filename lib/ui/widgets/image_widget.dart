import 'package:flutter/material.dart';
import 'package:imaginai/core/result.dart';

class ImageWidget extends StatelessWidget {
  final Result<String>? imageResult;

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
      success: (imageUrl) => Image.network(
        imageUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          return const Text('Failed to load image from network');
        },
      ),
      failure: (error) => Text(
        error,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}