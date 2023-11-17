import 'package:smart_capture_mobile/enum/exception_enum.dart';

abstract class Failure {
  final String title;
  final ExceptionEnum? exceptionEnum;
  final String? message;
  final String? icon;

  const Failure({
    required this.title,
    this.exceptionEnum,
    this.message,
    this.icon,
  });
}

class DioErrorFailure extends Failure {
  const DioErrorFailure({
    required String title,
    required ExceptionEnum exceptionEnum,
    required String message,
    String? icon,
  }) : super(
            title: title,
            exceptionEnum: exceptionEnum,
            message: message,
            icon: icon);
}

class UnknownFailure extends Failure {
  const UnknownFailure({String? message})
      : super(title: '', message: message ?? 'Có lỗi xảy ra, vui lòng thử lại');
}
