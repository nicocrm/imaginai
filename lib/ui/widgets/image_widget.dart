import 'package:flutter/material.dart';
import '../../core/result.dart';
import '../vm/image_view_model.dart';

class ImageWidget extends StatelessWidget {
  final Result<String>? imageResult;
  final ImageViewModel vm;

  const ImageWidget({super.key, required this.imageResult, required this.vm});

  @override
  Widget build(BuildContext context) {
    final generateImage = vm.promptText.isEmpty
        ? null
        : () {
          if(Form.of(context).validate()) {
            vm.loadImage(vm.promptText);
          }
          };

    // If no image is loaded, show a large refresh icon
    if (imageResult == null) {
      return Center(
        child: IconButton(
          icon: const Icon(Icons.refresh, size: 100),
          onPressed: generateImage,
          color: Colors.grey,
        ),
      );
    }

    // When an image is loaded, show the image with a small faded refresh icon overlay
    return imageResult!.when(
      success: (imageUrl) => Center(child: Stack(
        alignment: Alignment.topRight,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Opacity(
              opacity: .8,
              child: IconButton(
                icon: const Icon(Icons.refresh, size: 50),
                onPressed: generateImage,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      )),
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
              onPressed: generateImage,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
