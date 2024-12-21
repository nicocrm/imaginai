import 'package:flutter/material.dart';
import 'package:imaginai/ui/vm/image_view_model.dart';

class PromptWidget extends StatelessWidget {
  final TextEditingController promptController;
  final ImageViewModel vm;

  const PromptWidget({
    super.key,
    required this.promptController,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: promptController,
              decoration: InputDecoration(
                hintText: 'Enter image generation prompt',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    promptController.clear();
                  },
                ),
              ),
              maxLines: 1,
            ),
          ),
          IconButton(
              icon: const Icon(
                Icons.send,
              ),
              onPressed: () {
                vm.loadImage(promptController.text);
              }),
          IconButton(
              icon: const Icon(
                Icons.download,
              ),
              onPressed: () {
                vm.downloadImage();
              }),
        ]));
  }
}
