import 'package:smart_capture_mobile/dtos/auth/auth_message.dart';
import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/enum/exception_enum.dart';
import 'package:dio/dio.dart';

class UnauthorizedException extends DioErrorExt {
  UnauthorizedException({
    required RequestOptions requestOptions,
    Response? response,
  }) : super(
            requestOptions: requestOptions,
            exceptionEnum: ExceptionEnum.unauthorizedException,
            title: 'Cảnh báo quyền truy cập',
            response: response,
            icon: 'assets/icons/baseline-gpp-bad.svg');

  @override
  String toString() {
    final data = response?.data;

    if (data != null) {
      final mess = AuthMessage.fromJson(data);
      final errorDesc = mess.errorDescription;
      if (errorDesc != null) return errorDesc;
    }

    return 'Không có quyền truy cập, vui lòng liên hệ quản trị viên';
  }
}
