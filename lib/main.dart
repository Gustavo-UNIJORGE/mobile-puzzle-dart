import 'app.dart';
import 'timer.dart';
import 'puzzle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TimerController(),
      child: MaterialApp(
        home: App()
      )  
    )
  );
}
