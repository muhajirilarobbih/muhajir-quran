import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:muhajir_quran/app/home/controllers/home_controller.dart';
import 'package:muhajir_quran/app/home/repository/home_repository.dart';
import 'package:just_audio/just_audio.dart';

import '../mocks/mock_home_repository.mocks.dart';

// Mocking dependencies
class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  late HomeController homeController;
  late MockAudioPlayer mockAudioPlayer;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockAudioPlayer = MockAudioPlayer();
    mockHomeRepository = MockHomeRepository();

    // Inject mock repository ke dalam GetX sebelum membuat HomeController
    Get.put<HomeRepository>(mockHomeRepository);

    homeController = HomeController(Get.find());
    homeController.audioPlayer = mockAudioPlayer; // Inject mocked audio player
  });

  group('HomeController Tests', () {
    test('Initial values should be correct', () {
      expect(homeController.currentPage, 0);
      expect(homeController.isPlaying.value, false);
    });

    test('changePage should update currentPage', () {
      homeController.changePage(2);
      expect(homeController.currentPage, 2);
    });

    test('playAudio should start playing audio', () async {
      when(mockAudioPlayer.setUrl("https://santrikoding.com/storage/audio/001.mp3")).thenAnswer((_) async {
        return null;
      });
      when(mockAudioPlayer.play()).thenAnswer((_) async {});

      await homeController.playAudio('https://santrikoding.com/storage/audio/001.mp3', 'Al-Fatihah');

      expect(homeController.isPlaying.value, true);
    });

    test('pauseAudio should pause audio', () async {
      when(mockAudioPlayer.pause()).thenAnswer((_) async {});

      await homeController.audioPlayer.pause();
      expect(homeController.isPlaying.value, false);
    });

    test('stopAudio should stop audio', () async {
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});

      await homeController.audioPlayer.stop();
      expect(homeController.isPlaying.value, false);
    });
  });
}
