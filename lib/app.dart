import 'package:flutter/material.dart';
import 'package:image_generator/ui/image_screen.dart';
import 'package:image_generator/ui/vm/image_view_model.dart';
import 'package:image_generator/services/openai_service.dart';

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
    imageViewModel = ImageViewModel(openAIService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ImageScreen(title: 'Image Generator', vm: imageViewModel),
    );
  }
}
