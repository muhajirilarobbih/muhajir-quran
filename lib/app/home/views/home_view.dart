import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhajir_quran/app/home/model/quran_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Al-Qur'an",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        body: GetBuilder<HomeController>(builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RefreshIndicator(
              onRefresh: () {
                controller.getListQuran();
                return Future.value();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  searchSurat(context),
                  const SizedBox(
                    height: 10,
                  ),

                  Expanded(
                      child: controller.itemQuran.isEmpty
                          ?
                      ListView.builder(
                          controller: controller.scrollController,
                          itemCount: 4,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Skeletonizer(
                              enabled: true,
                              child: itemQuranList(context, controller.filteredSurahs.elementAtOrNull(0),0),
                            );
                          })
                       // Tampilkan loading jika data belum ada
                          : ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.itemQuran.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item =
                                controller.filteredSurahs.elementAtOrNull(index);
                            return Skeletonizer(
                              enabled: item == null,
                              child: itemQuranList(context, item,index),
                            );
                          }))
                ],
              ),
            ),
          );
        }));
  }

  Widget itemQuranList(BuildContext context, QuranModel? data,int page) {
    return buildSurahTile(
        "${data?.namaLatin} (${data?.jumlahAyat} Ayat)",
        data?.arti ?? "",
        data?.nama ?? "",
        data?.nomor.toString() ?? "",
        page,
        data?.nomor ?? 0,
    ) ;
  }

  Widget buildSurahTile(
      String title,
      String subtitle,
      String arabic,
      String no,
      int page,
      int noSurat) {
    return Card(
      shadowColor: Colors.green,
      child: ListTile(
        focusColor: Colors.green,
        hoverColor: Colors.green,
        onTap: () {
          controller.toDetailQuran(page,noSurat);
        },
        leading: Text(no,style: const TextStyle(fontWeight: FontWeight.bold ,fontSize: 20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold ,color: Colors.green)),
        subtitle: Text(subtitle),
        trailing: Text(
          arabic,
          style: const TextStyle(fontSize: 26,fontWeight: FontWeight.bold, fontFamily: 'Traditional Arabic'),
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
