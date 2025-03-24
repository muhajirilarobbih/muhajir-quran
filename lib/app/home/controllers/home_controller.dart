import 'package:get/get.dart';
import 'package:muhajir_quran/app/home/repository/home_repository.dart';

import '../repository/home_repository.dart';


class HomeController extends GetxController {
  final HomeRepository _repository;

  HomeController(this._repository);

  var count = 0.obs;

  void increment() {
    count++;
  }
}