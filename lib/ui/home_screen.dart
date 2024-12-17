import 'package:flutter/material.dart';
import 'package:image_generator/ui/image_screen.dart';
import 'package:image_generator/ui/vm/image_view_model.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImageViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ImageViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),

      body: Center(child: ImageScreen(vm: vm),)
    );
  }
}