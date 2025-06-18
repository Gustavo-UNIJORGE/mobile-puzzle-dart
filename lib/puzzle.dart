import 'dart:async';
import 'package:flutter/material.dart';

class Puzzle extends StatefulWidget {
  const Puzzle({super.key});

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  /* Game Settings*/
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Duration _elapsed = Duration();

  /* Level Settings */
  int level = 2; // Nível do Puzzle
  List<int> list = [];
  /* Player Settings */
  int rounds = 0; // Numero de Jogadas


  Timer _createTimer() {
    return Timer.periodic(Duration(milliseconds: 16), (_) {
      setState(() {
        // _elapsed = (_stopwatch.elapsed.inMilliseconds/1000).toStringAsFixed(3);
        _elapsed = _stopwatch.elapsed;
      });
    });
  }

  void _startTimer() {
    if(_timer != null) return;

    _stopwatch.start();
    _timer = _createTimer();
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
    setState(() {
      _timer = null;
    });
  }

  void _resumeTimer() {
    _timer = _createTimer();
    setState(() {
      _stopwatch.start();
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _stopwatch.reset();
      _elapsed = Duration();
      rounds = 0;
    });
  }
  void incrementRounds() {
    _startTimer();
    setState(() {
      rounds++;
    });
  }



  void _selectLevel(BuildContext context) async {
    setState(() {
      _stopTimer();
    });
    final int? selected = await _showLevelDialog(context);
    if (selected != null && selected != level) {
      setState(() {
        level = selected;
        _resetTimer();
      });
    }
  }

  void _initPuzzle() {
    final length = level * level; 
    setState(() {
      list = List.generate(length - 1, (i) => i + 1)..shuffle(); 
    });
  }

  void _restartPuzzle(BuildContext context) async {
    setState(() {
      _stopTimer();
    });
    final bool selected = await _showShuffleDialog(context);
    if(selected) {
      setState(() {
        _shuffleList();
      });
    }
  }

  void _shuffleList() {
    setState(() {
      _resetTimer();
      list.shuffle();
      rounds = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPuzzle();    
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isRunning = _stopwatch.isRunning;

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
              Row( /* Stopwatch */
                mainAxisAlignment: MainAxisAlignment.center,
                children: [  
                  SizedBox(
                    width: 128,
                    child: ElevatedButton(onPressed: _resetTimer, child: Text('Reset')) 
                  ),
                  Expanded(child: 
                    Text('$_elapsed', 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                  SizedBox(
                    width: 128,
                    child: ElevatedButton(
                      onPressed: isRunning ? _stopTimer : _resumeTimer,
                      child: Text(isRunning ? 'Parar' : 'Continuar'), 
                    ) 
                  ),
                  
                ],
              ),
              Row( /* Game Settings */
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text('$rounds jogadas', textAlign: TextAlign.end,)),
                  SizedBox(
                    width: 128,
                    child: TextButton(
                      onPressed: () async => _selectLevel(context),  
                      child: Text('Nível: $level')
                    ) 
                  ),
                  
                ],
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
                      onPressed: () => incrementRounds(),
                      style: ElevatedButton.styleFrom(
                        shape: LinearBorder(),
                      ),
                      child:Text('')
                    )
                  ]
                ),
              )
            ]
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