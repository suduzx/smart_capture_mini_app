import 'package:dio/dio.dart';
import 'package:smart_capture_mobile/enum/exception_enum.dart';

class DioErrorExt extends DioError {
  final String title;
  final ExceptionEnum exceptionEnum;
  String? icon;

  DioErrorExt({
    required super.requestOptions,
    required this.exceptionEnum,
    required this.title,
    super.response,
    this.icon,
  });
}
