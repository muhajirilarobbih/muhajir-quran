import 'package:get/get.dart';
import 'package:muhajir_quran/app/base_project/routes/app_routes.dart';
import 'package:muhajir_quran/app/home/binding/home_binding.dart';

import '../../home/views/detail_quran_view.dart';
import '../../home/views/home_view.dart';

class AppPages {
  static final routes = [
    GetPage(
        name: AppRoutes.home,
        page: () => const HomeView(),
        binding: HomeBinding()
    ),
    GetPage(
        name: AppRoutes.detailQuran,
        page: () => const DetailQuranView(),
        binding: HomeBinding()
    ),
  ];
}