import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:imaginai/core/result.dart';

class ImageWidget extends StatelessWidget {
  final Result<Uint8List>? imageResult;

  const ImageWidget({super.key, required this.imageResult});

  @override
  Widget build(BuildContext context) {
    // If no image is loaded, show a large refresh icon
    if (imageResult == null) {
      return Center(
        child: IconButton(
          icon: const Icon(Icons.refresh, size: 100),
          onPressed: null, // No action for now
          color: Colors.grey,
        ),
      );
    }

    // When an image is loaded, show the image with a small faded refresh icon overlay
    return imageResult!.when(
      success: (imageBytes) => Stack(
        alignment: Alignment.topRight,
        children: [
          Image.memory(
            imageBytes,
            fit: BoxFit.contain,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Opacity(
              opacity: 0.3,
              child: IconButton(
                icon: const Icon(Icons.refresh, size: 24),
                onPressed: null, // No action for now
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      failure: (error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 50),
              onPressed: null, // No action for now
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
