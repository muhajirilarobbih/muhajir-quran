import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';

import 'app/base_project/components/storage_util.dart';
import 'app/base_project/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
  await _dependencyInjection();
  mainContext.config = ReactiveConfig.main.clone(
    readPolicy: ReactiveReadPolicy.never,
    writePolicy: ReactiveWritePolicy.never,
    disableErrorBoundaries: true,
    isSpyEnabled: true,
  );
  runApp(const MyApp());
}

Future _dependencyInjection() async {
  final storage = StorageUtil(SecureStorage());
  Get.lazyPut(() => storage, fenix: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al Quran',
      initialRoute: '/',
      getPages: AppPages.routes,
    );
  }
}
