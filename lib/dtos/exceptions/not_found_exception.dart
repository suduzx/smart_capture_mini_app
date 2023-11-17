import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/enum/exception_enum.dart';
import 'package:dio/dio.dart';

class NotFoundException extends DioErrorExt {
  NotFoundException(RequestOptions r)
      : super(
          requestOptions: r,
          exceptionEnum: ExceptionEnum.serviceUnavailableException,
          title: 'Lỗi truy vấn dịch vụ',
        );

  @override
  String toString() {
    return 'Không thể tìm thấy thông tin truy vấn dịch vụ';
  }
}
