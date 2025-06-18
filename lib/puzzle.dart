import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/timer_controls.dart';
import 'package:puzzle_mobile/timer.dart';



class PuzzleController extends ChangeNotifier {
  int level = 2; // Nível do Puzzle
  List<int> list = List.generate((4 - 1), (i) => i + 1)..shuffle();
  int rounds = 0; // Numero de Jogadas
  TimerController? _timerController;

  void generatePuzzle() {
    // O puzzle é gerado a partir do nível selecionado
    // Gera a lista de 1 a level^2 e embaralha os valores
    list = List.generate(((level * level) - 1), (i) => i + 1)..shuffle(); 
    notifyListeners();
  }

  void shuffleList() {
    if (list.length > 1) {
      list.shuffle();
    } else {
      generatePuzzle();
    }
    rounds = 0;
    _timerController?.reset();
    notifyListeners();

  }

  void changeLevel(BuildContext context) async {
    _timerController?.stop();
    // O usuário define o nível nas opções do dialog
    final int? selected = await _showLevelDialog(context);
    if (selected != null && selected != level) {
      level = selected;
      generatePuzzle();
      shuffleList();
      notifyListeners();
      return _timerController?.reset();
    }
    notifyListeners();
    return _timerController?.resume();
  }

  void restartPuzzle(BuildContext context) async {
    _timerController?.stop();
    final bool selected = await _showShuffleDialog(context);
    if(selected) {
      shuffleList();
    }
    notifyListeners();
  }
}

class Puzzle extends StatelessWidget {
  const Puzzle({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerController>();
    final puzzle = context.watch<PuzzleController>();


    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 64, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimerControls(timerController: timer),
          Row( /* Game Settings */
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text('${puzzle.rounds} jogadas', textAlign: TextAlign.end,)),
              SizedBox(
                width: 128,
                child: TextButton(
                  onPressed: () async => puzzle.changeLevel(context),  
                  child: Text('Nível: ${puzzle.level}')
                ) 
              ),
            ]
          ),
          Expanded(child: 
            GridView.count(
              crossAxisCount: puzzle.level,
              padding: EdgeInsets.all(64),
        
              children: [for (var value in puzzle.list) 
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    shape: LinearBorder(),
                  ),
                  child:Text('$value')
                ),
                ElevatedButton(
                  onPressed: () {
                    puzzle.rounds++;
                    timer.start();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: LinearBorder(),
                  ),
                  child:Text('')
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}

Future<int?> _showLevelDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // actionsAlignment: MainAxisAlignment.center,
        title: const Text('Nível de Dificuldade', style: TextStyle(
          fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Escolha o nível de dificuldade:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 2),
            child: Text('Fácil (2x2)')
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 3), 
            child: Text('Médio (3x3)')
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 4),
            child: Text('Difícil (4x4)')
          ),
        ]
      );
    }
  );
}

Future<bool> _showShuffleDialog(BuildContext context) async {
  return await showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Tem certeza que quer Embaralhar?', style: TextStyle(
          fontWeight: FontWeight.bold,
        )),
        content: const Text('Seu progresso e tempo será perdido.'),
        actions: [
          TextButton (
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirmar')
          ),
          TextButton (
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar')
          )
        ] 
      );
    }
  );
}
