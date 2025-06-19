import 'package:flutter/material.dart';
import 'package:puzzle_mobile/Puzzle/timer.dart';

class ListController extends ChangeNotifier {
  int length = 4;
  List<int> items = List.generate((4), (i) => i + 1);
  late final TimerController _timer;

  void setTimerController(TimerController timer) =>_timer = timer;


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

  int get emptyPosition => items.indexOf(length - 1);

  void generate(level) {
    // O puzzle é gerado a partir do nível selecionado
    length = (level * level);
    // Gera a lista de 1 a level^2 e embaralha os valores
    items = List.generate(length - 1, (i) => i + 1);
    notifyListeners();
  }

  void shuffle(level) {
    if (items.length > 1) {
      items.remove(0);
      do {
        items.shuffle();
      } while(!canBeSolvable);
      items.add(0);
    } else {
      generate(level);
      shuffle(level);
    }
    _timer.start();
    _timer.reset();
    // rounds = 0;  //reset rounds
    notifyListeners();
  }

  void swap(int positionA, int positionB) {
    int valueA = items.elementAt(positionA);
    int valueB = items.elementAt(positionB);
    
    items[positionA] = valueA;
    items[positionB] = valueB;
    notifyListeners();
  }
}