import 'package:flutter/material.dart';
import 'package:image_generator/ui/base_screen.dart';
import 'package:image_generator/ui/vm/image_view_model.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key, required this.title, required this.vm});
  final ImageViewModel vm;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return BaseScreen(
          title: title,
          body: Center(
            child: vm.imageUrl != null
                ? Image.network(
                    vm.imageUrl!,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Failed to load image');
                    },
                  )
                : const Text('No image loaded'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: vm.loadImage,
            child: const Icon(Icons.refresh),
          ),
        );
      },
    );
  }
}
