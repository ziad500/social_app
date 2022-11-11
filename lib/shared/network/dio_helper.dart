import 'package:dio/dio.dart';

class DioHelper {
  static late Dio? dio;
  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token
    };
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData(
      {required String url,
      Map<String, dynamic>? query,
      String lang = 'en',
      String token =
          'P0E4Iq75a0iRCMlshF6R3QHOWXXaN3Qt3c8iFg0EbjAbT8hAtAiPtddLQzCNVampcmfMMk',
      required Map<String, dynamic> data}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };

    return dio!.post(url, queryParameters: query, data: data);
  }
}
