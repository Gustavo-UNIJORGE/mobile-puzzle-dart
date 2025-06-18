import 'dart:async'; // nao remover
import 'package:flutter/material.dart';
import 'package:puzzle_mobile/puzzle_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PuzzlePage(),
    );
  }
}
