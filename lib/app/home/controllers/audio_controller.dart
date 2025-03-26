import 'dart:developer';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var currentSurah = "".obs;

  Future<void> playAudio(String url, String surahName) async {
    try {
      if (isPlaying.value && currentSurah.value == surahName) {
        await audioPlayer.pause();
        isPlaying.value = false;
      } else {
        await audioPlayer.setUrl(url);
        await audioPlayer.play();
        isPlaying.value = true;
        currentSurah.value = surahName;
      }
    } catch (e) {
      log("Error playing audio: $e");
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}