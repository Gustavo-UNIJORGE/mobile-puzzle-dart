import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/settings.dart';
import 'package:puzzle_mobile/Puzzle/timer.dart';

class Puzzle extends StatelessWidget {
  const Puzzle({super.key});

  @override
  Widget build(BuildContext context) {
    // final puzzle = context.watch<PuzzleController>();

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
          onPressed: null,
          style: ElevatedButton.styleFrom(
            shape: LinearBorder(),
          ),
          child:Text('$value')
        ),
        ElevatedButton(
          onPressed: () => puzzle.makeMovement(),
          style: ElevatedButton.styleFrom(
            shape: LinearBorder(),
          ),
          child:Text('')
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

class ListController extends ChangeNotifier {
  int level = 2; // Nível do Puzzle
  List<int> items = List.generate((4 - 1), (i) => i + 1)..shuffle();
  int rounds = 0; // Numero de Jogadas
  late final TimerController _timer;

  void setTimerController(TimerController timer) {
    _timer = timer;
  }

  void increaseRounds() {
    rounds++;
    notifyListeners();
  }

  void generatePuzzle() {
    // O puzzle é gerado a partir do nível selecionado
    // Gera a lista de 1 a level^2 e embaralha os valores
    items = List.generate(((level * level) - 1), (i) => i + 1)..shuffle(); 
    notifyListeners();
  }

  void shuffleList() {
    if (items.length > 1) {
      items.shuffle();
    } else {
      generatePuzzle();
    }
    rounds = 0;
    _timer.reset();
    notifyListeners();

  }

  void changeLevel(BuildContext context) async {
    _timer.stop();
    // O usuário define o nível nas opções do dialog
    final int? selected = await _showLevelDialog(context);
    if (selected != null && selected != level) {
      level = selected;
      generatePuzzle();
      shuffleList();
      notifyListeners();
      return _timer.reset();
    }
    notifyListeners();
    return _timer.resume();
  }

  void restartPuzzle(BuildContext context) async {
    _timer.stop();
    final bool selected = await _showShuffleDialog(context);
    if(selected) {
      shuffleList();
    }
    notifyListeners();
  }
}

Future<int?> _showLevelDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
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
