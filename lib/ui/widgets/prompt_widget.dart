import 'package:flutter/material.dart';
import '../vm/image_view_model.dart';

import '../../models/scene.dart';
import 'character_selection_widget.dart';

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
    return ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<Scene>(
                      value: vm.scene,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (Scene? newValue) {
                        vm.scene = newValue;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Indique la scène';
                        }
                        return null;
                      },
                      items: vm.project.scenes
                          .map<DropdownMenuItem<Scene>>((Scene scene) {
                        return DropdownMenuItem<Scene>(
                          value: scene,
                          child: Text(scene.name),
                        );
                      }).toList(),
                    ),
                    CharacterSelectionWidget(vm: vm),
                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: promptController,
                          onChanged: (value) => vm.promptText = value,
                          onEditingComplete: vm.promptText.isEmpty ? null : () => vm.loadImage(vm.promptText),
                          enabled: !vm.isLoading,
                          decoration: InputDecoration(
                            hintText: 'Tape la description de l\'image',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                vm.promptText = "";
                              },
                            ),
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ])
                  ]));
        });
  }
}
