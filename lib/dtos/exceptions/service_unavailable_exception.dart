import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/enum/exception_enum.dart';
import 'package:dio/dio.dart';

class ServiceUnavailableException extends DioErrorExt {
  ServiceUnavailableException({required RequestOptions requestOptions})
      : super(
            requestOptions: requestOptions,
            exceptionEnum: ExceptionEnum.serviceUnavailableException,
            title: 'Lỗi dịch vụ',
            icon: 'assets/icons/ic_nonet.svg');

  @override
  String toString() {
    return 'Dịch vụ hiện đang bị gián đoạn, vui lòng thử lại sau ít phút';
  }
}
