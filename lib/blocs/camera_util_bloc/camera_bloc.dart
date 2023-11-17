import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_edit_watermark/flutter_image_edit_watermark.dart';
import 'package:mp_camera_preview/mp_camera_preview.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/blocs/camera_util_bloc/camera_event.dart';
import 'package:smart_capture_mobile/blocs/camera_util_bloc/camera_state.dart';
import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/coordinates_info_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/dtos/exceptions/failures.dart';
import 'package:smart_capture_mobile/dtos/simple_result/api_result.dart';
import 'package:smart_capture_mobile/enum/action_log_enum.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/repositories/local_capture_business_repository.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/services/location_service.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/jwt_decoder.dart';
import 'package:smart_capture_mobile/utils/log_util.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';
import 'package:smart_capture_mobile/utils/mixin/permission_handler_util.dart';
import 'package:smart_capture_mobile/utils/refresh_token_util.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState>
    with PermissionHandlerUtil, DatetimeUtil, NumberUtil {
  CameraBloc(super.initialState) {
    on<OnCameraTapEvent>(_onCameraTapEvent);
    on<TakePhotoEvent>(_takePhotoEvent);
    on<AddLocationAndWaterMarkEvent>(_addLocationAndWaterMarkEvent);
  }

  FutureOr<void> _onCameraTapEvent(
      OnCameraTapEvent event, Emitter<CameraState> emit) async {
    bool hasCameraPermission = await requestCameraPermission();
    if (!hasCameraPermission) {
      emit(
        OnCameraTapEventError(
          title: 'Không thể mở máy ảnh',
          message:
              'Vui lòng cấp quyền truy cập máy ảnh cho ứng dụng trên thiết bị của bạn',
          titleButton: 'ĐÃ HIỂU',
          datetime: DateTime.now().toUtc().toString(),
        ),
      );
    } else {
      final int? limitAlbumImageParam = await LocalCaptureBusinessRepository()
          .getLimitNumberOfImagePerAlbum();
      final int? locationChangeInterval =
          await LocalCaptureBusinessRepository().getLocationChangeInterval();
      if (limitAlbumImageParam == null || locationChangeInterval == null) {
        emit(
          OnCameraTapEventError(
            title: 'Cấu hình chưa được đồng bộ',
            message:
                'Vui lòng đăng nhập lại để đồng bộ thêm cấu hình từ hệ thống',
            titleButton: 'ĐÃ HIỂU',
            datetime: DateTime.now().toUtc().toString(),
          ),
        );
      } else {
        emit(OnCameraTapEventSuccess(
          limitAlbumImageParam: limitAlbumImageParam,
          locationChangeInterval: locationChangeInterval,
        ));
      }
    }
  }

  FutureOr<void> _takePhotoEvent(
      TakePhotoEvent event, Emitter<CameraState> emit) async {
    CaptureBatchDto albumDto = event.albumDTO;
    if (albumDto.metadata!.images!.length >= event.limitAlbumImageParam) {
      emit(TakePhotoEventError(
        datetime: DateTime.now().toUtc().toString(),
        exceeding: true,
        title: 'Album đã đủ ${event.limitAlbumImageParam} ảnh',
        message: 'Vui lòng kiểm tra lại album hoặc xóa các ảnh không cần thiết',
        titleButton: 'OK',
      ));
      return;
    }

    bool hasLocationPermission = await requestLocationPermission();
    if (!hasLocationPermission) {
      emit(TakePhotoEventError(
        datetime: DateTime.now().toUtc().toString(),
        title: 'Không thể truy cập vị trí',
        message:
            'Vui lòng cấp quyền truy cập vị trí cho ứng dụng trên thiết bị của bạn',
        titleButton: 'ĐÃ HIỂU',
      ));
      return;
    }

    UserAccountDto? currentUser = await LocalUserRepository().getCurrentUser();
    if (currentUser == null || JwtDecoder().isAccessTokenExpired(currentUser)) {
      String message = '';
      await RefreshTokenUtil().refreshToken((newUser, dio) {}, (error) {
        message = error;
      });
      if (message.isNotEmpty) {
        emit(TakePhotoEventError(
          datetime: DateTime.now().toUtc().toString(),
          title: 'Refresh token thất bại',
          message: message,
          titleButton: 'ĐÃ HIỂU',
        ));
        return;
      }
    }

    await LogUtil().addActionLog(ActionLogEnum.takePhoto);
    String absoluteAlbumPath =
        '${await FileUtils.getRootAlbumPath()}${albumDto.metadata!.path}';
    try {
      final lastImageName =
          '${albumDto.metadata!.captureName}_${albumDto.metadata!.lastImageIndex.toString().padLeft(3, '0')}';
      List<String> listImagesName = [lastImageName];

      dynamic success = await CameraPreview().openCamera(
        priorityDisplay: albumDto.metadata!.priorityDisplay,
        limitAlbumImageParam: event.limitAlbumImageParam,
        countAlbumImage: albumDto.metadata!.images!.length,
        listImagesName: listImagesName,
        albumName: albumDto.metadata!.captureName,
        absoluteAlbumPath: absoluteAlbumPath,
        locationChangeIntervalMs: event.locationChangeInterval * 1000,
        accessToken: currentUser!.token.accessToken,
        baseMapUrl: F.apiUrl,
      );

      if (success is! List) {
        emit(TakePhotoEventError(
          datetime: DateTime.now().toUtc().toString(),
          title: 'Lưu ảnh không thành công',
          message: 'Có lỗi xảy ra. Vui lòng thử lại!',
          titleButton: 'OK',
        ));
        return;
      }

      if (success.isEmpty) {
        emit(const NotTakeMorePhoto());
        return;
      }
      List<CaptureBatchImageDto> images = List.empty(growable: true);
      await Future.forEach(success, (element) async {
        Map<dynamic, dynamic> map = element as Map<dynamic, dynamic>;
        String imageName = map['imageName'];
        String imagePath = '${albumDto.metadata!.path}/$imageName.jpg';
        String? lat = map['lat'];
        String? lng = map['lng'];
        String? createdDate = map['createdDate'];
        String? coordinatesInfo = map['coordinatesInfoDto'];
        CaptureBatchImageDto image = CaptureBatchImageDto(
          metadata: MetadataImageDto(
            name: imageName,
            path: imagePath,
            thumbPath: '',
            lat: lat,
            lng: lng,
            coordinatesInfo: coordinatesInfo == null
                ? null
                : CoordinatesInfoDto.fromJson(Map<String, dynamic>.from(
                    jsonDecode(coordinatesInfo) as Map)),
            createdDate: createdDate ?? '',
            createdByUser: currentUser.username,
            modifiedDate: DateTime.now().toUtc().toString(),
            modifiedByUser: currentUser.username,
            status: FileStatus.inUse,
          ),
        );
        images.add(image);
      });
      // Lấy lại album từ local rồi add danh sách ảnh mới vào đề phòng bị mất thông tin đồng bộ
      final localCaptureBatchRepository = LocalCaptureBatchRepository();
      List<CaptureBatchDto> albums =
          await localCaptureBatchRepository.getAll(isReadOnly: true);
      CaptureBatchDto currentAlbum = albums.firstWhere(
          (album) => album.metadata!.path == albumDto.metadata!.path);
      currentAlbum.metadata!.images!.addAll(images.toList());
      final imageNumbers = images
          .map((image) => int.parse(image.metadata!.name.split('_').last))
          .toList();
      currentAlbum.metadata!.lastImageIndex =
          imageNumbers.isNotEmpty ? imageNumbers.reduce(max) : 0;
      await localCaptureBatchRepository.sortThenUpdate(currentAlbum);
      emit(
          TakePhotoEventSuccess(albumDto: currentAlbum, image: success.length));
    } catch (e) {
      debugPrint('onCameraTap: $e');
      emit(TakePhotoEventError(
        datetime: DateTime.now().toUtc().toString(),
        title: 'Lưu ảnh không thành công',
        message: 'Có lỗi xảy ra. Vui lòng thử lại!',
        titleButton: 'OK',
      ));
    }
  }

  FutureOr<void> _addLocationAndWaterMarkEvent(
      AddLocationAndWaterMarkEvent event, Emitter<CameraState> emit) async {
    LocationService locationService =
        LocationService(dio: DioD().dio, baseUrl: F.apiUrl);
    CaptureBatchDto albumDto = event.albumDTO;
    bool error = false;
    String rootAlbumPath = await FileUtils.getRootAlbumPath();
    List<CaptureBatchImageDto> images = List.empty(growable: true);
    await Future.forEach<CaptureBatchImageDto>(albumDto.metadata!.images!,
        (image) async {
      if (image.metadata!.thumbPath.isNotEmpty &&
          image.metadata!.thumbPath != image.metadata!.path) {
        return;
      }
      try {
        if (image.metadata!.coordinatesInfo == null) {
          Result<ApiResponse<CoordinatesInfoDto>, Failure> result =
              await locationService.getCoordinatesInfoByLatLng(
                  image.metadata!.lat!, image.metadata!.lng!);
          result.when(
            success: (coordinatesInfoDto) {
              image.metadata!.coordinatesInfo =
                  coordinatesInfoDto.data!.result!.first;
            },
            failure: (failure) {
              error = true;
            },
          );
        }
        await FlutterImageEditWatermark().editImage(
          '$rootAlbumPath${image.metadata!.path}',
          _generateWatermarkText(image),
          Colors.white.value,
        );
        if (image.metadata!.thumbPath.isEmpty ||
            image.metadata!.thumbPath == image.metadata!.path) {
          String? thumbImageName = await FileUtils.compressThumbImage(
              '$rootAlbumPath${albumDto.metadata!.path}', image.metadata!.name);
          image.metadata!.thumbPath = thumbImageName == null
              ? image.metadata!.path
              : '${albumDto.metadata!.path}/$thumbImageName.jpg';
        }
        images.add(image);
      } catch (e) {
        error = true;
        debugPrint('onCameraTap - addWaterMark2Image: $e');
      }
    });
    final localCaptureBatchRepository = LocalCaptureBatchRepository();
    List<CaptureBatchDto> albums =
        await localCaptureBatchRepository.getAll(isReadOnly: true);
    CaptureBatchDto currentAlbum = albums
        .firstWhere((album) => album.metadata!.path == albumDto.metadata!.path);
    for (var image in images) {
      int indexImage = currentAlbum.metadata!.images!.indexWhere(
          (element) => element.metadata!.path == image.metadata!.path);
      currentAlbum.metadata!.images![indexImage] = image;
    }
    await localCaptureBatchRepository.sortThenUpdate(currentAlbum);
    if (error) {
      emit(AddLocationAndWaterMarkEventSuccess(
        alertSuccess: 'Đã lưu thành công ${event.image} ảnh',
        title: 'Lỗi lấy thông tin vị trí',
        message:
            'Đã có ảnh không thể lấy vị trí và thêm water mark. Vui lòng tìm, xóa ảnh thêm lỗi và thử lại',
        titleButton: 'OK',
      ));
    } else {
      emit(AddLocationAndWaterMarkEventSuccess(
        alertSuccess: 'Đã lưu thành công ${event.image} ảnh',
      ));
    }
  }

  String _generateWatermarkText(CaptureBatchImageDto image) {
    List<String> listAddress =
        (image.metadata?.coordinatesInfo?.address ?? '').split(',');
    String address = '';
    String newLine = '';

    for (int i = 0; i < listAddress.length; i++) {
      if (i == listAddress.length - 1) {
        address += listAddress[i];
      } else if (newLine.length < 36) {
        if (newLine.length + listAddress[i].length < 36) {
          address += '${listAddress[i]},';
          newLine += '${listAddress[i]},';
        } else {
          newLine = '${listAddress[i].replaceFirst(' ', '\n')},';
          address += newLine;
        }
      } else {
        newLine = '${listAddress[i].replaceFirst(' ', '\n')},';
        address += newLine;
      }
    }
    DateTime createdDate = string2Datetime(image.metadata!.createdDate);
    String watermarkText =
        '${dateTime2DdMmYyyy(createdDate)} ${dateTime2HhMiSs(createdDate)}\n';
    watermarkText += '${image.metadata?.lat}, ${image.metadata?.lng}\n';
    watermarkText += address;

    return watermarkText;
  }
}
