import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/list.dart';
import 'package:puzzle_mobile/Puzzle/settings.dart';
import 'package:puzzle_mobile/Puzzle/timer.dart';

class Puzzle extends StatelessWidget {
  const Puzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 64, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimerSettings(),
          Settings(),   
          Expanded(child: Canvas())
        ],
      ),
    );
  }
}

class Canvas extends StatelessWidget {
  const Canvas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final puzzle = context.watch<PuzzleController>();

    return GridView.count(
      crossAxisCount: puzzle.list.level,
      padding: EdgeInsets.all(64),

      children: [for (var value in puzzle.list.items) 
        ElevatedButton(
          onPressed: value == 0 ? puzzle.makeMovement : null,
          style: ElevatedButton.styleFrom(
            shape: LinearBorder(),
          ),
          child:Text(value > 0 ? '$value' : '')
        )
      ]
    );
  }
}

class PuzzleController extends ChangeNotifier{
  final TimerController timer = TimerController();
  final ListController list = ListController();

  PuzzleController() { 
    list.setTimerController(timer);
    timer.addListener(_handleTimerUpdate);
    list.addListener(_handleListUpdate);
  }

  void _handleTimerUpdate() {
    notifyListeners();
  }

  void _handleListUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    timer.dispose();
    list.dispose();
    super.dispose();
  }

  void makeMovement() {
    list.increaseRounds();
    timer.start();
    notifyListeners();
  }
  
}

