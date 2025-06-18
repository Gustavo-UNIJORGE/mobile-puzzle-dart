import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/timer_controls.dart';
import 'package:puzzle_mobile/timer.dart';

class Puzzle extends StatefulWidget {
  const Puzzle({super.key});

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  int level = 2; // Nível do Puzzle
  List<int> list = [];
  int rounds = 0; // Numero de Jogadas
  TimerController? _timerController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timerController = Provider.of<TimerController>(context);
  }

  @override
  void initState() {
    super.initState();
    _generatePuzzle();    
  }

  void _generatePuzzle() {
    // O puzzle é gerado a partir do nível selecionado
    setState(() { // Gera a lista de 1 a level^2 e embaralha os valores
      list = List.generate(((level * level) - 1), (i) => i + 1)..shuffle(); 
    });
  }

  void shuffleList() {
    setState(() {
      _generatePuzzle();
      list.shuffle();
      rounds = 0;
    });
    _timerController?.reset();
  }

  
  void _changeLevel(BuildContext context) async {
    _timerController?.stop();
    // O usuário define o nível nas opções do dialog
    final int? selected = await _showLevelDialog(context);
    if (selected != null && selected != level) {
      setState(() { // Atualiza level e reinicia o timer
        level = selected;
        shuffleList();
      });
      return _timerController?.reset();
    }
    return _timerController?.resume();
  }

  void _restartPuzzle(BuildContext context) async {
      // _stopTimer();
    _timerController?.stop();
    final bool selected = await _showShuffleDialog(context);
    if(selected) {
      setState(() {
        shuffleList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isRunning = _timerController.isRunning;

    return Scaffold(
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
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 64, 
            vertical: 16
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimerControls(timerController: _timerController!),
              Row( /* Game Settings */
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text('$rounds jogadas', textAlign: TextAlign.end,)),
                  SizedBox(
                    width: 128,
                    child: TextButton(
                      onPressed: () async => _changeLevel(context),  
                      child: Text('Nível: $level')
                    ) 
                  ),
                ]
              ),
              Expanded(child: 
                GridView.count(
                  crossAxisCount: level,
                  padding: EdgeInsets.all(64),
            
                  children: [for (var value in list) 
                    ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        shape: LinearBorder(),
                      ),
                      child:Text('$value')
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() =>rounds++);
                        _timerController?.start();
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
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _restartPuzzle(context),
        tooltip: 'Reiniciar',
        child: const Icon(Icons.restart_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
            child: Text('Confimar')
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
