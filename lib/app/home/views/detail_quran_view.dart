import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhajir_quran/app/home/model/quran_detail_model.dart';
import 'package:muhajir_quran/app/home/model/quran_model.dart';

import '../controllers/home_controller.dart';

class DetailQuranView extends GetView<HomeController> {
  const DetailQuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
                controller.audioPlayer.stop();
              },
            ),
            title: Text(
              controller.itemQuran.isNotEmpty == true
                  ? "${controller.itemQuran[controller.currentPage].namaLatin.toString()} (${controller.itemQuran[controller.currentPage].jumlahAyat} ayat)"
                  : "Loading...",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
          body: PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) async {
              controller.changePage(index); // Perbarui currentPage saat swipe
              log("cek index = $index");
              await controller.getDetailQuran(controller.itemQuran[index].nomor.toString());
              controller.audioPlayer.stop();
              controller.update(); // Perbarui UI setelah API selesai

            },
            itemCount: controller.itemQuran.length,
            itemBuilder: (context, surahIndex) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text("Play Surah", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    trailing: Obx(() => IconButton(
                      icon: Icon(controller.isPlaying.value
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled , weight: 70),
                      onPressed: () {
                        controller.playAudio(controller.itemQuran[controller.currentPage].audio.toString(), controller.itemQuran[controller.currentPage].namaLatin.toString());
                      },
                    )),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator()); // Tampilkan loading
                      }

                      if (controller.filteredListAyatData.isEmpty) {
                        return const Center(child: Text("Tidak ada data ayat"));
                      }

                      return ListView.builder(
                        itemCount: controller.filteredListAyatData.length,
                        itemBuilder: (context, index) {
                          final ayat = controller.filteredListAyatData[index];

                          return itemDetailQuranLast(ayat);
                        },
                      );
                    }),
                  ),
                ],
              );
            },
          ));
    });
  }

  Widget itemDetailQuranLast (Ayat? ayat) {
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ayat!.nomor.toString(),
                ),
                const SizedBox(width: 10),
                controller.ayahSelected == true ?
                IconButton(
                  icon: const Icon(
                    Icons.bookmark_added,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    controller.ayahSelectedFunc();
                  },
                )
                 : IconButton(
                  icon: const Icon(Icons.bookmark_outline),
                  onPressed: () {
                    controller.ayahSelectedFunc();
                  },
                )

              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                ayat.ar ?? "",
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 26,
                    fontFamily: 'Traditional Arabic'),
              ),
            ),
            const SizedBox(height: 10),
            Text(ayat.idn ?? ""),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget itemQuranList(BuildContext context, QuranModel? data) {
    return buildSurahTile("${data?.namaLatin} (${data?.jumlahAyat} Ayat)",
        data?.arti ?? "", data?.nama ?? "", data?.nomor.toString() ?? "");
  }

  Widget buildSurahTile(
      String title, String subtitle, String arabic, String no) {
    return Card(
      shadowColor: Colors.green,
      child: ListTile(
        focusColor: Colors.green,
        hoverColor: Colors.green,
        leading: Text(no,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green)),
        subtitle: Text(subtitle),
        trailing: Text(
          arabic,
          style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Traditional Arabic'),
        ),
      ),
    );
  }

  Widget searchSurat(BuildContext context) {
    return TextFormField(
      controller: controller.controllerSearch,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
      ),
      textAlignVertical: TextAlignVertical.center,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            icon: const Icon(
              Icons.search,
              size: 22,
              color: Colors.green,
            ),
            onPressed: () {
              controller.controllerSearch.clear();
            },
          ),
        ),
        prefixStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: "Cari Surat....",
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: controller.controllerSearch.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  size: 22,
                  color: Colors.green,
                ),
                onPressed: () {
                  controller.controllerSearch.clear();
                  controller.filterSurahs("");
                  controller.update();
                },
              )
            : null,
      ),
      onChanged: (value) {
        controller.filterSurahs(value);
        controller.update(); // Memperbarui UI agar ikon muncul saat ada input
      },
      textInputAction: TextInputAction.done,
    );
  }
}
