import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text("Counter: ${controller.count}", style: const TextStyle(fontSize: 20))),
            ElevatedButton(
              onPressed: controller.increment,
              child: const Text("Increment"),
            ),
          ],
        ),
      ),
    );
  }

}