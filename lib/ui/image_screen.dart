import 'package:flutter/material.dart';
import 'vm/image_view_model.dart';
import 'widgets/image_widget.dart';
import 'widgets/prompt_widget.dart';

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
    widget.vm.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.vm.addListener(() {
      if (_promptController.text != widget.vm.promptText) {
        _promptController.text = widget.vm.promptText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.title), actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showNewImageDialog,
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: widget.vm.imageResult == null
                  ? null
                  : () => _downloadImage(context),
            )
          ]),
          body: Center(
            child: Form(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: widget.vm.isLoading
                      ? Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : ImageWidget(
                          imageResult: widget.vm.imageResult, vm: widget.vm),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: PromptWidget(
                      promptController: _promptController,
                      vm: widget.vm,
                    )),
              ],
            )),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: widget.vm.isLoading ? null : () => widget.vm.loadImage(''),
          //   child: const Icon(Icons.refresh),
          // ),
        );
      },
    );
  }

  void _showNewImageDialog() {
    if (widget.vm.saved || widget.vm.imageResult == null) {
      widget.vm.reset();
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nouvelle image'),
          content: const Text(
              'Créer une nouvelle image? L\'image actuelle n\'est pas sauvegardée.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Oui!'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                widget.vm.reset();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadImage(BuildContext context) async {
    try {
      await widget.vm.saveImage();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image sauvegardée!')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text('Une erreur est survenue')));
      }
    }
  }
}
