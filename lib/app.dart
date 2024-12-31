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

class _MyAppState extends State<MyApp> {
  late ImageViewModel imageViewModel;

  @override
  void initState() {
    super.initState();
    final openAIService = OpenAIService();
    final project = ProjectRepository().loadProject();
    final promptBuilder = PromptBuilder();
    imageViewModel = ImageViewModel(openAIService, promptBuilder, project);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImaginAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ImageScreen(title: 'Générer une image', vm: imageViewModel),
    );
  }
}
