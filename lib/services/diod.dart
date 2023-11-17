import 'package:smart_capture_mobile/services/interceptors/error_interceptor.dart';
import 'package:smart_capture_mobile/services/interceptors/network_interceptor.dart';
import 'package:dio/dio.dart';

class DioD {
  Dio get dio {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 10).inMilliseconds;
    dio.options.receiveTimeout = const Duration(seconds: 10).inMilliseconds;

    dio.interceptors.add(NetworkInterceptor());
    // dio.interceptors.add(JsonResponseConverter());
    dio.interceptors.add(ErrorInterceptor());
    // dio.interceptors.add(AuthInterceptor(bloc: getIt<AppBloc>()));
    // dio.interceptors.add(LoggyDioInterceptor(
    //   responseBody: true,
    //   requestBody: true,
    // ));

    return dio;
  }
}
