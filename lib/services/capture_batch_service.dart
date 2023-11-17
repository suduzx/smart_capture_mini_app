import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mpcore/utils/mp_file.dart';
import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/bool_response_dto.dart';
import 'package:smart_capture_mobile/dtos/business/bpm_doc_code_dto.dart';
import 'package:smart_capture_mobile/dtos/business/bpm_loan_info_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/request_metadata_attachment_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/request_metadata_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/dtos/exceptions/dio_error_ext.dart';
import 'package:smart_capture_mobile/dtos/exceptions/failures.dart';
import 'package:smart_capture_mobile/dtos/simple_result/api_result.dart';
import 'package:smart_capture_mobile/dtos/string_response_dto.dart';
import 'package:smart_capture_mobile/enum/exception_enum.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';

class CaptureBatchService with NumberUtil {
  final Dio dio;
  final String baseUrl;

  const CaptureBatchService({
    required this.dio,
    required this.baseUrl,
  });

  Future<Result<ApiResponse<CaptureBatchDto>, Failure>> create({
    required String branchCode,
    required String nationalId,
    String? captureName,
    String? customerName,
  }) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.post<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/capture-businesses/CATD/capture-batches',
        data: customerName == null
            ? {
                "branchCode": branchCode,
                "metadata": {
                  "customer_type": "KHCN",
                  "national_id": nationalId,
                }
              }
            : {
                "branchCode": branchCode,
                "metadata": {
                  "customer_type": "KHCN",
                  "national_id": nationalId,
                  "capture_name": captureName,
                  "customer_name": customerName,
                }
              },
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, CaptureBatchDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Thêm mới capture batch thất bại',
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

  Future<Result<ApiResponse<BoolResponseDto>, Failure>> delete({
    required String captureBatchId,
  }) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.delete<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/capture-batches/$captureBatchId',
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, BoolResponseDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Xóa capture batch thất bại',
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

  Future<Result<ApiResponse<CaptureBatchImageDto>, Failure>> uploadImage({
    required String captureBatchId,
    required String rootAlbumPath,
    required CaptureBatchImageDto image,
  }) async {
    try {
      int pageIndex = string2Int(image.metadata!.name
          .substring(image.metadata!.name.lastIndexOf('_') + 1));
      // MultipartFile mfImage = await FileUtils.getMultipartFile(
      //     '$rootAlbumPath${image.metadata!.path}');
      // MultipartFile mfThumbImage = await FileUtils.getMultipartFile(
      //     '$rootAlbumPath${image.metadata!.thumbPath}');
      // FormData formData = FormData();
      // formData.files.addAll([
      //   MapEntry("image", mfImage),
      //   MapEntry("thumbnail", mfThumbImage),
      // ]);
      // formData.fields.addAll([
      //   MapEntry("pageIndex", pageIndex.toString()),
      //   MapEntry("metaData", jsonEncode(image.metadata!)),
      //   MapEntry("id", image.id ?? ''),
      // ]);
      // Response<Map<String, dynamic>> response =
      //     await dio.post<Map<String, dynamic>>(
      //   '$baseUrl/sscan-rs/v3.0/capture-batches/$captureBatchId/images',
      //   data: formData,
      //   options: Options(
      //     contentType: "multipart/form-data",
      //     responseType: ResponseType.json,
      //   ),
      // );
      // return Result.success(
      //     ApiResponse.fromJson(response.data!, CaptureBatchImageDto.fromJson));
      RequestMetadataImageDto metadata = RequestMetadataImageDto(
        lat: image.metadata!.lat,
        lng: image.metadata!.lng,
        coordinatesInfo: image.metadata!.coordinatesInfo,
      );
      UserAccountDto? currentUser =
          await LocalUserRepository().getCurrentUser();
      final response = await MPUploadFile().uploadFile(
        url: '$baseUrl/sscan-rs/v3.0/capture-batches/$captureBatchId/images',
        files: [
          {"image": '$rootAlbumPath${image.metadata!.path}'},
          {"thumbnail": '$rootAlbumPath${image.metadata!.thumbPath}'},
        ],
        fields: image.id == null
            ? {
                "pageIndex": pageIndex,
                "metaData": jsonEncode(metadata),
              }
            : {
                "pageIndex": pageIndex,
                "metaData": jsonEncode(metadata),
                "id": image.id,
              },
        headers: {
          'Authorization':
              '${currentUser?.token.tokenType ?? 'Bearer'} ${currentUser?.token.accessToken ?? ''}',
          'Content-Type': 'multipart/form-data',
        },
      );
      Map<String, dynamic> responseData =
          Map<String, dynamic>.from(response['data'] as Map);
      if (responseData['status'] != 200) {
        return const Result.failure(
          DioErrorFailure(
            title: 'Upload image thất bại',
            exceptionEnum: ExceptionEnum.responseException,
            message: 'Upload image thất bại',
          ),
        );
      }
      return Result.success(
          ApiResponse.fromJson(responseData, CaptureBatchImageDto.fromJson));
    } catch (e) {
      debugPrint('CaptureBatchService.uploadImage: ${e.toString()}');
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Upload image thất bại',
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

  Future<Result<ApiResponse<CaptureBatchPdfDto>, Failure>> uploadPdf({
    required String captureBatchId,
    required String rootAlbumPath,
    required MetadataPdfDto metadataPdfDto,
    required int pageIndex,
  }) async {
    try {
      // MultipartFile mfPdf = await FileUtils.getMultipartFile(
      //     '$rootAlbumPath${metadataPdfDto.path}');
      // FormData formData = FormData.fromMap({
      //   "file": mfPdf,
      //   "pageIndex": pageIndex,
      //   "metaData": jsonEncode(metadataPdfDto),
      // });
      // Response<Map<String, dynamic>> response =
      //     await dio.post<Map<String, dynamic>>(
      //   '$baseUrl/sscan-rs/v3.0/capture-batches/$captureBatchId/attachments',
      //   data: formData,
      //   options: Options(
      //     contentType: "multipart/form-data",
      //     responseType: ResponseType.json,
      //   ),
      // );
      // return Result.success(
      //     ApiResponse.fromJson(response.data!, CaptureBatchPdfDto.fromJson));
      RequestMetadataAttachmentDto metaData =
          RequestMetadataAttachmentDto(dataFileIds: metadataPdfDto.dataFileIds);
      UserAccountDto? currentUser =
          await LocalUserRepository().getCurrentUser();
      final response = await MPUploadFile().uploadFile(
        url:
            '$baseUrl/sscan-rs/v3.0/capture-batches/$captureBatchId/attachments',
        files: [
          {"file": '$rootAlbumPath${metadataPdfDto.path}'},
        ],
        fields: {
          "pageIndex": pageIndex,
          "metaData": jsonEncode(metaData),
        },
        headers: {
          'Authorization':
              '${currentUser?.token.tokenType ?? 'Bearer'} ${currentUser?.token.accessToken ?? ''}',
          'Content-Type': 'multipart/form-data',
        },
      );
      Map<String, dynamic> responseData =
          Map<String, dynamic>.from(response['data'] as Map);
      if (responseData['status'] != 200) {
        return const Result.failure(
          DioErrorFailure(
            title: 'Upload pdf thất bại',
            exceptionEnum: ExceptionEnum.responseException,
            message: 'Upload pdf thất bại',
          ),
        );
      }
      return Result.success(
          ApiResponse.fromJson(responseData, CaptureBatchPdfDto.fromJson));
    } catch (e) {
      debugPrint('CaptureBatchService.uploadPdf: ${e.toString()}');
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Upload pdf thất bại',
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

  Future<Result<ApiResponse<StringResponseDto>, Failure>> deleteImages({
    required String captureBatchImageIds,
  }) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.delete<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/images?status=delete&imageIds=$captureBatchImageIds',
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, StringResponseDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Xóa images thất bại',
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

  Future<Result<ApiResponse<StringResponseDto>, Failure>> deletePDFs({
    required String captureBatchPdfIds,
  }) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.delete<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/attachments?attachmentIds=$captureBatchPdfIds',
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, StringResponseDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Xóa pdfs thất bại',
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

  Future<Result<ApiResponse<BPMDocCodeDto>, Failure>> getListDocCode() async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.get<Map<String, dynamic>>(
        '$baseUrl/sscan-intergration/bpm-indiv/getListDocCode',
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, BPMDocCodeDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Không thể getListDocCode',
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

  Future<Result<ApiResponse<BPMLoanInfoDto>, Failure>> getLoanInfo({
    required String codeT24,
    int? statusId,
    String? loanId,
  }) async {
    String api =
        '$baseUrl/sscan-intergration/bpm-indiv/getLoanInfo?codeT24=$codeT24';
    if (statusId != null) {
      api = '$api&statusId=$statusId';
    }
    if (loanId != null) {
      api = '$api&loanId=$loanId';
    }
    try {
      Response<Map<String, dynamic>> response =
          await dio.get<Map<String, dynamic>>(
        api,
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, BPMLoanInfoDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Không thể getLoanInfo',
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

  Future<Result<ApiResponse<CaptureBatchDto>, Failure>> updateInfoT24({
    required String captureBatchId,
  }) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.patch<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/capture-batches/$captureBatchId/update-info-t24',
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, CaptureBatchDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Có lỗi xảy ra',
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

  Future<Result<ApiResponse<StringResponseDto>, Failure>> syncBpm({
    required String albumId,
    required String encryptedText,
  }) async {
    try {
      Response<Map<String, dynamic>> response =
          await dio.post<Map<String, dynamic>>(
        '$baseUrl/sscan-rs/v3.0/capture-batches/$albumId/capture-tree-values/sync_bpm',
        data: encryptedText,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      return Result.success(
          ApiResponse.fromJson(response.data!, StringResponseDto.fromJson));
    } catch (e) {
      if (e is DioErrorExt) {
        return Result.failure(
          DioErrorFailure(
            title: 'Không thể getLoanInfo',
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
