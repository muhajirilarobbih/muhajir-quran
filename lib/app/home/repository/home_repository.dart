import 'dart:developer';

import 'package:muhajir_quran/app/home/model/quran_detail_model.dart';
import 'package:muhajir_quran/app/home/model/quran_model.dart';
import 'package:muhajir_quran/app/home/repository/home_data_source.dart';

import '../../base_project/components/base_repository.dart';
import '../../base_project/components/state.dart';

class HomeRepository extends BaseRepository {
  final HomeDataSource _dataSource;

  HomeRepository(this._dataSource);

  void getQuranList(
      {required ResponseHandler<List<QuranModel>?> response}) async {
    try {
      final data = await _dataSource.apiHomeList();

      // Pastikan data berupa List dan lakukan mapping ke QuranModel
      final List<QuranModel> list = (data as List)
          .map((json) => QuranModel.fromJson(json))
          .toList();

      response.onSuccess.call(list);
      response.onDone.call();
    } catch (e, data) {
      log("cek error " + e.toString() + " " + data.toString());
      response.onFailed(e, e.toString());
      response.onDone.call();
    }
  }
  void getQuranDetail(
      {required String noSurah,
        required ResponseHandler<QuranDetailModel?> response}) async {
    try {
      final data = await _dataSource
          .apiHomeDetail(noSurah)
          .then(mapToData)
          .then((value) {
        final response = QuranDetailModel.fromJson(value);
        return response;
      });
      response.onSuccess.call(data);
      response.onDone.call();
    } catch (e, _) {
      response.onFailed(e, e.toString());
      response.onDone.call();
    }
  }
}