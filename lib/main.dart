import 'package:flutter/material.dart';
import 'package:music_player/src/models/audio_player.dart';
import 'package:music_player/src/screens/screens.dart';
import 'package:music_player/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => AudioPlayerModel() )
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: mainTheme,
        debugShowCheckedModeBanner: false,
        home: const MusicPlayerScreen(),
      ),
    );
  }
}