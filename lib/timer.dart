import 'dart:async';
import 'package:flutter/material.dart';

class TimerController extends ChangeNotifier {
  final refreshRate = 100;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Duration get elapsed => _stopwatch.elapsed;
  bool get isRunning => _stopwatch.isRunning;

  void start() {
    if(_timer != null) return;

    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: refreshRate), (_) {
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
      _timer = Timer.periodic(Duration(milliseconds: refreshRate), (_) {
        notifyListeners();
      });
      _stopwatch.start();
      notifyListeners();
    } else {
      return;
    }
  }

  void reset() {
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
