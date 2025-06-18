import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';
import 'package:puzzle_mobile/Puzzle/timer.dart';

class App extends StatelessWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerController()),
        ChangeNotifierProvider(create: (_) => PuzzleController())
      ],
      child:Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Flutter Puzzle Mobile', 
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary
            ),
          ),
        ),
        body: Center(
          child: Puzzle(), 
        ),
        floatingActionButton: Consumer<PuzzleController>(
          builder: (BuildContext context, PuzzleController puzzleState, child) {
            return FloatingActionButton(
              onPressed: () {
                if (puzzleState.rounds > 0) {
                  puzzleState.restartPuzzle(context);
                } else {
                  puzzleState.generatePuzzle();
                }
              },
              tooltip: 'Embaralhar',
              child: const Icon(Icons.refresh), 
            );
          },
        ),
      )
    );
  }
}