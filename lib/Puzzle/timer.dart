import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_mobile/Puzzle/puzzle.dart';

class TimerSettings extends StatelessWidget {
  const TimerSettings({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    // final TimerController timer = context.watch<PuzzleController>().timer;
    final PuzzleController puzzle =  context.watch<PuzzleController>();

    return Row( /* Stopwatch */
      mainAxisAlignment: MainAxisAlignment.center,
      children: [  
        SizedBox( /* Reset Button */
          width: 128,
          child: ElevatedButton(
            onPressed: puzzle.timer.elapsed.inMilliseconds > 0 
              ? puzzle.resetCounts
              : null, 
            child: Text('Reset')
          ) 
        ),
        Expanded(child: /* Timer */
          Text('${puzzle.timer.elapsed}', 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        ),
        SizedBox( /* Start/Stop Button */
          width: 128,
          child: ElevatedButton(
            onPressed: 
              (puzzle.timer.isRunning  
                ? puzzle.timer.stop 
                : puzzle.timer.start
              ),
            child: Text(
              puzzle.timer.elapsed.inMilliseconds > 0  
              ? (puzzle.timer.isRunning 
                ? 'Parar' 
                : 'Retornar'
              ) : 'Iniciar'
            ), 
          ) 
        ),
        
      ],
    );
  }
}

class TimerController extends ChangeNotifier {
  final Stopwatch _stopwatch = Stopwatch();
  Timer _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {});

  Duration get elapsed => _stopwatch.elapsed;
  bool get isRunning => _stopwatch.isRunning;
  bool get alreadyRan => _stopwatch.elapsed > Duration.zero;

  void start() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) => notifyListeners());
    _stopwatch.start();    
    notifyListeners();
  }

  void stop() {
    _stopwatch.stop();
    notifyListeners();
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _timer.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }
}
