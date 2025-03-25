import 'package:muhajir_quran/app/base_project/components/dio_ext.dart';

import '../../base_project/components/base_dio_data_source.dart';

class HomeDataSource extends BaseDioDataSource {
  HomeDataSource(super.client);

  Future apiHomeList() {
    String path = 'surah';
    return get(path).load();
  }

  Future<String> apiHomeDetail(String noSurah) {
    String path = 'surah/$noSurah';
    return get<String>(path).load();
  }
}