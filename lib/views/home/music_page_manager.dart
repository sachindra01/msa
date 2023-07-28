

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PageManagerController extends GetxController {
  // PageManager({required this.url});
  var url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'.obs;
  var isVisible = false.obs;
  var isPlaying = false.obs;
  var radioTitle = '';
  var albumArt ='';
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  final AudioPlayer audioPlayer = AudioPlayer();
  



  void init() async {
   
    try {
      await audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(
            url.value),
            tag: MediaItem(
              id: "", 
              title: radioTitle,
              artUri: Uri.parse(albumArt))
            ));
            }catch(e){
                if (kDebugMode) {
                  print(e);
                }
    }

    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });

    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    // init();
   Future.delayed(Duration.zero,(() => audioPlayer.play()));
   
  }

  void pause() {
    audioPlayer.pause();
    
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }


  void setSpeed(double speed){
    audioPlayer.setSpeed(speed);
  }
  
  
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }


