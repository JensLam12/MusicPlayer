import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier {
  bool _playing = false;
  late AnimationController _controller;
  Duration _songDuration = const Duration( milliseconds: 0);
  Duration _current = const Duration( milliseconds: 0);

  String get songTotalDuration => printDuration( _songDuration );
  String get currentSecond => printDuration( _current );
  double get percentage => ( _songDuration.inSeconds > 0) ? _current.inSeconds / _songDuration.inSeconds : 0 ;

  AnimationController get controller => _controller;
  set controller( AnimationController value) {
    _controller = value;
  }

  bool get playing => _playing;
  set playing( bool value) {
    _playing = value;
    notifyListeners();
  }

  Duration get songDuration => _songDuration;
  set songDuration( Duration value) {
    _songDuration = value;
    notifyListeners();
  }
  
  Duration get current => _current;
  set current( Duration value) {
    _current = value;
    notifyListeners();
  }

  String printDuration( Duration duration) {
    String twoDigits( int n) {
      if( n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits( duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits( duration.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}