import 'package:flutter/material.dart';
import 'package:puzzle_mobile/Puzzle/timer.dart';
import 'package:puzzle_mobile/dialogs.dart';

class ListController extends ChangeNotifier {
  int level = 2; // Nível do Puzzle
  List<int> items = List.generate((4 - 1), (i) => i + 1)..add(0);
  int rounds = 0; // Numero de Jogadas
  late final TimerController _timer;

  void setTimerController(TimerController timer) {
    _timer = timer;
  }



  int get _swapCount {
    int count = 0;
    
    for (int i = 0; i < items.length; i++) {
      for (int j = i; j < items.length; j++) { 
        int a = items.elementAt(i);
        int b = items.elementAt(j);

        if (a != 0 && b != 0) {
          if (a > b) count++;
        }
      }
    }

    return count;
  }

  int get _blankLine {
    return (items.elementAt(0) / items.length).round();
  }

  bool get canBeSolvable {
    int swap = _swapCount;
    int blankLine = _blankLine;

    return (swap.isEven && blankLine.isOdd) || (blankLine.isEven && swap.isOdd);
  }
  // TODO: implementar rounds diretamente no puzzle
  void increaseRounds() {
    rounds++;
    notifyListeners();
  }

  void generate() {
    // O puzzle é gerado a partir do nível selecionado
    final int length = (level * level);
    // Gera a lista de 1 a level^2 e embaralha os valores
    items = List.generate(length - 1, (i) => i + 1);
    // if (canBeSolvable == false) generate();
    notifyListeners();
  }

  void shuffle() {
    if (items.length > 1) {
      items.remove(0);
      do {
        items.shuffle();
      } while(!canBeSolvable);
      items.add(0);
    } else {
      generate();
      shuffle();
    }
    _timer.start();
    _timer.reset();
    rounds = 0;
    notifyListeners();
  }

  //TODO: implementar level diretamente no puzzle
  void changeLevel(BuildContext context) async {
    _timer.stop();
    // O usuário define o nível nas opções do dialog
    final int? selected = await showLevelDialog(context);
    if (selected != null && selected != level) {
      level = selected;
      generate();
      shuffle();
      _timer.setup();
    } else {
      if(_timer.elapsed > Duration.zero) _timer.resume();
    }
    notifyListeners();
    // return _timer.resume();
  }
  //TODO: implementar restart diretamente no puzzle
  void restartPuzzle(BuildContext context) async {
    _timer.stop();
    final bool selected = await showShuffleDialog(context);
    if(selected) {
      shuffle();
    }
    notifyListeners();
  }
}