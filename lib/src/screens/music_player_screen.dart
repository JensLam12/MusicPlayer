import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/audio_player.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          Column(
            children: const [
              CustomAppBar(),
              _CoverDiskDuration(),
              _PlayerBar(),
              Expanded(
                child: _Lyrics()
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.75,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only( bottomLeft: Radius.circular(60) ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft ,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28)
          ]
        )
      ),
    );
  }
}

class _Lyrics extends StatelessWidget {
  const _Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final lyrics = getLyrics();

    return Container(
      margin: const EdgeInsets.only( top: 10),
      padding: const EdgeInsets.symmetric( horizontal: 20),
      child: ListWheelScrollView(
        physics: const BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 2,
        children: lyrics.map(
          ( line) => Text( line, style: TextStyle( fontSize: 15, color: Colors.white.withOpacity( 0.6)) )
        ).toList(),
      ),
    );
  }
}

class _PlayerBar extends StatefulWidget {
  const _PlayerBar({
    Key? key,
  }) : super(key: key);

  @override
  State<_PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<_PlayerBar> with SingleTickerProviderStateMixin{

  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController playAnimination;
  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimination = AnimationController(vsync: this, duration: const Duration( milliseconds:  500));
    super.initState();
  }

  @override
  void dispose() {
    playAnimination.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
    assetAudioPlayer.open( Audio( 'assets/super sonic.mp3'), autoStart: true, showNotification: true );

    assetAudioPlayer.currentPosition.listen( ( duration ) { 
      audioPlayerModel.current = duration;
    });

    assetAudioPlayer.current.listen( ( playingAudio ) { 
      audioPlayerModel.songDuration = playingAudio?.audio.duration ?? const Duration( seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 40),
      margin: const EdgeInsets.only( top: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( 'Supersonic', style: TextStyle( fontSize: 30, color: Colors.white.withOpacity(0.8)) ),
              Text( 'Bad Religion', style: TextStyle( fontSize: 15, color: Colors.white.withOpacity(0.3)) ),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: const Color(0xffF8CB51),
            onPressed: () {

              final audioPlayerModel = Provider.of<AudioPlayerModel>( context, listen: false);

              if( isPlaying ) {
                playAnimination.reverse();
                isPlaying = false;
                audioPlayerModel.controller.stop();
              } else {
                playAnimination.forward();
                isPlaying = true;
                audioPlayerModel.controller.repeat();
              }

              if( firstTime) {
                open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            child: AnimatedIcon( 
              icon: AnimatedIcons.play_pause,
              progress: playAnimination
            ),
          )
        ]
      ),
    );
  }
}

class _CoverDiskDuration extends StatelessWidget {
  const _CoverDiskDuration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 20),
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _CoverDisc(),
          SizedBox( width: 20),
          _ProgressBar(),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(color: Colors.white.withOpacity(0.4));
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final percentage = audioPlayerModel.percentage;

    return Column(
      children: [
        Text( audioPlayerModel.songTotalDuration, style: textStyle),
        const SizedBox( height: 10 ),
        Stack(
          children: [
            Container(
              width: 3,
              height: 230,
              color: Colors.white.withOpacity(0.1),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 3,
                height: 230 * percentage,
                color: Colors.white.withOpacity(0.8),
              ),
            )
          ],
        ),
        const SizedBox( height: 10 ),
        Text( audioPlayerModel.currentSecond, style: textStyle),
      ],
    );
  }
}

class _CoverDisc extends StatelessWidget {
  const _CoverDisc({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24)
          ]
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: const Duration( seconds: 10 ),
              infinite: true,
              manualTrigger: true,
              controller: ( animationController ) => audioPlayerModel.controller = animationController,
              child: const Image( image: AssetImage('assets/cover.jpg') )
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(100)
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0XFF1C1C25),
                borderRadius: BorderRadius.circular(100)
              ),
            )
          ],
        ),
      ),
    );
  }
}