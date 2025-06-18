import 'package:flutter/material.dart';
import 'timer.dart';

class TimerControls extends StatelessWidget {
  final TimerController timerController;
  const TimerControls({
    super.key, 
    required this.timerController
  });

  @override
  Widget build(BuildContext context) {
    return Row( /* Stopwatch */
      mainAxisAlignment: MainAxisAlignment.center,
      children: [  
        SizedBox(
          width: 128,
          child: ElevatedButton(onPressed: timerController.reset, child: Text('Reset')) 
        ),
        Expanded(child: 
          Text('${timerController.elapsed}', 
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
            onPressed: 
              timerController.elapsed.inMilliseconds > 0 
                ? (timerController.isRunning  
                  ? timerController.stop 
                  : timerController.resume
                ) : null,
            child: Text(
              timerController.elapsed.inMilliseconds > 0 
                ? (timerController.isRunning 
                  ? 'Parar' 
                  : 'Retornar'
                ) : 'Iniciar'), 
          ) 
        ),
        
      ],
    );
  }
}
