import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/list.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';
import 'package:puzzle_mobile/Puzzle/timer.dart';
import 'package:puzzle_mobile/dialogs.dart';

class Board extends StatelessWidget {
  const Board({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final puzzle = context.watch<PuzzleController>();

    return GridView.count(
      crossAxisCount: puzzle.board.level,
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
  int level = 2; // Nível do Puzzle
  // TODO: implementar rounds no controlador do jogo
  int rounds = 0; // Numero de Jogadas
  
  ListController _list = ListController();
  TimerController _timer = TimerController();

  void setListController(list) => _list = list;

  void setTimerController(timer) => _timer = timer;

  // TODO: implementar increaseRounds no controlador do jogo
  void increaseRounds() {
    rounds++;
    notifyListeners();
  }

  void makeMovement() {
    // _list.increaseRounds();
    rounds++;
    _timer.start();
    notifyListeners();
  }

  
  //TODO: implementar level no controlador do jogo
  void changeLevel(BuildContext context) async {
    _timer.stop();
    // O usuário define o nível nas opções do dialog
    final int? selected = await showLevelDialog(context);
    if (selected != null && selected != level) {
      level = selected;
      _list.generate(level);
      _list.shuffle(level);
      _timer.setup();
    } else {
      if(_timer.elapsed > Duration.zero) _timer.resume();
    }
    notifyListeners();
    // return _timer.resume();
  }
  //TODO: implementar restart no controlador do jogo
  void restartPuzzle(BuildContext context) async {
    _timer.stop();
    final bool selected = await showShuffleDialog(context);
    if(selected) {
      _list.shuffle(level);
    }
    notifyListeners();
  }
}