import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:muhajir_quran/app/home/controllers/home_controller.dart';
import 'package:muhajir_quran/app/home/views/detail_quran_view.dart';

void main() {
  testWidgets('DetailQuranView should show loading indicator initially',
          (WidgetTester tester) async {
        Get.put(HomeController(Get.find()));

        await tester.pumpWidget(
          const GetMaterialApp(
            home: DetailQuranView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('Play button should trigger playAudio',
          (WidgetTester tester) async {
        final controller = Get.put(HomeController(Get.find()));
        controller.isPlaying.value = false;

        await tester.pumpWidget(
          const GetMaterialApp(
            home: DetailQuranView(),
          ),
        );

        final playButton = find.byIcon(Icons.play_circle_filled);
        expect(playButton, findsOneWidget);

        await tester.tap(playButton);
        await tester.pump();

        expect(controller.isPlaying.value, true);
      });

  testWidgets('Pause button should trigger pauseAudio',
          (WidgetTester tester) async {
        final controller = Get.put(HomeController(Get.find()));
        controller.isPlaying.value = true;

        await tester.pumpWidget(
          const GetMaterialApp(
            home: DetailQuranView(),
          ),
        );

        final pauseButton = find.byIcon(Icons.pause_circle_filled);
        expect(pauseButton, findsOneWidget);

        await tester.tap(pauseButton);
        await tester.pump();

        expect(controller.isPlaying.value, false);
      });
}
