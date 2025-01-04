import 'package:flutter/material.dart';
import 'ui/image_screen.dart';
import 'ui/vm/image_view_model.dart';

import 'services/openai_service.dart';
import 'repositories/project_repository.dart';
import 'services/prompt_builder.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with RestorationMixin {
  final RestorableImageViewModel imageViewModel = RestorableImageViewModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImaginAI',
      restorationScopeId: "imaginai",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ImageScreen(title: 'Générer une image', vm: imageViewModel.value),
    );
  }

  @override
  String? get restorationId => "main";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(imageViewModel, 'imageViewModel');
  }
}
