import 'package:flutter/material.dart';
import 'package:imaginai/ui/base_screen.dart';
import 'package:imaginai/ui/vm/image_view_model.dart';
import 'package:imaginai/ui/widgets/image_widget.dart';
import 'package:imaginai/ui/widgets/prompt_widget.dart';

class ImageScreen extends StatefulWidget {
  final String title;
  final ImageViewModel vm;

  const ImageScreen({super.key, required this.title, required this.vm});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, child) {
        return BaseScreen(
          title: widget.title,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: widget.vm.isLoading
                      ? const CircularProgressIndicator()
                      : ImageWidget(imageResult: widget.vm.imageResult),
                ),
                PromptWidget(
                  promptController: _promptController,
                  vm: widget.vm,
                ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: widget.vm.isLoading ? null : () => widget.vm.loadImage(),
          //   child: const Icon(Icons.refresh),
          // ),
        );
      },
    );
  }
}
