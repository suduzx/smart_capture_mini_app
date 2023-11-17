import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/business/capture_business_dto.dart';
import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/dtos/exceptions/failures.dart';
import 'package:smart_capture_mobile/dtos/simple_result/api_result.dart';
import 'package:dio/dio.dart';

class CaptureBusinessService {
  final Dio dio;
  final String baseUrl;

  const CaptureBusinessService({
    required this.dio,
    required this.baseUrl,
  });

  Future<Result<ApiResponse<CaptureBusinessDto>, Failure>> get() async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.get<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/capture-businesses',
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, CaptureBusinessDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Đồng bộ cấu hình thất bại',
            exceptionEnum: e.exceptionEnum,
            icon: e.icon,
            message: e.toString(),
          ),
        );
      } else {
        return const Result.failure(UnknownFailure());
      }
    }
  }
}
