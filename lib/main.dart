import 'package:flutter/material.dart';
import 'package:music_player/src/screens/screens.dart';
import 'package:music_player/src/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      home: const MusicPlayerScreen(),
    );
  }
}