import 'package:get/get.dart';
import 'package:muhajir_quran/app/home/controllers/home_controller.dart';
import 'package:muhajir_quran/app/home/repository/home_data_source.dart';
import 'package:muhajir_quran/app/home/repository/home_repository.dart';
import '../../base_project/components/network.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(Get.find()), fenix: true);
    Get.lazyPut(() => HomeRepository(Get.find()));
    Get.lazyPut(() => HomeDataSource(Network.dioClient()));
  }
}