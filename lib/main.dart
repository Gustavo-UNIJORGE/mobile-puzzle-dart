import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PuzzlePage(),
    );
  }
}

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsed = "0:000";

  int rounds = 0; // Numero de Jogadas
  int level = 4; // Nível do Puzzle

  void _startTimer() {
    if(_timer != null) return;
    
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 16), (_) {
      setState(() {
        _elapsed = (_stopwatch.elapsed.inMilliseconds/1000).toStringAsFixed(3);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _stopwatch.stop();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _stopwatch.reset();
      _elapsed = "0.000";
    });
  }
  void incrementRounds() {
    if (_timer == null) _startTimer();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _resetTimer, child: Text('Reset')),
                Expanded(child: 
                  Text('Timer: ${_elapsed.toString()}s')),
              ],
            ),
            Text('$rounds jogadas'),
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
          ],
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
