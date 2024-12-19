import 'package:flutter/material.dart';
import 'package:imaginai/ui/base_screen.dart';
import 'package:imaginai/ui/vm/image_view_model.dart';
import 'package:imaginai/ui/widgets/image_widget.dart';

class ImageScreen extends StatelessWidget {
  final String title;
  final ImageViewModel vm;

  const ImageScreen({
    super.key, 
    required this.title, 
    required this.vm
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return BaseScreen(
          title: title,
          body: Center(
            child: vm.isLoading
                ? const CircularProgressIndicator()
                : ImageWidget(imageResult: vm.imageResult),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: vm.isLoading ? null : () => vm.loadImage(),
            child: const Icon(Icons.refresh),
          ),
        );
      },
    );
  }
}