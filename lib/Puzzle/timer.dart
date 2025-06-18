import 'dart:async';

import 'package:flutter/material.dart';

class TimerSettings extends StatelessWidget {
  final TimerController timer;
  const TimerSettings({
    super.key, 
    required this.timer
  });

  @override
  Widget build(BuildContext context) {
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
// TODO: Entender porque TimeController é ChangeNotifier e nao um State
class TimerController extends ChangeNotifier {
  final refreshRate = 100;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Duration get elapsed => _stopwatch.elapsed;
  bool get isRunning => _stopwatch.isRunning;

  void start() {
    if(_timer != null) return;

    _stopwatch.start();
    _timer = Timer.periodic(
        Duration(milliseconds: refreshRate), (_) {
      notifyListeners();
    });
    
    notifyListeners();
  }

  void stop() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;

    notifyListeners();
  }

  void resume() {
    if (_timer == null) {
      _timer = Timer.periodic(
          Duration(milliseconds: refreshRate), (_) {
        notifyListeners();
      });
      _stopwatch.start();
      notifyListeners();
    } else {
      return;
    }
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
