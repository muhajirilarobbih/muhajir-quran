import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:muhajir_quran/app/base_project/components/storage_util.dart';

class Network {
  static Dio dioClient() {
    StorageUtil storage = Get.find();
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(seconds: 40),
    );
    final Dio dio = Dio(options);
    dio.interceptors.add(InterceptorsWrapper(onRequest: (option, handle) async {
      final token = await storage.getUserToken();
      option.headers["Accept-Language"] = "id-ID";
      log("masuk network 1");
      if (token != null) {
        log("masuk network 1.1");
        option.headers["Authorization"] = "Bearer $token";
      }
      return handle.next(option);
    }, onError: (DioException e, handler) async {
      return handler.next(e);
    }));
    dio.interceptors.add(LogInterceptor(responseBody: true,requestBody: true, requestHeader: true));
    return dio;
  }
}