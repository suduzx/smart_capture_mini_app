import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/auth/key_cloak_response_dto.dart';
import 'package:smart_capture_mobile/dtos/auth/sign_in_resquest_dto.dart';
import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/dtos/exceptions/failures.dart';
import 'package:smart_capture_mobile/dtos/simple_result/api_result.dart';
import 'package:dio/dio.dart';

class KeyCloakService {
  final Dio dio;
  final String baseUrl;
  final String realm;

  const KeyCloakService({
    required this.dio,
    required this.baseUrl,
    required this.realm,
  });

  Future<Result<ApiResponse<KeyCloakResponseDto>, Failure>> signIn(
      SignInRequestDto signInRequestDto) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.post<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/auth/login',
        data: signInRequestDto.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, KeyCloakResponseDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: e.title,
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

  Future<Result<ApiResponse<KeyCloakResponseDto>, Failure>> refreshToken(
      String refreshToken, String clientId) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.post<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/auth/access-token',
        data: {
          "refreshToken": refreshToken,
          "clientId": clientId,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, KeyCloakResponseDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: e.title,
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
