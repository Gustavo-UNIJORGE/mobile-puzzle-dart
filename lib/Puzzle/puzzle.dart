import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/board.dart';
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
          AspectRatio(
            aspectRatio: 1,
            child: Board()
          )
        ],
      ),
    );
  }
}


class PuzzleController extends ChangeNotifier{
  final TimerController timer = TimerController();
  final ListController list = ListController();
  final BoardController board = BoardController();

  PuzzleController() { 
    list.setTimerController(timer);

    board.setListController(list);
    board.setTimerController(timer);

    timer.addListener(_handleUpdate);
    list.addListener(_handleUpdate);
    board.addListener(_handleUpdate);
  }

  void _handleUpdate() {
    notifyListeners();
  }

  void resetCounts() {
    timer.reset();
    board.rounds = 0;
  }

  // void _resetTimer() {
  //   timer.reset();
  // }

  @override
  void dispose() {
    timer.dispose();
    list.dispose();
    super.dispose();
  }
}

