import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';

import 'app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PuzzleController(),
      child: const MaterialApp(
        home: App()
      ),
    )
  );
}
