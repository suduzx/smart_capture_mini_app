import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/enum/exception_enum.dart';
import 'package:dio/dio.dart';

class TimeoutException extends DioErrorExt {
  TimeoutException(RequestOptions r)
      : super(
            requestOptions: r,
            exceptionEnum: ExceptionEnum.timeoutException,
            title: 'Lỗi kết nối mạng',
            icon: 'assets/icons/ic_nonet.svg');

  @override
  String toString() {
    return 'Xin vui lòng kiểm tra lại kết nối mạng của bạn!';
  }
}
