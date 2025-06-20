import 'package:flutter/material.dart';
import 'package:puzzle_mobile/Puzzle/board.dart';
import 'package:puzzle_mobile/Puzzle/list.dart';
import 'package:puzzle_mobile/Puzzle/settings.dart';
import 'package:puzzle_mobile/Puzzle/timer.dart';
import 'package:puzzle_mobile/dialogs.dart';

class Puzzle extends StatelessWidget {
  const Puzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 64, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TimerSettings(),
          Settings(),   
          Expanded(child: Board()),
        ],
      ),
    );
  }
}


class PuzzleController extends ChangeNotifier{
  int rounds = 0; // Numero de Jogadas

  final TimerController timer = TimerController();
  final ListController list = ListController();
  final BoardController board = BoardController();

  int get size => board.positionsCount;

  PuzzleController() { 
    list.setTimerController(timer);

    timer.addListener(_handleUpdate);
    list.addListener(_handleUpdate);
    board.addListener(_handleUpdate);

    board.generate();
  }

  void _handleUpdate() {
    notifyListeners();
  }

  void makeMovement(BuildContext context, position) {
    increaseCount();
    timer.start();
    board.swapPositions(position, board.emptyPosition);
    checkIsComplete(context);
    notifyListeners();
  }
  Future<void> checkIsComplete(BuildContext context) async {
    if(isComplete()) {
      bool wantReplay = await congratulationsDialog(context);
      if(wantReplay) {
        timer.reset();
        board.generate();
        rounds = 0;
      }
    }
    notifyListeners();
  }

  bool isComplete() {
    List<int> order = List.generate(size - 1, (i) => i + 1)..add(0); 
    print('correct: ${order}');
    print('yours: ${board.values}');
    for (int i = 0; i < size; i++) {
      if (order[i] != board.values[i]) {
        return false; 
      } else {
        continue;
      } 
    }
    return true;
  }
  

  void increaseCount() {
    rounds++;
    notifyListeners();
  }

  void resetCounts() {
    timer.reset();
    rounds = 0;
  }

  void changeLevel(BuildContext context) async {
    timer.stop();
    // O usuário define o nível nas opções do dialog
    final int? selected = await changeLevelDialog(context);
    if (selected != null && selected != board.level) {
      board.level = selected;
      board.generate();
      // list.shuffle(board.level);
    } 
    notifyListeners();
    // return _timer.resume();
  }

  void restart(BuildContext context) async {
    timer.stop();
    if(rounds > 0) {
      final bool? selected = await alertShuffleDialog(context);
      // Se o usuário não confirmar
      if(selected != true) { 
        return;  // não deve acontece nada
      }
    } 
    timer.reset();
    board.generate();
    rounds = 0;

    notifyListeners();
  }


  @override
  void dispose() {
    board.dispose();
    timer.dispose();
    list.dispose();
    super.dispose();
  }
}

