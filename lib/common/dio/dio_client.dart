import 'package:dio/dio.dart';
import 'package:msa/common/dio/dio_login_interceptor.dart';

final dio = Dio(
  BaseOptions(
    // baseUrl:Constants.serverUrl,
    // baseUrl: 'https://app.m-sa.jp/stg/backend/public/',
    baseUrl: 'https://app.m-sc.jp/live/backend/public/',
    headers: <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    receiveDataWhenStatusError: true,
    connectTimeout: 60 * 1000, // 60 seconds
    receiveTimeout: 60 * 1000,
  ),
)..interceptors.add(Logging());
