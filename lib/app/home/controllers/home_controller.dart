import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhajir_quran/app/base_project/components/state.dart';
import 'package:muhajir_quran/app/home/model/quran_model.dart';
import 'package:muhajir_quran/app/home/repository/home_repository.dart';


class HomeController extends GetxController {
  final HomeRepository _repository;

  HomeController(this._repository);

  final TextEditingController controllerSearch = TextEditingController();
  final scrollController = ScrollController();
  List<QuranModel>? itemQuran; // List all surah
  List<QuranModel> filteredSurahs = []; // List yang difilter

  var count = 0.obs;

  void cekTextUpdate() {
    update();
  }

  void increment() {
    count++;
  }

  void filterSurahs(String query) {
    filteredSurahs = itemQuran
        !.where((surah) => surah.namaLatin!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getListQuran();
  }

  Future<void> getListQuran() async {
    _repository.getQuranList(
        response: ResponseHandler(
            onSuccess: (data) {
              itemQuran = data;
              filteredSurahs = data!;
              log("cek success $data");
              update();
            },
            onFailed: (responseError, message) async {
              update();
              final String errorString = responseError.response.toString();
              log("cek error $message");
              Get.snackbar(
                "Peringatan!",
                errorString,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onDone: () {
              update();
            })
    );
  }
}