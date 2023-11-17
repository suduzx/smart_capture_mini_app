import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/enum/exception_enum.dart';
import 'package:dio/dio.dart';

class ResponseException extends DioErrorExt {
  ResponseException({
    required RequestOptions requestOptions,
    Response? response,
  }) : super(
          requestOptions: requestOptions,
          exceptionEnum: ExceptionEnum.responseException,
          title: 'Thông báo',
          response: response,
        );

  @override
  String toString() {
    final data = response?.data;
    if (data != null) {
      try {
        final res = ApiResponse.fromJson(data, null);
        final desc = res.soaErrorDesc;
        if (desc != null) return desc;
      } on Exception {
        return 'Có lỗi xảy ra, vui lòng liên hệ quản trị để biết thêm chi tiết';
      }
    }
    return 'Có lỗi xảy ra';
  }
}
