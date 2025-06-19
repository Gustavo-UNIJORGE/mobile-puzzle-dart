import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/list.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';
import 'package:puzzle_mobile/Puzzle/timer.dart';

class Board extends StatelessWidget {
  const Board({
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
          onPressed: value == 0 ? puzzle.board.makeMovement : null,
          style: ElevatedButton.styleFrom(
            shape: LinearBorder(),
          ),
          child:Text(value > 0 ? '$value' : '', 
            textScaler: TextScaler.linear(3.0),)
        )
      ]
    );
  }
}

class BoardController extends ChangeNotifier {
  ListController list = ListController();
  TimerController timer = TimerController();

  void setListController(list) => this.list = list;

  void setTimerController(timer) => this.timer = timer;

  void makeMovement() {
    list.increaseRounds();
    timer.start();
    notifyListeners();
  }
}