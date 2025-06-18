import 'dart:async';
import 'package:flutter/material.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  /* Game Settings*/
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsed = "0:000";

  /* Level Settings */
  int level = 4; // Nível do Puzzle
  // int puzzleLength;

  /* Player Settings */
  int rounds = 0; // Numero de Jogadas


  Timer _createTimer() {
    return Timer.periodic(Duration(milliseconds: 16), (_) {
      setState(() {
        _elapsed = (_stopwatch.elapsed.inMilliseconds/1000).toStringAsFixed(3);
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
      _elapsed = "0.000";
      rounds = 0;
    });
  }
  void incrementRounds() {
    _startTimer();
    setState(() {
      rounds++;
    });
  }

  void shuffle() {
    setState(() {
      _resetTimer();
      rounds = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int length = (level * level);
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
                  ElevatedButton(onPressed: _resetTimer, child: Text('Reset')),
                  Expanded(child: 
                    Text('Timer: ${_elapsed.toString()}s', 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                  ElevatedButton(
                    onPressed: isRunning ? _stopTimer : _resumeTimer,
                    child: Text(isRunning ? 'Stop' : 'Resume'), 
                  )
                ],
              ),
              Row( /* Game Settings */
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text('$rounds jogadas')),
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        // actionsAlignment: MainAxisAlignment.center,
                        title: const Text('Nível de Dificuldade'),
                        content: const Text('Escolha o nível de dificuldade:'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                            child: Text('Fácil (2x2)')
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            }, 
                            child: Text('Médio (3x3)')
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            }, 
                            child: Text('Difícil (4x4)')
                          ),
                        ],
                      )
                    ),  
                    child: Text('Nível: $level')
                  ),
                ],
              ),
              Expanded(child: 
                GridView.count(
                  crossAxisCount: level,
                  padding: EdgeInsets.all(64),
                  children: List.generate(length, (index) {
                    var value = index + 1;
                
                    return ElevatedButton(
                      onPressed: value >= length ? () => incrementRounds() : null,
                      style: ElevatedButton.styleFrom(
                        shape: LinearBorder(),
                      ),
                      child: 
                        Text(value < length ? "$value" : ""), 
                    );
                  })
                  ,
                ),
              )
            ]
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => shuffle(),
        tooltip: 'Increment',
        child: const Icon(Icons.shuffle),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
