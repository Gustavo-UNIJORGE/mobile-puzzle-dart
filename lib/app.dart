import 'package:flutter/material.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';

class App extends StatelessWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Flutter Puzzle Mobile', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary
            ),
          ),
        ),
        body: const SafeArea(
          child: Center(
            child: Puzzle(), 
          )
        )
      );
  }
}