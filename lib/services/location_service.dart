import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/business/coordinates_info_dto.dart';
import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/dtos/exceptions/failures.dart';
import 'package:smart_capture_mobile/dtos/simple_result/api_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LocationService {
  final Dio dio;
  final String baseUrl;

  const LocationService({
    required this.dio,
    required this.baseUrl,
  });

  Future<Result<ApiResponse<CoordinatesInfoDto>, Failure>>
      getCoordinatesInfoByLatLng(String lat, String lng) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.get<Map<String, dynamic>>(
        '$baseUrl/sscan-intergration/cmv-map/info?lat=$lat&lng=$lng',
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, CoordinatesInfoDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Truy vấn địa điểm thất bại',
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

  Future<Result<CoordinatesInfoDto?, Failure>> getInfoByLatLng(
      String lat, String lng) async {
    debugPrint('LocationService.getInfoByLatLng: ($lat - $lng)');
    try {
      Response<Map<String, dynamic>> response =
          await dio.get<Map<String, dynamic>>(
        '$baseUrl/searchbycoordinate?address=$lat%2C$lng',
        options: Options(responseType: ResponseType.json),
      );
      return Result.success(CoordinatesInfoDto.fromJson(response.data!));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Truy vấn địa điểm thất bại',
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
