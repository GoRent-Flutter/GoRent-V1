import 'package:flutter/material.dart';

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('filters'),
      ),
      body: const Center(
        child: Text('filters screen'),
      ),
    );
  }
}