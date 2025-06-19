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
    final TimerController timer = context.watch<PuzzleController>().timer;

    return Row( /* Stopwatch */
      mainAxisAlignment: MainAxisAlignment.center,
      children: [  
        SizedBox( /* Reset Button */
          width: 128,
          child: ElevatedButton(
            onPressed: timer.elapsed.inMilliseconds > 0 
              ? timer.reset 
              : null, 
            child: Text('Reset')
          ) 
        ),
        Expanded(child: /* Timer */
          Text('${timer.elapsed}', 
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
              timer.elapsed.inMilliseconds > 0 
                ? (timer.isRunning  
                  ? timer.stop 
                  : timer.resume
                ) : null,
            child: Text(
              timer.elapsed.inMilliseconds > 0 
                ? (timer.isRunning 
                  ? 'Parar' 
                  : 'Retornar'
                ) : 'Iniciar'), 
          ) 
        ),
        
      ],
    );
  }
}

class TimerController extends ChangeNotifier {
  final refreshRate = 100;
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  Duration get elapsed => _stopwatch.elapsed;
  bool get isRunning => _stopwatch.isRunning;

  TimerController() {
    _setTimer();
  }

  void _setTimer() {
    // if(_timer.isActive) _timer.cancel();
    _timer = Timer.periodic(
      Duration(
        milliseconds: refreshRate), 
      (_) => notifyListeners()
    );
  }

  void setup() {
    _setTimer();
    notifyListeners();
  }

  void start() {
    _setTimer();
    _stopwatch.start();    
    notifyListeners();
  }

  void stop() {
    _stopwatch.stop();
    _timer.cancel();
    notifyListeners();
  }

  void resume() {
    _setTimer();
    _stopwatch.start();
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
