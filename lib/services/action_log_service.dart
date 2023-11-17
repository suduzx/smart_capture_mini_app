import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/business/action_log_dto.dart';
import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/dtos/exceptions/failures.dart';
import 'package:smart_capture_mobile/dtos/simple_result/api_result.dart';
import 'package:dio/dio.dart';

class ActionLogService {
  final Dio dio;
  final String baseUrl;

  const ActionLogService({
    required this.dio,
    required this.baseUrl,
  });

  Future<Result<ApiResponse<ActionLogDto>, Failure>> post(
      List<ActionLogDto> actionLogs) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.post<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/action-log',
        data: actionLogs,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, ActionLogDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Ghi action log thất bại',
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
