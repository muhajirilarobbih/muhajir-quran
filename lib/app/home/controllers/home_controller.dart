import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muhajir_quran/app/base_project/components/state.dart';
import 'package:muhajir_quran/app/base_project/routes/app_routes.dart';
import 'package:muhajir_quran/app/home/model/quran_detail_model.dart';
import 'package:muhajir_quran/app/home/model/quran_model.dart';
import 'package:muhajir_quran/app/home/repository/home_repository.dart';

import '../../base_project/components/loading_screen.dart';


class HomeController extends GetxController {
  final HomeRepository _repository;

  HomeController(this._repository);

  final TextEditingController controllerSearch = TextEditingController();
  final scrollController = ScrollController();
  List<QuranModel> filteredSurahs = []; // List yang difilter
  final RxList<QuranDetailModel> listAyatData = <QuranDetailModel>[].obs;

  var currentPage = 0; // Index PageView
  var itemQuran = <QuranModel>[].obs; // Data Surah
  var filteredListAyatData = <Ayat>[].obs; // Data Ayat
  var isLoading = false.obs; // State untuk loading
  var pageController = PageController();

  AudioPlayer audioPlayer = AudioPlayer();
  int nomorSurat = 1;
  bool ayahSelected = false;

  var count = 0.obs;

  var isPlaying = false.obs;
  var currentSurah = "".obs;

  void cekTextUpdate() {
    update();
  }
  void ayahSelectedFunc() {
    ayahSelected = !ayahSelected;
    update();
  }

  void increment() {
    count++;
  }

  void filterSurahs(String query) {
    filteredSurahs = itemQuran
        .where((surah) => surah.namaLatin!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> playAudio(String url, String surahName) async {
    try {
      isPlaying.value = !isPlaying.value;
      if (isPlaying.value ) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.setUrl(url);
        await audioPlayer.play();
        // isPlaying.value = true;
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

  @override
  Future<void> onInit() async {
    super.onInit();
    pageController = PageController(initialPage: currentPage);
    await getListQuran();
    Future.delayed(Duration.zero, () {
      // Sekarang `context` tersedia
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Welcome to the app!")),
      );
      showLoading(Get.context!);
    });
  }

  void changePage(int index) {
    currentPage = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    update(); // Perbarui UI
  }

  void showLoading(BuildContext context) {
    LoadingScreen().show(context: context, text: "Mohon Tunggu");
  }

  Future<void> getListQuran() async {
    _repository.getQuranList(
        response: ResponseHandler(
            onSuccess: (data) async {
              itemQuran.value = data!;
              filteredSurahs = data;
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
              LoadingScreen().hide();
            },
            onDone: () {
              update();
            })
    );
  }


  Future<void> getDetailQuran(String noSurahId) async {
    isLoading.value = true;
    _repository.getQuranDetail(
      noSurah: noSurahId,
        response: ResponseHandler(
            onSuccess: (data) {
              listAyatData.clear();
              filteredListAyatData.clear();
              listAyatData.add(data);
              filteredListAyatData.addAll(data.ayat ?? []);
              log("cek success $data");
              isLoading.value = false;
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

  Future<void> toDetailQuran(int page,int noSurat) async {
    nomorSurat = noSurat;
    getDetailQuran(noSurat.toString());
    Future.delayed(const Duration(milliseconds: 50)).then((value) => {
    pageController.jumpToPage(page)
    });
    await Get.toNamed(AppRoutes.detailQuran);


  }
}